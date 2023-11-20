//
//  WelcomeView.swift
//  solus
//
//  Created by Victoria Ono on 7/23/23.
//

import SwiftUI

struct WelcomeView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            Image("Grey Logo")
                .resizable()
                .scaledToFill()
                .frame(width: 212, height: 138)
            
            Text("Welcome")
                .modifier(Title(fontSize: 30))
                .foregroundStyle(Color("slate"))
                .padding(.top, 36)
            
            VStack {
                InputView(text: $email, placeholder: "email address")
                    .autocapitalization(.none)
                    .padding(.horizontal, 32)
                InputView(text: $password, placeholder: "password", isSecureField: true)
                    .padding(.horizontal, 32)
                Button("log in") {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                }
                .padding(.top, 8.0)
                .frame(width: 196, height: 39)
                .background(Color("sage"))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(25)
                .foregroundStyle(Color("whiteish"))
                .modifier(Default())
                .padding(.top, 51)
                
                Text(viewModel.showError ? viewModel.errorMessage : "")
                    .foregroundStyle(Color.red)
                    .modifier(Default())
                    
                
                 Text("I'm new here!")
                    .modifier(Default())
                    .foregroundStyle(Color("darkslate"))
                    .padding(.top, 87)
                
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("create new account")
                    .padding(.top, 8.0)
                    .frame(width: 196, height: 39)
                    .background(Color("sage"))
                    .cornerRadius(25)
                    .foregroundStyle(Color("whiteish"))
                    .modifier(Default())
                }
            }
        }
//        .onTapGesture {
//            hideKeyboard()
//        }
    }
}

// MARK: - FormProtocol

extension WelcomeView: FormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var viewModel = AuthViewModel()
        
        WelcomeView()
            .environmentObject(viewModel)
    }
}
