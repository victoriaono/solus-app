//
//  TabView.swift
//  solus
//
//  Created by Victoria Ono on 7/28/23.
//

import SwiftUI

enum Tab {
    case home
    case search
    case new
    case journal
    case profile
}

struct TabbedView: View {
    @StateObject var router = Router()
    var user : User
    
    var body: some View {
        TabView(selection: tabSelection()) {
            HomeView(user: user)
                .tabItem { router.selectedTab == .home ? Image("Home-Active") : Image("Home")
                }.tag(Tab.home)
            
            SearchView(user: user)
                .tabItem { router.selectedTab == .search ? Image("Search-Active") : Image("Search")
                }.tag(Tab.search)
            
            NewView(user: user)
                .tabItem { router.selectedTab == .new ? Image("Plus-Active") : Image("Plus")
                }.tag(Tab.new)
            
            JournalView(user: user)
                .tabItem { router.selectedTab == .journal ? Image("Journal-Active") : Image("Journal")
                }.tag(Tab.journal)
            
            ProfileView(user: user)
                .tabItem { router.selectedTab == .profile ? Image("Profile-Active") : Image("Profile")
                }.tag(Tab.profile)
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .white
        }
        .environmentObject(router)
    }
    
    private func tabSelection() -> Binding<Tab> {
        Binding<Tab>(
            get: { router.selectedTab },
            set: { tappedTab in
                if tappedTab == router.selectedTab {
                    switch tappedTab {
                    case .home:
                        withAnimation {
                            router.homeNavigation = []
                        }
                    case .search:
                        // goes back to a blank view if user went to map -> spot detail so...
                        withAnimation {
                            if let first = router.searchNavigation.first, first == .savedView {
                                router.searchNavigation = []
                            }
                        }
                    case .journal:
                        withAnimation {
                            router.journalNavigation = []
                        }
                    case .profile:
                        withAnimation {
                            router.profileNavigation = []
                        }
                    default:
                        router.homeNavigation = []
                    }
                }
                // set the tab to the selected tab
                router.selectedTab = tappedTab
            }
        )
    }
    
}

struct TabbedView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedView(user: User.MOCK_USER)
    }
}
