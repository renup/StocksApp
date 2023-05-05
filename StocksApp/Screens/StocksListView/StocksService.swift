//
//  StocksService.swift
//  StocksApp
//
//  Created by renupunjabi on 5/1/23.
//

import Foundation
import Combine

protocol StocksServiceProtocol {
    func fetchStocks() -> Future<[StockModel], AsyncError>
}

class StocksService: StocksServiceProtocol {
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchStocks() -> Future<[StockModel], AsyncError> {
        return Future { promise in
            guard let url = URL(string: Constants.stocksListUrl) else {
                promise(.failure(.badUrl))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    promise(.failure(.outOfService))
                    return
                }
                
                guard let dt = data else {
                    promise(.failure(.emptyData))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    promise(.failure(.badResponse))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(StocksListResponse.self, from: dt)
                    promise(.success(result.stocks))
                } catch {
                    promise(.failure(.decodingError))
                }
                
            }.resume()
        }
    }
    
    
    
}
