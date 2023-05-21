//
//  StocksListViewModelTests.swift
//  StocksAppTests
//
//  Created by renupunjabi on 5/1/23.
//

import XCTest
import Combine
@testable import StocksApp

enum FileName: String {
    case stocks_decoding_failure
    case stocks_empty
    case stocks_success
    case stocks_failure_badResponse
}

final class StocksListViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    override func tearDownWithError() throws {
        cancellables = []
    }
    
    func test_fetchStocks_isEmpty() {
        let viewModel = StocksListViewModel(service: MockStocksService(fileName: .stocks_empty))
        let exp = XCTestExpectation(description: "fetch stocks success is empty")
        viewModel.fetchStocks()
        
        viewModel.$state
            .sink { completion in
                XCTFail("Fetch stocks should not fail")
            } receiveValue: { state in
                switch state {
                case .initial, .loading:
                    break
                case .loaded:
                    XCTAssertEqual(viewModel.stockGroup.count, 0)
                    XCTAssertEqual(state, .loaded)
                    exp.fulfill()
                case .error:
                    XCTFail()
                }
            }
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_fetchStocks_failure1() {
        let viewModel = StocksListViewModel(service: MockStocksService(fileName: .stocks_failure_badResponse))
        let exp = XCTestExpectation(description: "fetch stocks failure")
        viewModel.fetchStocks()
 
        viewModel.$state
            .sink { completion in
                XCTFail("Fetch stocks should not fail")
            } receiveValue: { state in
                switch state {
                case .initial, .loading:
                    break
                case .loaded:
                    XCTFail()
                case .error:
                    XCTAssertEqual(state, .error)
                    XCTAssertEqual(viewModel.stockGroup.count, 0)
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_fetchStocks_success() {
        let mockService = MockStocksService(fileName: .stocks_success)
        let viewModel = StocksListViewModel(service: mockService)
        let exp = XCTestExpectation(description: "fetch stocks success")
        viewModel.fetchStocks()
        
        viewModel.$state
            .sink { state in
                switch state {
                case .initial, .loading:
                    break
                case .loaded:
                    let stockSection = viewModel.stockGroup.first
                    XCTAssertEqual(stockSection?.timestamp, "12:23 PM PDT, Tuesday, April 18, 2023")
                    let stock = stockSection?.stocks.first
                    XCTAssertEqual(stock?.name, "S&P 500")
                    XCTAssertEqual(stock?.ticker, "GSPC")
                    XCTAssertEqual(stock?.currency, "USD")
                    exp.fulfill()
                case .error:
                    XCTFail()
                }
                if case .loaded = state {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)
        wait(for: [exp], timeout: 5.0)
        XCTAssertFalse(viewModel.stockGroup.isEmpty)
    }
    
    func test_fetchStocks_decoding_failure() {
        let viewModel = StocksListViewModel(service: MockStocksService(fileName: .stocks_decoding_failure))
        let exp = XCTestExpectation(description: "fetch stocks failure")
        
        var receivedError: Error?
        
        viewModel.fetchStocks()
        
        viewModel.$stockGroup
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    receivedError = error
                    XCTAssertEqual(error.localizedDescription, AsyncError.decodingError.description)
                case .finished:
                    break
                }
            }, receiveValue: { _ in
                XCTAssertTrue(viewModel.stockGroup.isEmpty)
                exp.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.$state
            .sink { state in
                if case .error = state {
                    if let error = receivedError as? AsyncError, case .decodingError = error {
                        exp.fulfill()
                    }
                }
            }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1.0)
    }
    
}



class MockStocksService: StocksServiceProtocol {
    
    fileprivate var fileName: FileName
    
    fileprivate init(fileName: FileName) {
        self.fileName = fileName
    }
    
    private func loadMockData(_ file: String) -> URL? {
        return Bundle(for: type(of: self)).url(forResource: file, withExtension: "json")
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchStocks() -> Future<[StocksApp.StockModel], AsyncError> {
        return Future {[weak self] promise in
            guard let self = self else { return }
            
            guard let url = self.loadMockData(self.fileName.rawValue) else {
                promise(.failure(.badUrl))
                return
            }
            
            let data = try! Data(contentsOf: url)
            
            do {
                let response = try JSONDecoder().decode(StocksListResponse.self, from: data)
                promise(.success(response.stocks))
            } catch {
                promise(.failure(.decodingError))
            }
        }
    }
    
    
}
