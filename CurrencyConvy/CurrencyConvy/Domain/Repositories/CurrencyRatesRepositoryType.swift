//
//  CurrencyRatesRepositoryType.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

protocol CurrencyRatesRepositoryType {
    func getRates() -> [String: Double]
}

protocol CurrencyRatesRepositoryHolderType {
    var currencyRatesRepository: CurrencyRatesRepositoryType { get }
}

