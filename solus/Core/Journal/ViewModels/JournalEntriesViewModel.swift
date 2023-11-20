//
//  JournalEntriesViewModel.swift
//  solus
//
//  Created by Victoria Ono on 8/3/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class JournalEntriesViewModel: ObservableObject {
    @Published var groupedEntries: [ListItem] = []
    @Published var entries = [Entry]() {
        didSet {
            entriesByDay()
        }
    }
    
    private let user: User
    private var docRef = Firestore.firestore().collection("users")
        
    init(user: User) {
        self.user = user
        Task {
            try await fetchEntries()
        }
    }
    
    func fetchEntries() async throws {
        docRef.document(self.user.id).collection("journal").order(by: "timestamp", descending: true)
            .addSnapshotListener{ querySnapshot, err in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.entries = documents.compactMap { queryDocumentSnapshot -> Entry? in
                return try? queryDocumentSnapshot.data(as: Entry.self)
            }
        }
    }
    
    func entriesByDay() {
        var dict: [ListItem] = []
        var copy = self.entries
        guard !copy.isEmpty else { return }
        
        // for some reason the newest entry gives a nil timestamp, but that means it's the latest so...
        let today = copy.filter({Calendar.current.isDateInToday($0.timestamp?.dateValue() ?? Date())})
        if today.count > 0 {
            dict.append(ListItem(day: "Today", items: today))
            copy.removeFirst(today.count)
        }
        let yesterday = copy.filter({Calendar.current.isDateInYesterday($0.timestamp!.dateValue())})
        if yesterday.count > 0 {
            dict.append(ListItem(day: "Yesterday", items: yesterday))
            copy.removeFirst(yesterday.count)
        }
        
        let lastTwoWeeks = copy.filter({Calendar.current.dateComponents([.day], from: $0.timestamp!.dateValue(), to: Date()).day! <= 14})
        if lastTwoWeeks.count > 0 {
            dict.append(ListItem(day: "Last 14 Days", items: lastTwoWeeks))
            copy.removeFirst(lastTwoWeeks.count)
        }
        
        while !copy.isEmpty {
            let entry = copy[0]
            let monthAndYear = Calendar.current.dateComponents([.month, .year], from: entry.timestamp!.dateValue())
            let monthStr = Calendar.current.monthSymbols[monthAndYear.month!-1]
            let year = monthAndYear.year!
            
            let grouped = copy.filter({ Int($0.date.prefix(1)) == monthAndYear.month! && Int($0.date.suffix(4)) == year })
            dict.append(ListItem(day: "\(monthStr) \(year)", items: grouped))
            copy.removeFirst(grouped.count)
        }

        groupedEntries = dict
    }
}
