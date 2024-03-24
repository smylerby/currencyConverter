//
//  CurrencyRatesRoute.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

enum CurrencyRatesRoute {
    
    case update
    
    var url: URL {
        switch self {
            case .update:
            let path = Constants.apiPath
            return URL(string: path+Constants.apiKey)!
        }
    }
}
