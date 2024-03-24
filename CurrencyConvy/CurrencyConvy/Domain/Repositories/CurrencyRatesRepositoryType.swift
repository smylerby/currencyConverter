//
//  CurrencyRatesRepositoryType.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

protocol CurrencyRatesRepositoryType {
    func getRates(handler: ((Error?) -> Void)?) async
}

protocol CurrencyRatesRepositoryHolderType {
    var currencyRatesRepository: CurrencyRatesRepositoryType { get }
}

