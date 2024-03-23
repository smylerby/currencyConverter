//
//  ConversionHistoryRepositoryType.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

protocol ConversionHistoryRepositoryType {
    func addToHistory(item: ConversionHistoryItem)
}

protocol ConversionHistoryRepositoryHolderType {
    var conversionHistoryRepository: ConversionHistoryRepositoryType { get }
}
