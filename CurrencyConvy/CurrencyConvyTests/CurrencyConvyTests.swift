////
////  CurrencyConvyTests.swift
////  CurrencyConvyTests
////
////  Created by Rustam Shorov on 23.03.24.
////
//
//import XCTest
//@testable import CurrencyConvy // Замените на имя вашего приложения
//
//class ConversionsContentViewTests: XCTestCase {
//    var viewModelMock: ConversionsViewModelProtocol!
//    var routerMock: ConversionViewRouterProtocol!
//    var contentView: ConversionsContentView!
//    
//    override func setUp() {
//        super.setUp()
//        
//        viewModelMock = ConversionsViewModelMock()
//        routerMock = ConversionViewRouterMock()
//        contentView = ConversionsContentView(viewModel: viewModelMock, router: routerMock)
//    }
//    
//    override func tearDown() {
//        viewModelMock = nil
//        routerMock = nil
//        contentView = nil
//        
//        super.tearDown()
//    }
//    
//    func testInitialState() {
//        // Проверяем начальное состояние
//        
//        // Пример: Проверяем, что выбранные индексы валют равны 0
//        XCTAssertEqual(contentView.sourceCurrencyIndex, 0)
//        XCTAssertEqual(contentView.targetCurrencyIndex, 0)
//    }
//    
//    func testConvertButtonDisabledWhenAmountIsEmpty() {
//        // Проверяем, что кнопка "Convert" отключена, если поле ввода пустое
//        
//        // Пример: Устанавливаем пустое значение в поле ввода
//        contentView.amount = ""
//        
//        // Пример: Проверяем, что кнопка "Convert" отключена
//        XCTAssertTrue(contentView.isConvertButtonDisabled)
//    }
//    
//    func testConvertButtonEnabledWhenAmountIsNotEmpty() {
//        // Проверяем, что кнопка "Convert" включена, если поле ввода не пустое
//        
//        // Пример: Устанавливаем значение в поле ввода
//        contentView.amount = "10"
//        
//        // Пример: Проверяем, что кнопка "Convert" включена
//        XCTAssertFalse(contentView.isConvertButtonDisabled)
//    }
//    
//    // Добавьте другие тесты по мере необходимости
//}
