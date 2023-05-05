//
//  EmptyStocksView.swift
//  StocksApp
//
//  Created by renupunjabi on 5/3/23.
//

import Foundation
import SwiftUI

struct EmptyStocksView: View {
    
    var body: some View {
        ZStack {
            DesignTool.appGradient()
                .ignoresSafeArea(.all)
            VStack(alignment: .center) {
                Text("Welcome to Stocks")
                    .font(.title)
                Text ("Your Stocks will appear here.")
                    .font(.title2)
            }
        }
    }
    
}


