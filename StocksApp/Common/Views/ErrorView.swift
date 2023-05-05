//
//  ErrorView.swift
//  StocksApp
//
//  Created by renupunjabi on 5/2/23.
//

import SwiftUI

struct ErrorView: View {
    
    private enum Constants {
        static let ErrorTitle = NSLocalizedString("Whoops!", comment: "Loading error title")
        static let ErrorDescription = NSLocalizedString("An error occured and we're\ncurrently working on it.", comment: "Loading error description")
    }
    
    var errorTitle: String = ""
    var errorDescription: String = ""
    
    init(errorTitle: String = Constants.ErrorTitle, errorDescription: String = Constants.ErrorDescription) {
        self.errorTitle = errorTitle
        self.errorDescription = errorDescription
    }
    
    var body: some View {
        ZStack {
            DesignTool.errorGradient()
                .ignoresSafeArea(.all)
            VStack{
                Text(errorTitle)
                    .font(.title)
                    .padding()
                Text(errorDescription)
                    .font(.title2)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
