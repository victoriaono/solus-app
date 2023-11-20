//
//  SearchViewModel.swift
//  solus
//
//  Created by Victoria Ono on 9/1/23.
//

import Foundation
import FirebaseFirestore

@MainActor
class SearchViewModel: ObservableObject {
    @Published var user: User
//    @Published var results = [SoloDate]()
    private let db = Firestore.firestore()
    
    init(user: User) {
        self.user = user
    }
    
    func searchSpots(with keyword: String) async {
        // search through suggested solo dates containing the keyword
        // return list of results containing data and whether it's a solo date or a spot
//        var solodates: [SuggestedSoloDate] = []
        
        // in the future filter by location
        
    }
}
