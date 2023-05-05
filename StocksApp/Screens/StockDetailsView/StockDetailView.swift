//
//  StockDetailView.swift
//  StocksApp
//
//  Created by renupunjabi on 5/2/23.
//

import SwiftUI

struct StockDetailView: View {
    let stock: Stock
    
    var body: some View {
        Text(stock.name)
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StockDetailView(stock: MockStock.stock)
    }
}
