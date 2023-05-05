//
//  StocksListViewModel.swift
//  StocksApp
//
//  Created by renupunjabi on 5/1/23.
//

import Foundation
import Combine

struct Stock: Identifiable {
    let id = UUID()
    let ticker: String
    let name: String
    let currency: String
    var price: String
    let quantity: String
    
    init(model: StockModel) {
        ticker = model.ticker.removeSpecialChars()
        name = model.name
        currency = model.currency
        price = "0"
        quantity = String(model.quantity ?? 0)
        dollars(model.currentPriceCents)
    }
    
    mutating func dollars(_ cents: Int) {
        let dollars = Double(cents) / 100.0
        self.price = dollars.formatPrice()
    }
}

struct StockSection: Identifiable {
    let id = UUID()
    let timestamp: String
    let stocks: [Stock]
}

class StocksListViewModel: ObservableObject {
    @Published var state: AsyncState = .initial
    
    @Published var stockGroup = [StockSection]()
    
    var service: StocksServiceProtocol
    var cancellables = Set<AnyCancellable>()
    
    init(service: StocksServiceProtocol) {
        self.service = service
    }
    
    func fetchStocks() {
        state = .loading
        service.fetchStocks()
            .mapError { error -> Error in
                self.state = .error
                return error
            }
            .sink(receiveCompletion: { _ in }, receiveValue: { stocksModel in
                self.processStockResponse(stocksModel)
                self.state = .loaded
            })
            .store(in: &self.cancellables)
    }
    
    private func processStockResponse(_ stocksModel: [StockModel]) {
        let groupedStocks = Dictionary(grouping: stocksModel, by: { Date(timeIntervalSince1970: TimeInterval($0.currentPriceTimestamp)) })
        let sortedGroupStockKeys = groupedStocks.keys.sorted()
        
        var stockGroup = [StockSection]()
        for stockKey in sortedGroupStockKeys {
            guard let stockModelArr = groupedStocks[stockKey] else { continue }
            var stockArray = [Stock]()
            for ele in stockModelArr {
                let stock = Stock(model: ele)
                stockArray.append(stock)
            }
            
            let timeString = stockKey.convertUnixTimestampToLocalDateString()
            
            stockGroup.append(StockSection(timestamp: timeString, stocks: stockArray))
        }
        self.stockGroup = stockGroup
    }
}
