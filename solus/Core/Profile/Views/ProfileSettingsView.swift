//
//  ProfileSettingsView.swift
//  solus
//
//  Created by Victoria Ono on 8/18/23.
//

import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State var showMonthlyView = false
    @State var presentAlert = false
    @State var presentSuccess = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image("Settings-Active")
                            .padding()
                    }
                }
                
                VStack(alignment: .leading, spacing: 14) {
                    Button {
                        showMonthlyView.toggle()
                    } label: {
                        HStack(alignment: .top) {
                            Image("Calendar")
                            Text("solo date monthly view")
                        }
                    }.fullScreenCover(isPresented: $showMonthlyView) {
                        MonthlyView(user: viewModel.currentUser!)
                    }
                    
                    Divider()
                        .overlay(Color("slate"))
                        .padding(.bottom, 15)
                    
//                    NavigationLink {
//                        // profile settings
//                    } label: {
//                        Text("profile settings")
//                    }
                    
                    Button {
                        viewModel.resetPassword()
                        if viewModel.emailSent {
                            presentSuccess.toggle()
                        }
                    } label: {
                        Text("reset my password")
                    }
                    
                    Button {
                        viewModel.signOut()
                    } label: {
                        Text("log out")
                    }
                    
                    Button {
                        presentAlert.toggle()
                    } label: {
                        Text("delete my account")
                    }
                    
                    Spacer()
                }
                .modifier(Default())
                .padding(.horizontal, 20)
                .padding(.top, 40)
            }
            .background(Color("lightsage"))
            .cornerRadius(20)
            
            if presentAlert {
                AlertView(presentAlert: $presentAlert, alertType: .account, leftButtonAction: self.handleDeleteTapped) {
                    withAnimation {
                        presentAlert.toggle()
                    }
                }
            }
            
            if presentSuccess {
                AlertView(presentAlert: $presentSuccess, alertType: .password, leftButtonAction: self.handleResendEmail)  {
                    withAnimation {
                        presentSuccess.toggle()
                    }
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    private func handleDeleteTapped() {
        self.viewModel.deleteUser()
    }
    
    private func handleResendEmail() {
        self.viewModel.emailSent = false
        self.viewModel.resetPassword()
    }
    
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}
