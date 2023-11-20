//
//  ContentView.swift
//  solus
//
//  Created by Victoria Ono on 7/23/23.
//

import SwiftUI

struct ContentView: View {
    
//    @StateObject var viewModel = ContentViewModel()
//    @StateObject var authViewModel = AuthViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
        
    var body: some View {
        Group {
            if authViewModel.userSession == nil {
                WelcomeView()
//                    .environmentObject(authViewModel)
            } else if let user = authViewModel.currentUser {
                TabbedView(user: user)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
