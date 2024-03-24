//
//  GetConvertionsHistory.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 24.03.24.
//

import Foundation

protocol GetConvertionsHistoryUseCase {
    var conversionsHistory: [ConversionHistoryItem] { get }
}

extension GetConvertionsHistoryUseCase where Self: ConversionHistoryRepositoryHolderType {
    var conversionsHistory: [ConversionHistoryItem] {
        return conversionHistoryRepository.conversionHistory
    }
}
