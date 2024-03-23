//
//  ConversionHistorySearchBarView.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal, 8)
            Button(action: {
                self.text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(8)
            }
        }
        .padding(.horizontal)
    }
}
