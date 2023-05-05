//
//  StocksListView.swift
//  StocksApp
//
//  Created by renupunjabi on 5/1/23.
//

import SwiftUI

struct StocksListView: View {
    @StateObject var viewModel = StocksListViewModel(service: StocksService())
    //    @ObservedObject var viewModel: StocksListViewModel
    
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignTool.appGradient()
                    .ignoresSafeArea(.all)
                
                VStack(alignment: .leading) {
                    switch viewModel.state {
                    case .initial, .loading:
                        // show progress bar
                        ProgressView("Loading ...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .bold()
                            .font(.title)
                            .foregroundColor(.black)
                    case .loaded:
                        // first time user
                        if viewModel.stockGroup.isEmpty {
                            EmptyStocksView()
                        } else {
                            List {
                                ForEach(viewModel.stockGroup) { section in
                                    Section(header: Text(section.timestamp)) {
                                        ForEach(section.stocks) { stock in
                                            NavigationLink {
                                                StockDetailView(stock: stock)
                                            } label: {
                                                StockCell(stock: stock)
                                            }
                                        }
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .scrollIndicators(.hidden)
                        }
                    case .error:
                        ErrorView()
                    }
                }
            }
            .navigationTitle("Stocks")
            .onAppear { viewModel.fetchStocks() }
        }
    }
    
}

struct StocksListView_Previews: PreviewProvider {
    static var previews: some View {
        StocksListView(viewModel: StocksListViewModel(service: StocksService()))
    }
}
