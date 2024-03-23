//
//  Gateway.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 23.03.24.
//

import SwiftUI
import Combine

protocol Networking {
    init(_ route: CurrencyRatesRoute)
    func task<T: Codable>() -> AnyPublisher<T, Error>
}

struct Gateway<T: Codable>: Networking {
    private let route: CurrencyRatesRoute
    private let urlSession = URLSession.shared
    
    init(_ route: CurrencyRatesRoute) {
        self.route = route
    }

    func task<T: Codable>() -> AnyPublisher<T, Error>  {
        return self.urlSession
            .dataTaskPublisher(for: route.url)
            .map {
                $0.data
            }
            .decode(type: T.self, decoder: ConfiguredJSONDecoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

public let ConfiguredJSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
}()
