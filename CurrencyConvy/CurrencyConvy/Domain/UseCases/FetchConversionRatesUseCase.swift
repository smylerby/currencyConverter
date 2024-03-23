//
//  FetchConversionRatesUseCase.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

protocol FetchConversionRatesUseCase {
    func getRates() -> [String: Double]
}

extension FetchConversionRatesUseCase where Self: CurrencyRatesRepositoryHolderType {
    func getRates() -> [String: Double] {
        return currencyRatesRepository.getRates()
    }
}
