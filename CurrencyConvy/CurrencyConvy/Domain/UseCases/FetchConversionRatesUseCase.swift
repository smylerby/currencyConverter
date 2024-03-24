//
//  FetchConversionRatesUseCase.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

protocol FetchConversionRatesUseCase {
    func getRates() async
}

extension FetchConversionRatesUseCase where Self: CurrencyRatesRepositoryHolderType {
    func getRates() async {
        return await currencyRatesRepository.getRates()
    }
}
