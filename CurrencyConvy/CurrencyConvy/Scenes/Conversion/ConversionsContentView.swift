import SwiftUI

struct ConversionsContentView: View {
    @State private var sourceCurrencyIndex = 0
    @State private var targetCurrencyIndex = 0
    @State private var amount = ""
    @State private var conversionResult = ""
    @State private var conversionRate = ""
    @State private var isFetchingRates = false
    @State private var timeRemaining = Constants.refreshRatesTimerValue
    @State private var errorMessage: ErrorAlert?
    
    private let viewModel: ConversionsViewModel
    
    init(viewModel: ConversionsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Picker(selection: $sourceCurrencyIndex, label: Text("Source Currency")) {
                        ForEach(0 ..< viewModel.currencies.count) {
                            Text(viewModel.currencies[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Picker(selection: $targetCurrencyIndex, label: Text("Target Currency")) {
                        ForEach(0 ..< viewModel.currencies.count) {
                            Text(viewModel.currencies[$0])
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
                        UIApplication.shared.endEditing()
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
                                viewModel.getRates()
                            }
                        }
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Currency Converter")
            .onAppear {
                viewModel.getRates()
            }
            .alert(item: $errorMessage) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func convert() {
        guard let result = viewModel.convert(
            sourceCurrencyIndex: sourceCurrencyIndex,
            targetCurrencyIndex: targetCurrencyIndex,
            amount: amount
        ) else { return }
                
        self.conversionRate = result.conversionRate
        self.conversionResult = result.conversionAmount
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
