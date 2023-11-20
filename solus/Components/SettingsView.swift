//
//  SettingsView.swift
//  solus
//
//  Created by Victoria Ono on 8/8/23.
//

import SwiftUI

protocol ItemViewModel: ObservableObject {
    associatedtype T: Note
    
    var entry: T { get }
    var user: User { get }
    
    func removeEntry()
}

protocol Note: Identifiable, Codable, Hashable {
    var title: String { get }
}

struct SettingsView: View {
    var viewModel: any ItemViewModel
    var category: Category
    
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) private var dismiss
    @State private var presentAlert = false
    @State private var showEdit = false
    
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
                        showEdit.toggle()
                    } label: {
                        Text("edit this \(self.category.rawValue)")
                    }
                    .fullScreenCover(isPresented: $showEdit) {
                        switch self.category {
                        case .JournalEntry:
                            JournalEntryView(user: viewModel.user, entry: viewModel.entry as! Entry, mode: .edit)
                        case .SoloDate:
                            SoloDateView(user: viewModel.user, solodate: viewModel.entry as! SoloDate, mode: .edit)
                        case .Goal:
                            GoalView(user: viewModel.user, goal: viewModel.entry as! Goal, mode: .edit)
                        }
                    }
                    
                    Button {
                        presentAlert.toggle()
                    } label: {
                        Text("delete this \(self.category.rawValue)")
                            
                    }
                    
                    if category == .SoloDate {
                        let solodate = self.viewModel.entry as! SoloDate
                        Button {
                            self.handlePrivateModeTapped()
                        } label: {
                            if solodate.privateEntry {
                                Image("Unlocked")
                                Text("make this solo date public")
                                    .offset(y: 4)
                            } else {
                                Image("Locked")
                                Text("make this solo date private")
                                    .offset(y: 4)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .modifier(Default())
                .padding(.leading, 20)
                .padding(.top, 40)
            }
            .background(Color("lightsage"))
            .cornerRadius(20)
            
            if presentAlert {
                AlertView(presentAlert: $presentAlert, alertType: .existing, category: self.category.rawValue, title: self.viewModel.entry.title, leftButtonAction: self.handleDeleteTapped) {
                    withAnimation {
                        presentAlert.toggle()
                    }
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    private func handleDeleteTapped() {
        self.viewModel.removeEntry()
        if !router.profileNavigation.isEmpty {
            router.profileNavigation.removeLast()
        } else if !router.journalNavigation.isEmpty {
            router.journalNavigation.removeLast()
        }
    }
    
    private func handlePrivateModeTapped() {
        let solodateVM = self.viewModel as! SoloDateViewModel
        solodateVM.switchPublicity()
        router.profileNavigation.removeLast()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var viewModel = SoloDateViewModel(user: User.MOCK_USER)
        @State var path = NavigationPath()
        SettingsView(viewModel: viewModel, category: .SoloDate)
    }
}
