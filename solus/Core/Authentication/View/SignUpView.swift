//
//  SignUpView.swift
//  solus
//
//  Created by Victoria Ono on 7/26/23.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct SignUpView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isSaving = false
    
    var body: some View {
        VStack {
            Spacer()
            Image("Grey Logo")
            VStack {
                Text("New Account")
                    .modifier(Title(fontSize: 30))
                    .foregroundStyle(Color("slate"))
                
                HStack {
                    InputView(text: $firstName, placeholder: "first name")
                    InputView(text: $lastName, placeholder: "last name")
                }
                
                InputView(text: $email, placeholder: "email address")
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                
                InputView(text: $password, placeholder: "password", isSecureField: true)
                
                InputView(text: $confirmPassword, placeholder: "re-enter password", isSecureField: true)
            }
            .padding(.horizontal, 32)
//            .onTapGesture {
//                hideKeyboard()
//            }
            
            Spacer()
            
            Button {
                Task {
                    isSaving.toggle()
                    try await viewModel.createUser(withEmail: email, password: password, fullname: firstName + " " + lastName)
                }
            } label: {
                if !isSaving {
                    Text("done")
                }
                else {
                    ProgressView()
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
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                        .modifier(Default())
                    Text("Sign in")
                        .fontWeight(.bold)
                        .modifier(Default())
                }
            }
        }
    }
}

// MARK: - FormProtocol

extension SignUpView: FormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !firstName.isEmpty
        && !lastName.isEmpty
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
