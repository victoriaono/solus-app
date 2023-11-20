//
//  AlertView.swift
//  solus
//
//  Created by Victoria Ono on 8/5/23.
//

import SwiftUI

enum AlertType {
    case existing
    case new
    case password
    case account
}

struct ConfirmationLabel: View {
    var text : String
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("whiteish"))
            Text(text)
                .modifier(Default())
                .padding(.top, 8)
        }
        .frame(width: 90, height: 30)
    }
}

struct AlertView: View {
    @Binding var presentAlert : Bool
    
    var alertType: AlertType
    var category: String?
    var title: String?
    var leftButtonAction: (() -> ())?
    var rightButtonAction: (() -> ())?
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
                Group {
                    switch alertType {
                    case .existing:
                        if let category = category {
                            Text("are you sure you want to delete this \(category)?")
                        }
                    case .new:
                        Text("are you sure you want to discard this entry?")
                    case .password:
                        Text("check your email to reset your password!")
                    case .account:
                        Text("are you sure you want to delete your account?")
                    }
                }
                .modifier(Default())
                .frame(maxWidth: 300)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
                Text(title ?? "")
                    .modifier(Default(fontSize: 18))
                HStack(alignment: .bottom) {
                    Button {
                        leftButtonAction?()
                    } label: {
                        if alertType != .password {
                            ConfirmationLabel(text: "yes, delete")
                        } else {
                            ConfirmationLabel(text: "resend email")
                        }
                    }
                    Button {
                        rightButtonAction?()
                    } label: {
                        if alertType != .password {
                            ConfirmationLabel(text: "no")
                        } else {
                            ConfirmationLabel(text: "done")
                        }
                    }
                }
            }
            .frame(width: 327, height: 172)
            .background(Color("lightsage"))
            .cornerRadius(20)
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        @State var alert = true
        AlertView(presentAlert: $alert, alertType: .new)
    }
}
