//
//  MapViewModel.swift
//  solus
//
//  Created by Victoria Ono on 8/18/23.
//

import Foundation
import GoogleMaps
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class MapViewModel: ObservableObject {
    @Published var type: String
    @Published var markers = [GMSMarker]()
    @Published var names = [String]() {
        didSet {
            loadLocations()
        }
    }
    @Published var locations = [String: [Location]]() {
        didSet {
            self.markers = loadMarkers(for: type)
        }
    }
    @Published var results = [GMSMarker]()
    
    private let db = Firestore.firestore()
    
    init(type: String) {
        self.type = type
        loadNames()
    }
    
    func loadNames() {
        db.collection(self.type).addSnapshotListener { querySnapshot, err in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            self.names = documents.map { $0.documentID }
        }
    }
    
    func loadLocations() {
        for name in self.names {
            db.collection(self.type).document(name).collection("locations").addSnapshotListener { querySnapshot, err in
                guard let documents = querySnapshot?.documents else {
                    print("no locations")
                    return
                }
                self.locations[name, default: [Location]()].append(contentsOf: documents.compactMap { queryDocumentSnapshot -> Location? in
                    try? queryDocumentSnapshot.data(as: Location.self)
                })
            }
        }
    }
    
    func loadMarkers(for category: String) -> [GMSMarker] {
        let markers = self.locations.reduce(into: [GMSMarker]()) { res, data in
            for location in data.value {
                let marker = GMSAdvancedMarker(position: CLLocationCoordinate2D(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude))
                marker.title = data.key
                marker.icon = UIImage(named: "Marker")
                res.append(marker)
            }
        }
        return markers
    }
    
    func getResults(with keyword: String) {
        results = self.markers.filter { $0.title!.contains(keyword.lowercased()) }
    }
}
