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
    @StateObject var conversionHistory = ConversionHistoryManager()
    @StateObject var currencyRates = CurrencyRatesManager()
    
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
            ContentView()
                .environmentObject(conversionHistory)
                .environmentObject(currencyRates)
        }
        .modelContainer(sharedModelContainer)
    }
}
