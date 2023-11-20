//
//  JournalView.swift
//  solus
//
//  Created by Victoria Ono on 7/25/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ListItem {
    let day: String
    let items: [Entry]
}

struct JournalView: View {
    @StateObject var viewModel: JournalEntriesViewModel
    @EnvironmentObject var router: Router
    private let user: User
    @State private var viewJournal = false
    @State private var path = NavigationPath()

    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: JournalEntriesViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack(path: $router.journalNavigation) {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 40)
                    
                    Text("My journal.")
                        .modifier(Title(fontSize: 40))
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Spacer()
                                
                                Button {
                                    viewJournal.toggle()
                                } label: {
                                    Image("Plus-Active")
                                        .resizable()
                                        .frame(width: 14, height: 14)
                                }
                                .fullScreenCover(isPresented: $viewJournal) {
                                    NewJournalView(user: user)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(viewModel.groupedEntries, id:\.day) { group in
                                    VStack(alignment: .leading) {
                                        Spacer()
                                            .frame(height: 10)
                                        Text(group.day)
                                            .modifier(Default(fontSize: 18))
                                            .padding(.leading, 5)
                                            .padding(.bottom, 1)
                                        
                                        ForEach(group.items) { entry in
                                            NavigationLink(value: JournalDestination.edit(entry)) {
                                                JournalItemView(title: entry.title, date: entry.date)
                                            }
                                            .padding(.bottom, 1)
                                        }
                                    }
                                }
                            }
                            .padding(.top, -25)
                        }
                    }
                }
                .padding()
                .navigationBarBackButtonHidden(true)
                .navigationDestination(for: JournalDestination.self) { destination in
                    switch destination {
                    case .edit(let entry):
                        JournalEntryView(user: user, entry: entry, mode: .view)
                    }
                }
            }
    }
}

extension JournalView {
    struct JournalItemView: View {
        var title = ""
        var date = ""
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("whiteish"))
                    .frame(height: 40)
                HStack {
                    Text(title)
                        .modifier(Default())
                    Spacer()
                    Text(date)
                        .modifier(Default())
                }
                .padding(.top, 8)
                .padding(.horizontal, 20)
            }
        }
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView(user: User.MOCK_USER)
    }
}
