//
//  Spot.swift
//  solus
//
//  Created by Victoria Ono on 8/10/23.
//

import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Spot: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    var type: String
    var logo: String?
}

struct Location: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    var coordinates: GeoPoint
    var addressLine1: String
    var addressLine2: String
    var hours: [String]? = []
}

struct SavedSpot: Identifiable, Codable {
    @DocumentID var id: String?
    var category: String
    var logo: String?
}
