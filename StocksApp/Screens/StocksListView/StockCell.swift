//
//  StockCell.swift
//  StocksApp
//
//  Created by renupunjabi on 5/1/23.
//

import SwiftUI

struct StockCell: View {
    
    let stock: Stock
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading) {
                Text("\(stock.ticker)")
                .bold()
                .font(.title3)
                Text(stock.name)
                    .font(.body)
                    .lineLimit(1)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(stock.price)")
                    .bold()
                    .font(.headline)
                Text("Qty: \(stock.quantity)")
                        .font(.subheadline)
            }
        }
        .background(Color.clear)
    }
}

struct StockCell_Previews: PreviewProvider {
    static var previews: some View {
        StockCell(stock: MockStock.stock)
    }
}
