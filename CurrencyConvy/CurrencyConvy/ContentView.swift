//
//  ContentView.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import SwiftUI

enum Constants {
    static let apiKey: String = "fca_live_uhw1eEvhQHh9wpfcUYNTxGhBBIsd0RZJcqR1vOxa"
}

struct CurrencyRatesResponse: Codable {
    let data: [String: Double]
}

struct ContentView: View {
    @State private var sourceCurrencyIndex = 0
    @State private var targetCurrencyIndex = 0
    @State private var amount = ""
    @State private var conversionResult = ""
    @State private var conversionRate = ""
    @State private var isFetchingRates = false
    
    @State private var currencyRates: [String: Double] = [
        "RUB": 0.0,
        "USD": 0.0,
        "EUR": 0.0,
        "GBP": 0.0,
        "CHF": 0.0,
        "CNY": 0.0
    ]
    
    let currencies = ["RUB", "USD", "EUR", "GBP", "CHF", "CNY"]
    let apiKey = "fca_live_uhw1eEvhQHh9wpfcUYNTxGhBBIsd0RZJcqR1vOxa"
    
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
                    fetchCurrencyConversion()
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
            }
            .navigationTitle("Currency Converter")
            .onAppear(perform: fetchAllCurrencyRates)
        }
    }
    
    func fetchAllCurrencyRates() {
        guard let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        isFetchingRates = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(CurrencyRatesResponse.self, from: data)
                
                currencies.forEach { key in
                    currencyRates[key] = response.data[key]
                }
                
                DispatchQueue.main.async {
                    self.isFetchingRates = false
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchCurrencyConversion() {
          let sourceCurrency = currencies[sourceCurrencyIndex]
          let targetCurrency = currencies[targetCurrencyIndex]
          
          guard let sourceRate = currencyRates[sourceCurrency],
                let targetRate = currencyRates[targetCurrency],
                let amountToConvert = Double(amount) else {
              print("Failed to get rates or convert amount")
              return
          }
          
          // Рассчитываем курс конверсии
          let conversionRate = targetRate / sourceRate
          self.conversionRate = String(format: "%.4f", conversionRate)
          
          // Выполняем конверсию
          let convertedAmount = amountToConvert * conversionRate
          self.conversionResult = String(format: "%.2f", convertedAmount)
      }
}

struct CurrencyPair: Hashable {
    let sourceCurrency: String
    let targetCurrency: String
    let amount: Double
    let conversionRate: Double
}

struct ConversionHistoryView: View {
    let currencyPairs: [CurrencyPair] = [
        CurrencyPair(sourceCurrency: "USD", targetCurrency: "RUB", amount: 100.0, conversionRate: 73.5),
        CurrencyPair(sourceCurrency: "EUR", targetCurrency: "USD", amount: 200.0, conversionRate: 1.2),
        CurrencyPair(sourceCurrency: "GBP", targetCurrency: "EUR", amount: 150.0, conversionRate: 1.4)
        // Здесь вы можете добавить другие пары с реальными данными
    ]
    
    var body: some View {
        NavigationView {
            List(currencyPairs, id: \.self) { pair in
                VStack(alignment: .leading) {
                    Text("Source: \(pair.sourceCurrency)")
                    Text("Target: \(pair.targetCurrency)")
                    Text("Amount: \(pair.amount)")
                    Text("Conversion Rate: \(pair.conversionRate)")
                }
            }
            .navigationTitle("Conversion History")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
