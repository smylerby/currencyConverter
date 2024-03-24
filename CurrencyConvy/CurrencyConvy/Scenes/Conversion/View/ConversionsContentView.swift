import SwiftUI

struct ConversionsContentView: View {
    @State var sourceCurrencyIndex: Int
    @State var targetCurrencyIndex: Int
    @State var amount = ""
    @State var conversionResult = ""
    @State var conversionRate = ""
    @State var timeRemaining = Constants.refreshRatesTimerValue
    @State var error: CustomError?
    
    private let viewModel: ConversionsViewModelProtocol
    private let router: ConversionViewRouterProtocol
    
    init(viewModel: ConversionsViewModelProtocol,
         router: ConversionViewRouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        _sourceCurrencyIndex = State(initialValue: viewModel.storredSourceCurrencyIndex)
        _targetCurrencyIndex = State(initialValue: viewModel.storredTargetCurrencyIndex)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    _makePicker(type: .source, title: "Source Currency", selection: $sourceCurrencyIndex)
                    
                    _makePicker(type: .target, title: "Target Currency", selection: $targetCurrencyIndex)
                    
                    _makeTextfield(text: $amount)
                    
                    _makeLabel(title: "Conversion Result: \(conversionResult)")
                    
                    _makeLabel(title: "Conversion Rate: \(conversionRate)")
                    
                    _makeConvertButton()
                    
                    _makeNavigationButton(title: "Conversion History",
                                          destination: router.moveToHistory(list: viewModel.getConvertionsHistory()))
                    
                    Spacer()
                    
                    _makeTimerLabel()
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

// MARK: - Preparing Views
private extension ConversionsContentView {
    
    func _makePicker(type: PickedCurrencyType, 
                     title: String,
                     selection: Binding<Int>) -> some View {
        Picker(selection: selection, label: Text(title)) {
            ForEach(0 ..< viewModel.currencies.count) {
                Text(viewModel.currencies[$0])
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .onChange(of: selection.wrappedValue, { _, newValue in
            viewModel.updateStoredCurrency(for: type, value: newValue)
        })
    }
    
    func _makeLabel(title: String) -> some View {
        let label = Text(title)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        
        return label
    }
    
    func _makeConvertButton() -> some View {
       let button = Button(action: {
            _onConvertTapped()
            UIApplication.shared.endEditing()
        }) {
            Text("Convert")
                .padding()
                .background(amount.isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .disabled(amount.isEmpty)
        
        return button
    }
    
    func _makeTextfield(text: Binding<String>) -> some View {
        TextField("Enter amount", text: text, onCommit: {
            UIApplication.shared.endEditing()
        })
        .keyboardType(.decimalPad)
        .padding()
    }
    
    func _makeNavigationButton(title: String, destination: some View) -> some View {
        
        return NavigationLink(destination: destination) {
            Text(title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
    }
    
    func _makeTimerLabel() -> some View {
       return Text("Next rates update in: \(timeRemaining) seconds")
            .foregroundColor(.gray)
            .font(.footnote)
            .padding(.bottom)
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timeRemaining = Constants.refreshRatesTimerValue
                    _getRates()
                }
            })
    }
}
