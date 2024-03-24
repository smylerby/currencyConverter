//
//  FavouriteCurrencyUseCase.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 24.03.24.
//

import Foundation

protocol FavouriteCurrencyUseCase {
    var storredSourceCurrencyIndex: Int { get }
    var storredTargetCurrencyIndex: Int { get }
    func updateStoredCurrency(for type: PickedCurrencyType, value: Int)
}

extension FavouriteCurrencyUseCase where Self: ConversionHistoryRepositoryHolderType {
    var storredSourceCurrencyIndex: Int {
        return conversionHistoryRepository.storredSourceCurrencyIndex
    }
    
    var storredTargetCurrencyIndex: Int {
        return conversionHistoryRepository.storredTargetCurrencyIndex
    }
    
    func updateStoredCurrency(for type: PickedCurrencyType, value: Int) {
        conversionHistoryRepository.updateStoredCurrency(for: type, value: value)
    }
}
