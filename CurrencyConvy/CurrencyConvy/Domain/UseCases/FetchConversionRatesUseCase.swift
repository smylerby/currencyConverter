//
//  FetchConversionRatesUseCase.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

protocol FetchConversionRatesUseCase {
    func getRates(handler: ((Error?) -> Void)?) async
}

extension FetchConversionRatesUseCase where Self: CurrencyRatesRepositoryHolderType {
    func getRates(handler: ((Error?) -> Void)?) async {
        return await currencyRatesRepository.getRates(handler: handler)
    }
}
