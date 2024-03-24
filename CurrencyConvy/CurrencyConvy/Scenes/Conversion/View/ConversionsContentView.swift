import SwiftUI

protocol ConversionHistoryViewProtocol {
    
}

struct ConversionsContentView: View, ConversionHistoryViewProtocol {
    @State private var sourceCurrencyIndex = 0
    @State private var targetCurrencyIndex = 0
    @State private var amount = ""
    @State private var conversionResult = ""
    @State private var conversionRate = ""
    @State private var isFetchingRates = false
    @State private var timeRemaining = Constants.refreshRatesTimerValue
    @State private var error: CustomError?
    
    private let viewModel: ConversionsViewModelProtocol
    private let router: ConversionViewRouter
    
    init(viewModel: ConversionsViewModelProtocol,
         router: ConversionViewRouter) {
        self.viewModel = viewModel
        self.router = router
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
                        _onConvertTapped()
                        UIApplication.shared.endEditing()
                    }) {
                        if isFetchingRates {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .foregroundColor(.white)
                        } else {
                            Text("Convert")
                                .padding()
                                .background(amount.isEmpty ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .disabled(amount.isEmpty || isFetchingRates)
                    
                    NavigationLink(destination: router.moveToHistory(list: viewModel.getConvertionsHistory())) {
                        Text("Conversion History")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    
                    Spacer()
                    
                    Text("Next rates update in: \(timeRemaining) seconds")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.bottom)
                        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                            } else {
                                timeRemaining = Constants.refreshRatesTimerValue
                                _getRates()
                            }
                        }
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Currency Converter")
            .onAppear {
                _getRates()
            }
        }
        .errorAlert($error)
    }
    
    private func _getRates() {
        viewModel.getRates(handler: { _ in
            self.error = CustomError.regular
        })
    }
    
    private func _onConvertTapped() {
        guard let result = viewModel.convert(
            sourceCurrencyIndex: sourceCurrencyIndex,
            targetCurrencyIndex: targetCurrencyIndex,
            amount: amount
        ) else { return }
                
        self.conversionRate = result.conversionRate
        self.conversionResult = result.conversionAmount
    }
}

extension View {
    func errorAlert(_ error: Binding<CustomError?>) -> some View {
        self.modifier(ErrorAlert(error: error))
    }
}
