//
//  ConversionHistoryManager.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import SwiftUI

enum PickedCurrencyType {
    case source
    case target
}

class ConversionHistoryRepository: ObservableObject, ConversionHistoryRepositoryType {

    
    @AppStorage(Keys.sourceCurrencyIndex) var storredSourceCurrencyIndex = 0
    @AppStorage(Keys.targetCurrencyIndex) var storredTargetCurrencyIndex = 0
    
    enum Keys {
        static let conversionHistoryKey = "conversionHistory"
        static let sourceCurrencyIndex = "sourceCurrencyIndex"
        static let targetCurrencyIndex = "targetCurrencyIndex"
    }
    
    @Published var conversions: [ConversionHistoryItem] = []
    
    init() {
        _load()
    }

    var conversionHistory: [ConversionHistoryItem] {
        return conversions
    }
    
    func addToHistory(item: ConversionHistoryItem) {
        conversions.append(item)
        _save()
    }
    
    func updateStoredCurrency(for type: PickedCurrencyType, value: Int) {
        switch type {
        case .source:
            storredSourceCurrencyIndex = value
        case .target:
            storredTargetCurrencyIndex = value
        }
    }
    
    // MARK: - Private -
    
    private func _save() {
        if let encodedData = try? JSONEncoder().encode(conversions) {
            UserDefaults.standard.set(encodedData, forKey: Keys.conversionHistoryKey)
        }
    }
    
    private func _load() {
        if let data = UserDefaults.standard.data(forKey: Keys.conversionHistoryKey),
           let savedConversions = try? JSONDecoder().decode([ConversionHistoryItem].self, 
                                                            from: data) {
            self.conversions = savedConversions
        }
    }
}
