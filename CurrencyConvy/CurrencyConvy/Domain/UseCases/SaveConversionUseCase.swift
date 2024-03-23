//
//  SaveConversionUseCase.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

protocol SaveConversionUseCase {
    func addToHistory(item: ConversionHistoryItem)
}

extension SaveConversionUseCase where Self: ConversionHistoryRepositoryHolderType {
    func addToHistory(item: ConversionHistoryItem) {
        conversionHistoryRepository.addToHistory(item: item)
    }
}
