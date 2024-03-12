//
//  UIApplication.swift
//  Crypto
//
//  Created by Alvin Amri on 08/03/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
