//
//  Enums.swift
//  solus
//
//  Created by Victoria Ono on 8/15/23.
//

import Foundation

enum Mode {
    case edit
    case view
}

enum Category: String {
    case SoloDate = "solo date"
    case JournalEntry = "journal entry"
    case Goal = "goal"
}

enum ImageSize: CGFloat {
    case xs = 20
    case s = 30
    case m = 50
    case l = 100
}

enum SpotType: CaseIterable {
    case Cafe
    case Museum
    case Restaurant
    case Cinema
    case Park
    case Gym
    
    var displayName: String {
        switch self {
        case .Cafe:
            return "cafes & coffee shops"
        case .Museum:
            return "museums"
        case .Restaurant:
            return "restaurants & dining"
        case .Cinema:
            return "cinemas & theaters"
        case .Park:
            return "walking routes & parks"
        case .Gym:
            return "gyms & workout studios"
        }
    }
}

enum PhotoType {
    case profile
    case logo
    case icon
}
