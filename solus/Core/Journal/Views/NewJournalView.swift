//
//  NewJournalView.swift
//  solus
//
//  Created by Victoria Ono on 7/29/23.
//

import SwiftUI

struct NewJournalView: View {
    
    @State private var title = ""
    @State private var content = ""
    @StateObject var viewModel: JournalEntryViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var presentAlert = false
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: JournalEntryViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                        .frame(height: 40)
                    HStack(alignment: .lastTextBaseline) {
                        Text("New entry.")
                            .modifier(Title())
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await viewModel.saveEntry(Entry(title: title, content: content))
                            }
                            dismiss()
                        } label: {
                            Text("done")
                                .modifier(Default())
                                .fontWeight(.bold)
                        }
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                    }
                    .padding(.horizontal, 5)
                    
                    InputView(text: $title, placeholder: "title", alignment: .leading)
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $content)
                            .textInputAutocapitalization(.never)
                            .padding(4)
                            .modifier(Default())
                        
                        if content.isEmpty {
                            Text("my journal entry...")
                                .modifier(Default(fontColor:"slate"))
                                .opacity(0.8)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                        }
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentAlert.toggle()
                        } label: {
                            Image("X")
                        }
                    }
                }
                if presentAlert {
                    AlertView(presentAlert: $presentAlert, alertType: .new, leftButtonAction: self.handleDismiss) {
                        withAnimation {
                            presentAlert.toggle()
                        }
                    }
                }
            }
        }
    }
    private func handleDismiss() {
        self.dismiss()
    }
}

extension NewJournalView: FormProtocol {
    var formIsValid: Bool {
        return title.count != 0 && !content.isEmpty
    }
}

struct NewJournalView_Previews: PreviewProvider {
    static var previews: some View {
        NewJournalView(user: User.MOCK_USER)
    }
}
