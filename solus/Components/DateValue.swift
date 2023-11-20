//
//  DateValue.swift
//  solus
//
//  Created by Victoria Ono on 8/23/23.
//

import Foundation

struct DateValue: Identifiable, Equatable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
    var selectedDate: Date?
}
