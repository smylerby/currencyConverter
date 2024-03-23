//
//  ConversionHistoryManager.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import SwiftUI

class ConversionHistoryManager: ObservableObject {
    
    enum Keys {
        static let conversionHistoryKey = "conversionHistory"
    }
    
    @Published var conversions: [Conversion] = []
    
    init() {
        load()
    }
    
    func add(sourceCurrency: String,
             targetCurrency: String,
             amount: Double,
             result: Double) {
        
        let conversion = Conversion(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency, amount: amount, result: result, date: Date())
        conversions.append(conversion)
        save()
    }
    
    func save() {
        if let encodedData = try? JSONEncoder().encode(conversions) {
            UserDefaults.standard.set(encodedData, forKey: Keys.conversionHistoryKey)
        }
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: Keys.conversionHistoryKey),
           let savedConversions = try? JSONDecoder().decode([Conversion].self, from: data) {
            self.conversions = savedConversions
        }
    }
}
