//
//  ConversionHistroyView.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import SwiftUI

struct ConversionHistoryView: View {
    @EnvironmentObject var conversionHistory: ConversionHistoryRepository
    
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding()
            
            List {
                ForEach(filteredConversions.reversed()) { conversion in
                    VStack(alignment: .leading) {
                        Text("Source Currency: \(conversion.sourceCurrency)")
                        Text("Target Currency: \(conversion.targetCurrency)")
                        Text("Amount: \(conversion.amount)")
                        Text("Result: \(conversion.result)")
                        Text("Date: \(conversion.date, formatter: dateFormatter)")
                    }
                }
            }
            .navigationTitle("Conversion History")
        }
    }
    
    var filteredConversions: [ConversionHistoryItem] {
        if searchText.isEmpty {
            return conversionHistory.conversions
        } else {
            return conversionHistory.conversions.filter { conversion in
                conversion.sourceCurrency.localizedCaseInsensitiveContains(searchText) ||
                conversion.targetCurrency.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}
