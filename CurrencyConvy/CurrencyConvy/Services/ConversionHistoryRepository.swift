//
//  ConversionHistoryManager.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import SwiftUI

class ConversionHistoryRepository: ObservableObject, ConversionHistoryRepositoryType {
    enum Keys {
        static let conversionHistoryKey = "conversionHistory"
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
