//
//  AsyncError.swift
//  StocksApp
//
//  Created by renupunjabi on 5/2/23.
//

import Foundation

enum AsyncError: Error {
    case badUrl
    case emptyData
    case decodingError
    case badResponse
    case outOfService
    
    var description: String {
        switch self {
        case .badUrl:
            return "Bad Url"
        case .emptyData:
            return "Empty data"
        case .decodingError:
            return "Decoding error"
        case .badResponse:
            return "Malformed response"
        case .outOfService:
            return "Service unavailable"
        }
    }
}
