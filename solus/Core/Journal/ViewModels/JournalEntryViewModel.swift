//
//  JournalEntryViewModel.swift
//  solus
//
//  Created by Victoria Ono on 7/29/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class JournalEntryViewModel: ItemViewModel {

    @Published var entry: Entry
    @Published var user: User
    private var docRef = Firestore.firestore().collection("users")
    
    init(user: User, entry: Entry = Entry(title: "", content: "")) {
        self.user = user
        self.entry = entry
    }
    
    @MainActor
    func saveEntry(_ entry: Entry) async {
        do {
            try docRef.document(user.id).collection("journal").addDocument(from: entry)
            self.entry = entry
        } catch {
            print("Failed to save journal entry with error: \(error.localizedDescription)")
        }
    }
    
    func updateEntry(_ content: String) {
        if let id = entry.id {
            docRef.document(user.id).collection("journal").document(id).updateData([
                "content": content,
                "timestamp": FieldValue.serverTimestamp()
            ])
        }
    }
    
    func removeEntry() {
        if let id = entry.id {
          docRef.document(user.id).collection("journal").document(id).delete() { error in
                if let _ = error {
                    print("Failed to delete entry")
                }
            }
        }
    }
    
}
