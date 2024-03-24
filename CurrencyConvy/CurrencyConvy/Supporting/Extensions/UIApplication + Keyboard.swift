//
//  UIApplication + Keyboard.swift
//  CurrencyConvy
//
//  Created by Rustam Shorov on 24.03.24.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
