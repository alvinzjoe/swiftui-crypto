//
//  XMarkButton.swift
//  Crypto
//
//  Created by Alvin Amri on 12/03/24.
//

import SwiftUI

struct XMarkButton: View {
//    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Image(systemName: "xmark")
            .foregroundStyle(Color.theme.accent)
 
    }
}

#Preview {
    XMarkButton()
}
