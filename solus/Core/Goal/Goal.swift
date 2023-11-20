//
//  Goal.swift
//  solus
//
//  Created by Victoria Ono on 8/2/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct HabitData: Codable, Hashable {
    var date: Date
    var habit: Bool
    
    var dictionary: [String: Any] {
        return ["date": date,
                "habit": habit]
    }
}

struct Goal: Note {
    @DocumentID var id: String?
    var title: String
    var startDate: Date
    var endDate: Date
    var frequency = 0
    var why = ""
    var habits: [HabitData] = []
}

extension Goal {
    static let MOCK_GOAL = Goal(title: "6-8 hours of sleep", startDate: Date().yesterday.yesterday, endDate: Date().tomorrow.tomorrow, why: "because I need more sleep")
}
