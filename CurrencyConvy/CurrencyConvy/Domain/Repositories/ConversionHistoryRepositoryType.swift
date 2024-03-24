//
//  ConversionHistoryRepositoryType.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

protocol ConversionHistoryRepositoryType {
    var storredSourceCurrencyIndex: Int { get }
    var storredTargetCurrencyIndex: Int { get }
    var conversionHistory: [ConversionHistoryItem] { get }
    
    func addToHistory(item: ConversionHistoryItem)
    func updateStoredCurrency(for type: PickedCurrencyType, value: Int)
}

protocol ConversionHistoryRepositoryHolderType {
    var conversionHistoryRepository: ConversionHistoryRepositoryType { get }
}
