//
//  ConversionsViewModel.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 24.03.24.
//

import Foundation
import SwiftUI

protocol ConversionsViewModelProtocol {
    var storredSourceCurrencyIndex: Int { get }
    var storredTargetCurrencyIndex: Int { get }
    var currencies: [String] { get }
    
    func updateStoredCurrency(for type: PickedCurrencyType, value: Int)
    func convert(sourceCurrencyIndex: Int, targetCurrencyIndex: Int, amount: String) -> ConversionOperationModel?
    func getConvertionsHistory() -> [ConversionHistoryItem]
    func getRates(handler: ((Error?) -> Void)?)
}

struct ConversionsViewModel: ConversionsViewModelProtocol {
    typealias UseCases = SaveConversionUseCase & FetchConversionRatesUseCase & GetConvertionsHistoryUseCase & FavouriteCurrencyUseCase
    
    let useCases: UseCases
    let currencyManager: CurrencyRatesRepository
    
    var currencies: [String] {
        return ["RUB", "USD", "EUR", "GBP", "CHF", "CNY"]
    }
    
    init(useCases: UseCases,
         currencyManager: CurrencyRatesRepository) {
        self.useCases = useCases
        self.currencyManager = currencyManager
    }
    
    var storredSourceCurrencyIndex: Int {
        useCases.storredSourceCurrencyIndex
    }
    
    var storredTargetCurrencyIndex: Int {
        useCases.storredTargetCurrencyIndex
    }
    
    func updateStoredCurrency(for type: PickedCurrencyType, value: Int) {
        useCases.updateStoredCurrency(for: type, value: value)
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
            
            useCases.addToHistory(item: itemToSave)
            
            return ConversionOperationModel(conversionRate: String(format: "%.4f", conversionRate),
                                            conversionAmount: String(format: "%.2f", convertedAmount))
        }
        
        return nil
    }
    
    func getConvertionsHistory() -> [ConversionHistoryItem] {
        return useCases.conversionsHistory
    }
    
    func getRates(handler: ((Error?) -> Void)?) {
        Task {
            await useCases.getRates(handler: handler)
        }
    }
}
