//
//  ConversionViewRouter.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 24.03.24.
//

import Foundation

final class ConversionViewRouter {
    func moveToHistory(list: [ConversionHistoryItem]) -> ConversionHistoryView {
        
        let scene = ConversionsHistoryComposition.configure(list: list)
        
        return scene
    }
}
