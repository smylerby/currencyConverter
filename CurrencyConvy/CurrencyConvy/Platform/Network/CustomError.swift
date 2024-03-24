//
//  CustomError.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 24.03.24.
//

import SwiftUI

enum CustomError: LocalizedError {
    
    case regular
    
    var errorDescription: String? {
        switch self {
        case .regular:
            return "Error occured"
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .regular:
            return "Something went wrong"
        }
    }
}

struct ErrorAlert: ViewModifier {
    
    @Binding var error: CustomError?
    var isShowingError: Binding<Bool> {
        Binding {
            error != nil
        } set: { _ in
            error = nil
        }
    }
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: isShowingError, error: error) { _ in
            } message: { error in
                if let message = error.errorMessage {
                    Text(message)
                }
            }
    }
}
