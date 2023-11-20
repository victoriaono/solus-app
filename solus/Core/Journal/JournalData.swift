//
//  JournalData.swift
//  solus
//
//  Created by Victoria Ono on 7/29/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Entry: Note {
    @DocumentID var id: String?
    @ServerTimestamp var timestamp: Timestamp?
    var title: String
    var content: String
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        
        if let date = timestamp?.dateValue() {
            return formatter.string(from: date)
        }
        
        return ""
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, M/d/yyyy h:mm a"
        
        if let time = timestamp?.dateValue() {
            return formatter.string(from: time)
        }
        
        return ""
    }
    
}
