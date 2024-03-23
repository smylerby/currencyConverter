//
//  CurrencyRatesRoute.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

enum CurrencyRatesRoute {
    
    case latest
    
    var url: URL {
        switch self {
            case .latest:
            let path = Constants.apiPath
            return URL(string: path+Constants.apiKey)!
        }
    }
}
