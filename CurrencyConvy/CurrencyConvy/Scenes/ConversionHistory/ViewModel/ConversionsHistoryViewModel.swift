//
//  ConversionsHistoryViewModel.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 24.03.24.
//

import Foundation

protocol ConversionsHistoryViewModelProtocol {
    var dateFormatter: DateFormatter { get }
    
    func getFilteredList(filterText: String) -> [ConversionHistoryItem]
}

struct ConversionsHistoryViewModel: ConversionsHistoryViewModelProtocol {
    
    let list: [ConversionHistoryItem]
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    init(list: [ConversionHistoryItem]) {
        self.list = list
    }
    
    func getFilteredList(filterText: String) -> [ConversionHistoryItem] {
        
        guard !filterText.isEmpty else { return list.reversed() }
        
        let updatedList = list.filter { conversion in
            conversion.sourceCurrency.localizedCaseInsensitiveContains(filterText) ||
            conversion.targetCurrency.localizedCaseInsensitiveContains(filterText)
        }
        
        return updatedList.reversed()
    }
}
