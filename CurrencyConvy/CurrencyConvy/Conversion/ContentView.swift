//
//  ContentView.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import SwiftUI

struct ContentView: View {
    @State private var sourceCurrencyIndex = 0
    @State private var targetCurrencyIndex = 0
    @State private var amount = ""
    @State private var conversionResult = ""
    @State private var conversionRate = ""
    @State private var isFetchingRates = false
    @State private var timeRemaining = Constants.resreshRatesTimer
    
    let currencies = ["RUB", "USD", "EUR", "GBP", "CHF", "CNY"]
    
    @EnvironmentObject var conversionHistory: ConversionHistoryManager
    @EnvironmentObject var currencyRates: CurrencyRatesManager
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Source Currency", selection: $sourceCurrencyIndex) {
                    ForEach(0..<currencies.count) { index in
                        Text(self.currencies[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Picker("Target Currency", selection: $targetCurrencyIndex) {
                    ForEach(0..<currencies.count) { index in
                        Text(self.currencies[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TextField("Enter amount", text: $amount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Text("Conversion Result: \(conversionResult)")
                    .padding()
                
                Text("Conversion Rate: \(conversionRate)")
                    .padding()
                
                Button(action: {
                    convert()
                }) {
                    if isFetchingRates {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .foregroundColor(.white)
                    } else {
                        Text("Convert")
                            .padding()
                            .background(amount.isEmpty || isFetchingRates ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .disabled(amount.isEmpty || isFetchingRates)
                
                NavigationLink(destination: ConversionHistoryView()) {
                    Text("Conversion History")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
                
                Text("Next update in: \(timeRemaining) seconds")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.bottom)
                    .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            timeRemaining = Constants.resreshRatesTimer
                            currencyRates.fetchAllCurrencyRates()
                        }
                    }
            }
            .navigationTitle("Currency Converter")
            .onAppear {
                currencyRates.fetchAllCurrencyRates()
            }
        }
    }
    
    func convert() {
        let sourceCurrency = currencies[sourceCurrencyIndex]
        let targetCurrency = currencies[targetCurrencyIndex]
        
        guard let sourceRate = currencyRates.rates[sourceCurrency],
              let targetRate = currencyRates.rates[targetCurrency],
              let amountToConvert = Double(amount) else {
            print("Failed to get rates or convert amount")
            return
        }
        
        let conversionRate = targetRate / sourceRate
        self.conversionRate = String(format: "%.4f", conversionRate)
        
        let convertedAmount = amountToConvert * conversionRate
        self.conversionResult = String(format: "%.2f", convertedAmount)
        
        conversionHistory.add(sourceCurrency: sourceCurrency,
                              targetCurrency: targetCurrency,
                              amount: amountToConvert,
                              result: convertedAmount)
    }
}
