//
//  Extensions+.swift
//  StocksApp
//
//  Created by renupunjabi on 5/1/23.
//

import Foundation

extension String {
    func removeSpecialChars() -> String {
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]+", options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: "")
    }
    
}

extension Date {
    func convertUnixTimestampToLocalDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a zzz, EEEE, MMMM d, yyyy"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}

extension Double {
    func formatPrice() -> String {
        let formattedString = String(format: "$%.2f", self)
        let regex = try! NSRegularExpression(pattern: "(\\d)(?=(\\d{3})+(?!\\d))", options: [])
        let range = NSMakeRange(0, formattedString.count)
        let commaSeparatedString = regex.stringByReplacingMatches(in: formattedString, options: [], range: range, withTemplate: "$1,")
        return commaSeparatedString.replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
    }
    
}

struct MockStock {
    static let stock = Stock(model: StockModel(ticker: "SPG", name: "Simon property Group", currency: "USD", currentPriceCents: 34, quantity: 1, currentPriceTimestamp: 1))
}
