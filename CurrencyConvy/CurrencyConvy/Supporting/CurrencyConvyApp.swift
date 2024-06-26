//
//  CurrencyConvyApp.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import SwiftUI
import SwiftData

@main
struct CurrencyConvyApp: App {
    @StateObject var conversionHistory = ConversionHistoryRepository()
    @StateObject var currencyRates = CurrencyRatesRepository(Gateway<CurrencyRates>(.update))
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ConversionViewComposition.configure(conversionHistory: conversionHistory,
                                                currencyRates: currencyRates)
        }
        .modelContainer(sharedModelContainer)
    }
}
