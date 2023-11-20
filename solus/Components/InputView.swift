//
//  InputView.swift
//  solus
//
//  Created by Victoria Ono on 7/28/23.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    var placeholder = ""
    var alignment: TextAlignment = .center
    var isSecureField = false
    
    var body: some View {
        if isSecureField {
            SecureField(placeholder, text: $text)
                .modifier(Default())
                .foregroundStyle(Color("greyish"))
                .padding(.top, 8.0)
                .multilineTextAlignment(alignment)
                .padding(.leading, alignment == .leading ? 12 : 0)
                .frame(height: 34)
                .background(Color("whiteish"))
                .cornerRadius(25)
        } else {
            TextField(placeholder, text: $text)
                .modifier(Default())
                .foregroundStyle(Color("greyish"))
                .padding(.top, 8.0)
                .multilineTextAlignment(alignment)
                .textInputAutocapitalization(.never)
                .padding(.leading, alignment == .leading ? 12 : 0)
                .frame(height: 34)
                .background(Color("whiteish"))
                .cornerRadius(25)
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), placeholder: "name@example.com")
    }
}
