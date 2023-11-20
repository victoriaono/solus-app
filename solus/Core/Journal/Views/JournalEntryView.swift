//
//  JournalEntryView.swift
//  solus
//
//  Created by Victoria Ono on 7/30/23.
//

import SwiftUI

struct JournalEntryView: View {
    
    @StateObject var viewModel: JournalEntryViewModel
    @EnvironmentObject var router: Router
    @State private var presentAlert = false
    private var mode: Mode = .view
    @State private var content = ""
    @GestureState private var offSet = CGSize.zero
    @Environment(\.dismiss) private var dismiss
        
    init(user: User, entry: Entry, mode: Mode) {
        self._viewModel = StateObject(wrappedValue: JournalEntryViewModel(user: user, entry: entry))
        self.mode = mode
    }
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                if mode == .view {
                    HStack {
                        Spacer()
                        NavigationLink {
                            SettingsView(viewModel: viewModel, category: .JournalEntry)
                        } label: {
                            Image("Settings-Active")
                            .padding()
                        }
                    }
                } else {
                    Spacer()
                        .frame(height: 40)
                }
                
                HStack(alignment: .top) {
                    HeaderView(title: viewModel.entry.title)
                    Spacer()
                    if mode == .edit {
                        Button {
                            self.handleDoneTapped()
                        } label: {
                            Text("done")
                                .modifier(Default())
                                .fontWeight(.bold)
                                .padding(5)
                        }
                    }
                }
                
                VStack {
                    Text(viewModel.entry.time)
                        .modifier(Default())
                        .foregroundStyle(Color("greyish"))
                        .padding(.top, 8.0)
                        .padding(.leading, 12.0)
                        .modifier(LongText())
                    
                    ScrollView {
                        Group {
                            if mode == .edit {
                                TextEditor(text: $content)
                            } else {
                                Text(viewModel.entry.content)
                            }
                        }
                        .modifier(Default())
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 12.0)
                        .padding(.top, 5.0)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .onAppear {
                content = viewModel.entry.content
            }
            .gesture(DragGesture().updating($offSet, body: { (value, state, transaction) in
                if (value.startLocation.x < 20 && value.translation.width > 100) {
                    self.dismiss()
                }
            }))
    }
    
    private func handleDoneTapped() {
        self.viewModel.updateEntry(content)
        router.journalNavigation.removeLast()
    }
}

struct JournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let sample = Entry(title: "title", content: "content")
        JournalEntryView(user: User.MOCK_USER, entry: sample, mode: .view)
    }
}
