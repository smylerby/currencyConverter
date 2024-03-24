//
//  CurrencyRatesManager.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import SwiftUI

class CurrencyRatesRepository: ObservableObject, CurrencyRatesRepositoryType {
    
    enum Keys {
        static let currencyRatesKey = "currencyRates"
    }
    
    @Published private (set) var ratesData: Loadable<CurrencyRates> = .notRequested {
        didSet {
            switch ratesData {
                case .loaded(let rates):
                    self._saveToStorage(rates: rates)
                default: return
            }
        }
    }
    
    private let networking: Networking
    
    required init(_ network: Networking) {
        self.networking = network
        
        let initialData = _loadCurrencyRates()
        ratesData = .loaded(CurrencyRates(data: initialData))
    }
    
    func getRates() async {
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
    
    // MARK: - Private -
    
    private func _saveToStorage(rates: CurrencyRates) {
        if let encodedData = try? JSONEncoder().encode(rates.data) {
            UserDefaults.standard.set(encodedData, forKey: Keys.currencyRatesKey)
        }
    }

    private func _loadCurrencyRates() -> [String: Double] {
        if let data = UserDefaults.standard.data(forKey: Keys.currencyRatesKey),
           let savedCurrencyRates = try? JSONDecoder().decode([String: Double].self, from: data) {
            return savedCurrencyRates
        }
        
        return [:]
    }
}

