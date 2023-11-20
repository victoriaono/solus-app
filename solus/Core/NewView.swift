//
//  NewView.swift
//  solus
//
//  Created by Victoria Ono on 7/25/23.
//

import SwiftUI

struct NewView: View {
    
    private let user: User
    @State private var viewSoloDate = false
    @State private var viewJournal = false
    @State private var viewGoal = false
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Button("new solo date") {
                    viewSoloDate.toggle()
                }
                .modifier(New())
                .fullScreenCover(isPresented: $viewSoloDate) {
                    NewSoloDateView(user: user)
                }
                
                Spacer()
                
                Button("new journal entry") {
                    viewJournal.toggle()
                }
                .modifier(New())
                .fullScreenCover(isPresented: $viewJournal) {
                    NewJournalView(user: user)
                }
                
                Spacer()
                
                Button("new goal") {
                    viewGoal.toggle()
                }
                .modifier(New())
                .fullScreenCover(isPresented: $viewGoal) {
                    NewGoalView(user: user)
                }
                
                Spacer()
            }
            .frame(width: 237, height: 238)
            .background(Color("lightsage"))
            .cornerRadius(15)
        }
    }
}

extension NewView {
    struct New: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding(.top, 8.0)
                .frame(width: 162, height: 30)
                .background(Color("whiteish"))
                .cornerRadius(25)
                .modifier(Default())
        }
    }
}

struct NewView_Previews: PreviewProvider {
    static var previews: some View {        
        NewView(user: User.MOCK_USER)
    }
}
