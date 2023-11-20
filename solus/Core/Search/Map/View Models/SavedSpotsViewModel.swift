//
//  SavedSpotsViewModel.swift
//  solus
//
//  Created by Victoria Ono on 8/21/23.
//

import Foundation
import FirebaseFirestore

class SavedSpotsViewModel: ObservableObject {
    @Published var spots: [String: [Location]] = [:]
    @Published var logos = [String: String]()
    private let user: User
    private var category: SpotType
    private let db = Firestore.firestore()
    
    init(user: User, category: SpotType) {
        self.user = user
        self.category = category
    }
    
    func fetchData(with category: SpotType) {
        self.logos = [:]
        self.spots = [:]
        
        db.collection("users").document(user.id).collection("saved").whereField("category", isEqualTo: "\(category)").addSnapshotListener { querySnapshot, err in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            for document in documents {
                let id = document.documentID
                let logo = document.data()["logo"] as? String
                self.logos[id] = logo
                guard let locations = document.data()["location"] as? Array<String> else { return }
                for location in locations {
                    self.db.collection("\(category)").document(id).collection("locations").document(location).addSnapshotListener { queryDocumentSnapshot, err in
                        guard let document = queryDocumentSnapshot else { return }
                        guard let details = try? document.data(as: Location.self) else { return }
                        self.spots[id, default: [Location]()].append(details)
                    }
                }
            }
        }
    }
}
