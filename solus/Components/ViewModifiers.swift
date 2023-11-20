//
//  ViewModifiers.swift
//  solus
//
//  Created by Victoria Ono on 7/23/23.
//

import Foundation
import SwiftUI

struct Default: ViewModifier {
    var fontSize: CGFloat
    var fontColor : String
    
    init(fontSize: CGFloat = 14, fontColor: String = "slate") {
        self.fontSize = fontSize
        self.fontColor = fontColor
    }
    
    func body(content: Content) -> some View {
        content
            .font(.custom("GranthaSangamMN-Regular", size: fontSize))
            .tracking(0.42)
            .foregroundStyle(Color(fontColor))
    }
}

struct Title: ViewModifier {
    var fontSize: CGFloat
    var fontColor: String
    
    init(fontSize: CGFloat = 40, fontColor: String = "slate") {
        self.fontSize = fontSize
        self.fontColor = fontColor
    }
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Fraunces", size: fontSize))
            .foregroundStyle(Color(fontColor))
    }
}

struct LongText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("whiteish"))
            .cornerRadius(25)
    }
}
