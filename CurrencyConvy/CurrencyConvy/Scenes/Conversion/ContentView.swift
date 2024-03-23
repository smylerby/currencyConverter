import SwiftUI

struct ContentView: View {
    @State private var sourceCurrencyIndex = 0
    @State private var targetCurrencyIndex = 0
    @State private var amount = ""
    @State private var conversionResult = ""
    @State private var conversionRate = ""
    @State private var isFetchingRates = false
    @State private var timeRemaining = Constants.refreshRatesTimerValue
    @State private var errorMessage: ErrorAlert?
    
    let currencies = ["RUB", "USD", "EUR", "GBP", "CHF", "CNY"]
    
    @EnvironmentObject var conversionHistory: ConversionHistoryRepository
    @EnvironmentObject var currencyRates: CurrencyRatesManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Picker(selection: $sourceCurrencyIndex, label: Text("Source Currency")) {
                        ForEach(0 ..< currencies.count) {
                            Text(self.currencies[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Picker(selection: $targetCurrencyIndex, label: Text("Target Currency")) {
                        ForEach(0 ..< currencies.count) {
                            Text(self.currencies[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    TextField("Enter amount", text: $amount, onCommit: {
                        UIApplication.shared.endEditing()
                    })
                    .keyboardType(.decimalPad)
                    .padding()
                    
                    Text("Conversion Result: \(conversionResult)")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Conversion Rate: \(conversionRate)")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {
                        convert()
                        UIApplication.shared.endEditing() // Скрыть клавиатуру
                    }) {
                        if isFetchingRates {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .foregroundColor(.white)
                        } else {
                            Text("Convert")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .disabled(amount.isEmpty || isFetchingRates)
                    
                    NavigationLink(destination: ConversionHistoryView()) {
                        Text("Conversion History")
                            .padding()
                            .background(Color.blue)
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
                                timeRemaining = Constants.refreshRatesTimerValue
                                getRates()
                            }
                        }
                }
                .padding(.bottom, 20) // Добавляем дополнительный отступ снизу для прокрутки
            }
            .navigationTitle("Currency Converter")
            .onAppear {
                getRates()
            }
            .alert(item: $errorMessage) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func convert() {
        let sourceCurrency = currencies[sourceCurrencyIndex]
        let targetCurrency = currencies[targetCurrencyIndex]
        
        
        if case let .loaded(value) = currencyRates.ratesData {
            guard let sourceRate = value.data[sourceCurrency],
                  let targetRate = value.data[targetCurrency],
                  let amountToConvert = Double(amount) else {
                print("Failed to get rates or convert amount")
                return
            }
            
            let conversionRate = targetRate / sourceRate
            self.conversionRate = String(format: "%.4f", conversionRate)
            
            let convertedAmount = amountToConvert * conversionRate
            self.conversionResult = String(format: "%.2f", convertedAmount)
            
            let itemToSave = ConversionHistoryItem(sourceCurrency: sourceCurrency,
                                                   targetCurrency: targetCurrency,
                                                   amount: amountToConvert,
                                                   result: convertedAmount,
                                                   date: Date())
            
            conversionHistory.add(itemToSave)
        }
    }
    
    private func getRates() {
        Task {
            await currencyRates.fetchAllCurrencyRates()
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ErrorAlert: Identifiable {
    var id = UUID()
    var message: String
}
