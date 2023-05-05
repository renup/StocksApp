//
//  DesignStyle.swift
//  StocksApp
//
//  Created by renupunjabi on 5/3/23.
//

import Foundation
import SwiftUI

struct DesignTool {
        
    static func appGradient() -> LinearGradient {
        return LinearGradient(colors: [.green, Color(.link), .white], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    static func errorGradient() -> LinearGradient {
        return LinearGradient(colors: [.green, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
