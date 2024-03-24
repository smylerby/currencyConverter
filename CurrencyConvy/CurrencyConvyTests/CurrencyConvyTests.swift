import XCTest
import SwiftUI
@testable import CurrencyConvy

class ConversionsContentViewTests: XCTestCase {

    var viewModelMock: ConversionsViewModelMock!
    var routerMock: ConversionViewRouterMock!
    var contentView: ConversionsContentView!

    override func setUp() {
        super.setUp()
        viewModelMock = ConversionsViewModelMock()
        routerMock = ConversionViewRouterMock()
        contentView = ConversionsContentView(viewModel: viewModelMock, router: routerMock)
    }

    func testPickerSelectionUpdatesStoredCurrency() {
        let sourceCurrencyIndex = 1
        contentView._makePicker(type: .source, title: "Test", selection: .constant(sourceCurrencyIndex))
        XCTAssertEqual(viewModelMock.storedSourceCurrencyIndex, sourceCurrencyIndex)
    }

    func testRatesUpdateOnViewAppear() {
        contentView.onAppear()
        XCTAssertTrue(viewModelMock.getRatesCalled)
    }

    func testConversionOnButtonTap() {
        contentView._onConvertTapped()
        XCTAssertTrue(viewModelMock.convertCalled)
    }
}

class ConversionsViewModelMock: ConversionsViewModelProtocol {
    
    var storredSourceCurrencyIndex: Int = 0
    var storredTargetCurrencyIndex: Int = 0
    var currencies: [String] = []
    
    var storedSourceCurrencyIndex: Int = 0
    var storedTargetCurrencyIndex: Int = 0
    var getRatesCalled = false
    var convertCalled = false

    func getRates(handler: @escaping (CustomError?) -> Void) {
        getRatesCalled = true
    }

    func convert(sourceCurrencyIndex: Int, targetCurrencyIndex: Int, amount: String) -> CurrencyConvy.ConversionOperationModel? {
        return ConversionOperationModel(conversionRate: "10", conversionAmount: "10")
    }
    
    func updateStoredCurrency(for type: CurrencyConvy.PickedCurrencyType, value: Int) {}
    
    func getConvertionsHistory() -> [CurrencyConvy.ConversionHistoryItem] {
        return [.init(sourceCurrency: "RUB",
                      targetCurrency: "USD",
                      amount: 1,
                      result: 10.0,
                      date: Date())]
    }
    
    func getRates(handler: ((Error?) -> Void)?) {}
}

class ConversionViewRouterMock: ConversionViewRouterProtocol {
    func moveToHistory(list: [ConversionHistoryItem]) -> ConversionHistoryView {
        return ConversionHistoryView(viewModel: ConversionsHistoryViewModel(list: [
            .init(sourceCurrency: "RUB",
                          targetCurrency: "USD",
                          amount: 1,
                          result: 10.0,
                          date: Date())
        ]))
    }
}
