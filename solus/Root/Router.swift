//
//  Router.swift
//  solus
//
//  Created by Victoria Ono on 9/15/23.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var selectedTab: Tab = .home
    @Published var homeNavigation: [HomeDestination] = []
    @Published var profileNavigation: [ProfileDestination] = []
    @Published var journalNavigation: [JournalDestination] = []
    @Published var searchNavigation: [SearchDestination] = []
}

enum HomeDestination: Hashable {
    case futureDate(User, SoloDate)
    
    static func == (lhs: HomeDestination, rhs: HomeDestination) -> Bool {
        switch (lhs, rhs) {
        case (.futureDate, .futureDate):
            return true
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .futureDate(_, solodate):
            hasher.combine(solodate)
        }
    }
}

enum SearchDestination: Hashable {
    case savedView
    case map(SpotType)
}

enum JournalDestination: Hashable {
    case edit(Entry)
}

enum ProfileDestination: Hashable {
    case solodateView(User, SoloDate)
    case goalView(User, Goal)
    case saved(User)
    case settings
    
    static func == (lhs: ProfileDestination, rhs: ProfileDestination) -> Bool {
        switch (lhs, rhs) {
        case (.solodateView, .solodateView),
            (.goalView, .goalView),
            (.saved, .saved),
            (.settings, .settings):
            return true
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .solodateView(_, solodate):
            hasher.combine(solodate)
        case let .goalView(_, goal):
            hasher.combine(goal)
        case .saved:
            hasher.combine(self)
        case .settings:
            hasher.combine(self)
        }
    }
}
