//
//  ConversionHistroyView.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import SwiftUI

struct ConversionHistoryView: View {
    
    @State private var searchText = ""
    
    private let viewModel: ConversionsHistoryViewModelProtocol
    
    init(viewModel: ConversionsHistoryViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding()
            
            List {
                ForEach(viewModel.getFilteredList(filterText: searchText)) { conversion in
                    VStack(alignment: .leading) {
                        Text("Source Currency: \(conversion.sourceCurrency)")
                        Text("Target Currency: \(conversion.targetCurrency)")
                        Text("Amount: \(conversion.amount)")
                        Text("Result: \(conversion.result)")
                        Text("Date: \(conversion.date, formatter: viewModel.dateFormatter)")
                    }
                }
            }
            .navigationTitle("Conversion History")
        }
    }
}
