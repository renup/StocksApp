//
//  StocksAppApp.swift
//  StocksApp
//
//  Created by renupunjabi on 5/4/23.
//

import SwiftUI

@main
struct StocksAppApp: App {
//    @StateObject var viewModel = StocksListViewModel(service: StocksService())
    
    var body: some Scene {
        WindowGroup {
//            StocksListView(viewModel: viewModel)
            StocksListView()
        }
    }
}
