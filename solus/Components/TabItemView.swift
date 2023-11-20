//
//  TabItemView.swift
//  solus
//
//  Created by Victoria Ono on 8/11/23.
//

import SwiftUI

extension AnyTransition {
    static var slideIn: AnyTransition {
        .asymmetric(insertion: .offset(x: 10).combined(with: .opacity),
                    removal: .scale.combined(with: .opacity))
    }
}

struct TabItemView: View {
    
    var tabName: String
    var isSelected: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Image(tabName)
                    .frame(width: geo.size.width, height: geo.size.height)
            if isSelected {
                Rectangle()
                    .foregroundColor(Color("darksage"))
                    .frame(width: geo.size.width, height: 2)
//                    .transition(.slideIn)
                }
            }
        }
    }
}

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView(tabName: "Heart", isSelected: true)
    }
}
