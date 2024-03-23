//
//  CurrencyPair.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

struct CurrencyRatesResponse: Codable {
    let data: [String: Double]
}

struct CurrencyPair: Hashable {
    let sourceCurrency: String
    let targetCurrency: String
    let amount: Double
    let conversionRate: Double
}
