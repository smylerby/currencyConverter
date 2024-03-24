//
//  ConversionsHistoryComposition.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 24.03.24.
//

import Foundation

enum ConversionsHistoryComposition {
    
    static func configure(list: [ConversionHistoryItem]) -> ConversionHistoryView {
        let viewModel = ConversionsHistoryViewModel(list: list)
        let scene = ConversionHistoryView(viewModel: viewModel)
        
        return scene
    }
}
