//
//  SpotDetailViewModel.swift
//  solus
//
//  Created by Victoria Ono on 8/19/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class SpotDetailViewModel: ObservableObject {
    @Published var name: String
    @Published var type: String
    @Published var spot: Spot?
    @Published var details = [Location]() {
        didSet {
            fetchUserDetails()
        }
    }
    @Published var locationSaved = [String: Bool]()
    
    let db = Firestore.firestore()
    
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    func fetchSpot() {
        db.collection(type).document(name).addSnapshotListener { documentSnapshot, err in
            guard let document = documentSnapshot else {
                print("could not fetch document")
                return
            }
            if let logoUrl = document.data()?["logo"]  {
                self.spot = Spot(id: document.documentID, type: self.type, logo: "\(logoUrl)")
            }
            else {
                self.spot = Spot(id: document.documentID, type: self.type)
            }
        }
    }
    
    func fetchDetails() {
        db.collection(type).document(name).collection("locations").addSnapshotListener { querySnapshot, err in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.details = documents.compactMap { queryDocumentSnapshot -> Location? in
                return try? queryDocumentSnapshot.data(as: Location.self)
            }
        }
    }
    
    func fetchUserDetails() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let docRef = db.collection("users").document(userID).collection("saved").document(self.name)
        docRef.getDocument { document, err in
            if let document = document, let locations = document.data()?["location"] as? [String] {
                self.locationSaved = self.details.reduce(into: [String: Bool]()) {
                    if let locationName = $1.id {
                        // if it's "0" that means it's just one location
                        $0[locationName] = (locationName != "0" ? locations.contains(locationName) : true)
                    }
                }
            }
        }
    }
    
    func saveOrUnsaveSpot(_ location: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let docRef = db.collection("users").document(userID).collection("saved").document(self.name)
        
        docRef.getDocument { document, err in
            if let document = document, document.exists {
                // remove one of the locations if it already exists
                if let locations = document.data()?["location"] as? [String], location != "0", locations.contains(location) {
                    docRef.updateData([
                        "location": FieldValue.arrayRemove([location])
                    ])
                    print("removed successfully!")
                } 
                // when it's the only location
                else if location == "0" {
                    docRef.delete() { error in
                        if let _ = error {
                            print("Failed to remove saved spot")
                        }
                    }
                } else {
                    docRef.updateData([
                        "location": FieldValue.arrayUnion([location])
                    ])
                }
            } else {
                docRef.setData([
                    "logo": self.spot?.logo ?? "",
                    "category": self.type,
                    "location": [location]
                ])
            }
            self.locationSaved[location] = !(self.locationSaved[location] ?? true)
            print("updated successfully!")
        }
    }
    
    func unsaveSpot(_ location: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userID).collection("saved").document(self.name).delete() { error in
            if let _ = error {
                print("Failed to remove saved spot")
            }
        }
    }
    
}
