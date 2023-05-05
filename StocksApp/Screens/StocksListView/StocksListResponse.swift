//
//  StocksListResponse.swift
//  StocksApp
//
//  Created by renupunjabi on 5/1/23.
//

import Foundation

struct StocksListResponse: Codable {
    let stocks: [StockModel]
}

struct StockModel: Codable {
    let ticker: String
    let name: String
    let currency: String
    let currentPriceCents: Int
    let quantity: Int?
    let currentPriceTimestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case ticker, name, currency, quantity
        case currentPriceCents = "current_price_cents"
        case currentPriceTimestamp = "current_price_timestamp"
    }
}
