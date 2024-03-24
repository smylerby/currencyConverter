//
//  ConversionHistoryRepositoryType.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

protocol ConversionHistoryRepositoryType {
    var conversionHistory: [ConversionHistoryItem] { get }
    func addToHistory(item: ConversionHistoryItem)
}

protocol ConversionHistoryRepositoryHolderType {
    var conversionHistoryRepository: ConversionHistoryRepositoryType { get }
}
