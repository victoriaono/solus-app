//
//  GoalViewModel.swift
//  solus
//
//  Created by Victoria Ono on 8/2/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class GoalViewModel: ItemViewModel {
    @Published var entry: Goal
    @Published var user: User
    private var docRef = Firestore.firestore().collection("users")
    
    init(user: User, entry: Goal = Goal(title: "", startDate: Date(), endDate: Date())) {
        self.user = user
        self.entry = entry
    }
    
    func saveEntry(_ entry: Goal) {
        do {
            try docRef.document(user.id).collection("goal").addDocument(from: entry)
            self.entry = entry
        } catch {
            print("Failed to save goal with error: \(error.localizedDescription)")
        }
    }
    
    func updateEntry(dict: [String: Any]) {
        if let id = entry.id {
            docRef.document(user.id).collection("goal").document(id).updateData(dict)
        }
    }
    
    func removeEntry() {
        if let id = entry.id {
          docRef.document(user.id).collection("goal").document(id).delete() { error in
                if let _ = error {
                    print("Failed to delete entry")
                }
            }
        }
    }
    
}
