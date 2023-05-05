//
//  AsyncState.swift
//  StocksApp
//
//  Created by renupunjabi on 5/2/23.
//

import Foundation
import Combine

enum AsyncState: Equatable {
    case initial
    case loading
    case loaded
    case error
    
    public var isLoaded: Bool { self == .loaded }
    public var isLoading: Bool { self == .loading }
    public var isInitial: Bool { self == .initial }
    public var isError: Bool { self == .error }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
