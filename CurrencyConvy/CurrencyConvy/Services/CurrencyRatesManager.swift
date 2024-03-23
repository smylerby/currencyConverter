//
//  CurrencyRatesManager.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import SwiftUI

class CurrencyRatesManager: ObservableObject {
    
    enum Keys {
        static let currencyRatesKey = "currencyRates"
    }
    
    @Published var rates: [String: Double] = [:]
    
    init() {
        loadCurrencyRates()
    }
    
    func fetchAllCurrencyRates() {
        guard let url = URL(string: Constants.apiPath+Constants.apiKey) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(CurrencyRatesResponse.self, 
                                                                   from: data)
                    DispatchQueue.main.async {
                        self.rates = decodedResponse.data
                        self.saveCurrencyRates()
                    }
                    return
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func saveCurrencyRates() {
        if let encodedData = try? JSONEncoder().encode(rates) {
            UserDefaults.standard.set(encodedData, forKey: Keys.currencyRatesKey)
        }
    }
    
    func loadCurrencyRates() {
        if let data = UserDefaults.standard.data(forKey: Keys.currencyRatesKey),
           let savedCurrencyRates = try? JSONDecoder().decode([String: Double].self, from: data) {
            self.rates = savedCurrencyRates
        }
    }
}

