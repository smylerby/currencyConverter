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
    
    @Published private (set) var ratesData: Loadable<CurrencyRates> = .notRequested {
        didSet {
            switch ratesData {
                case .loaded(let rates):
                    self.saveToStorage(rates: rates)
                default: return
            }
        }
    }
    
    private let networking: Networking
    
    required init(_ network: Networking) {
        self.networking = network
        
        let initialData = loadCurrencyRates()
        ratesData = .loaded(CurrencyRates(data: initialData))
        
    }
    
    func fetchAllCurrencyRates() async {
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                let task = self.networking.task().sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case let .failure(error):
                            DispatchQueue.main.async {
                                self.ratesData.setError(error)
                                continuation.resume()
                            }
                        }
                    },
                    receiveValue: { (value: CurrencyRates) in
                        DispatchQueue.main.async {
                            self.ratesData.setValue(value)
                            continuation.resume()
                        }
                    })
                self.ratesData.setIsLoading(task)
            }
        }
    }
    
    func saveToStorage(rates: CurrencyRates) {
        if let encodedData = try? JSONEncoder().encode(rates.data) {
            UserDefaults.standard.set(encodedData, forKey: Keys.currencyRatesKey)
        }
    }

    func loadCurrencyRates() -> [String: Double] {
        if let data = UserDefaults.standard.data(forKey: Keys.currencyRatesKey),
           let savedCurrencyRates = try? JSONDecoder().decode([String: Double].self, from: data) {
//            self.ratesData.setValue(CurrencyRates(data: savedCurrencyRates))
            return savedCurrencyRates
        }
        
        return [:]
    }
}

