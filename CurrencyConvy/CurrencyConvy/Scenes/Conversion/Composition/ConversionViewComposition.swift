//
//  ConversionViewComposition.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 24.03.24.
//

import Foundation

enum ConversionViewComposition {
    static func configure(conversionHistory: ConversionHistoryRepository,
                          currencyRates: CurrencyRatesRepository) -> ConversionsContentView {
        
        let context = ConversionViewCompositionContext(
            currencyRatesRepository: currencyRates,
            conversionHistoryRepository: conversionHistory
        )
        
        let viewModel = ConversionsViewModel(useCases: context,
                                             currencyManager: currencyRates)

        let router: ConversionViewRouterProtocol = ConversionViewRouter()
        
        return ConversionsContentView(viewModel: viewModel, router: router)
    }
}

private final class ConversionViewCompositionContext: CurrencyRatesRepositoryHolderType, ConversionHistoryRepositoryHolderType {
    
    let currencyRatesRepository: CurrencyRatesRepositoryType
    let conversionHistoryRepository: ConversionHistoryRepositoryType
    
    init(currencyRatesRepository: CurrencyRatesRepositoryType, conversionHistoryRepository: ConversionHistoryRepositoryType) {
        self.currencyRatesRepository = currencyRatesRepository
        self.conversionHistoryRepository = conversionHistoryRepository
    }
}

extension ConversionViewCompositionContext: FetchConversionRatesUseCase {}
extension ConversionViewCompositionContext: SaveConversionUseCase {}
extension ConversionViewCompositionContext: GetConvertionsHistoryUseCase {}
