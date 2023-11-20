//
//  User.swift
//  solus
//
//  Created by Victoria Ono on 7/28/23.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    var profileImageUrl: String?
    var username: String?
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: "\(Environment.userId)", fullname: "Victoria Ono", email: "victorialily13@gmail.com")
}
