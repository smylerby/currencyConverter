//
//  ConversionsViewModel.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 24.03.24.
//

import Foundation
import SwiftUI

struct ConversionOperationModel {
    let conversionRate: String
    let conversionAmount: String
}

struct ConversionsViewModel {
    typealias UseCases = SaveConversionUseCase & FetchConversionRatesUseCase
    
    let currencyManager: CurrencyRatesRepository
    let saveConversionUseCase: SaveConversionUseCase
    let fetchRatesUseCase: FetchConversionRatesUseCase
    
    var currencies: [String] {
        return ["RUB", "USD", "EUR", "GBP", "CHF", "CNY"]
    }
    
    init(saveConversionUseCase: SaveConversionUseCase,
         fetchRatesUseCase: FetchConversionRatesUseCase,
         currencyManager: CurrencyRatesRepository) {
        self.saveConversionUseCase = saveConversionUseCase
        self.fetchRatesUseCase = fetchRatesUseCase
        self.currencyManager = currencyManager
    }
    
    func convert(sourceCurrencyIndex: Int, 
                 targetCurrencyIndex: Int,
                 amount: String) -> ConversionOperationModel? {
        let sourceCurrency = currencies[sourceCurrencyIndex]
        let targetCurrency = currencies[targetCurrencyIndex]
    
        if case let .loaded(value) = currencyManager.ratesData {
            guard let sourceRate = value.data[sourceCurrency],
                  let targetRate = value.data[targetCurrency],
                  let amount = Double(amount) else {
                print("Failed to convert amount")
                return nil
            }
            
            let conversionRate = targetRate / sourceRate
            
            let convertedAmount = amount * conversionRate
            
            let itemToSave = ConversionHistoryItem(sourceCurrency: sourceCurrency,
                                                   targetCurrency: targetCurrency,
                                                   amount: amount,
                                                   result: convertedAmount,
                                                   date: Date())
            
            saveConversionUseCase.addToHistory(item: itemToSave)
            
            return ConversionOperationModel(conversionRate: String(format: "%.4f", conversionRate),
                                            conversionAmount: String(format: "%.2f", convertedAmount))
        }
        
        return nil
    }
    
    func getRates() {
        Task {
            await fetchRatesUseCase.getRates()
        }
    }
}
