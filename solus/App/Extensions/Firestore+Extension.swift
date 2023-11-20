//
//  Firestore+Extension.swift
//  solus
//
//  Created by Victoria Ono on 8/24/23.
//

import FirebaseFirestore

extension CollectionReference {
    func whereField(_ field: String, isDateInThisMonth value: Date) -> Query {
        let components = Calendar.current.dateComponents([.year, .month], from: value)
        guard
            let start = Calendar.current.date(from: components),
            let end = Calendar.current.date(byAdding: .month, value: 1, to: start)
        else {
            fatalError("Could not find start date or calculate end date.")
        }
        return whereField(field, isGreaterThanOrEqualTo: start).whereField(field, isLessThanOrEqualTo: end)
    }
}
