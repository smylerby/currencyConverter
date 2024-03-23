//
//  ConversionHistoryModel.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import Foundation

struct ConversionHistoryItem: Codable, Identifiable {
    let id = UUID()
    let sourceCurrency: String
    let targetCurrency: String
    let amount: Double
    let result: Double
    let date: Date
}
