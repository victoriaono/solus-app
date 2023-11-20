//
//  MonthlyViewModel.swift
//  solus
//
//  Created by Victoria Ono on 8/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MonthlyViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var currentMonth = 0
    @Published var entries = [SoloDate]()
    @Published var user: User
    private var collectionRef: CollectionReference
    
    init(user: User = User.MOCK_USER) {
        self.user = user
        self.collectionRef = Firestore.firestore().collection("users").document(user.id).collection("solodates")
    }
    
    func extractMonthYear() -> String {
        // extract year and month for display
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        return formatter.string(from: getCurrentMonth())
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        // get current month and date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return Date() }
        return currentMonth
    }
    
    func extractDates() -> [DateValue] {
        let calendar = Calendar.current
        // get current month and date
        let currentMonth = getCurrentMonth()
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            // get day
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        // add offset days to get the exact week day
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekday-1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
    func fetchMonthlyEntries() {
        let calendar = Calendar.current
        // get current month and date
        guard let monthValue = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return }
        collectionRef.whereField("date", isDateInThisMonth: monthValue).addSnapshotListener { querySnapshot, err in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            self.entries = documents.compactMap { queryDocumentSnapshot -> SoloDate? in
                return try? queryDocumentSnapshot.data(as: SoloDate.self)
            }
        }
    }
}

