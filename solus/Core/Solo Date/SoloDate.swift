//
//  SoloDate.swift
//  solus
//
//  Created by Victoria Ono on 8/2/23.
//

import Foundation
import FirebaseFirestoreSwift

struct SoloDate: Note {
    @DocumentID var id: String?
    var title: String
    var date: Date
    var time: Time
    var location = ""
    var rating: Int?
    var feeling = ""
    var favorite = ""
    var thoughts = ""
    var learning = ""
    var imageURLs: [String]?
    var privateEntry = false
    
    var dateAndTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, M/d/yyyy"
        
        return "\(formatter.string(from: date)) \(time.display)"
    }
}

extension SoloDate {
    static var MOCK_DATE = SoloDate(title: "solo date at tatte",
                                    date: Date().yesterday,
                                    time: Time(hour: 12, minute: 0, am: false),
                                    location: "1003 Beacon St, Brookline, MA 02446",
                                    rating: 4,
                                    feeling: "I really enjoyed my time today at tatte. I came here after a really helpful therapy sssion, so I was feeling really grateful and hopeful for the future. I focused on speaking to myself kindly and telling myself that the...",
                                    favorite: "my favorite parts were the seat I was sitting in, it was so light-filled and I liked being able to look out on to the street, the new mindset I had after therapy, and seeing ...",
                                    thoughts: "honestly not too much other than a silly negative voice about what I was eating, but I got past that.",
                                    learning: "I learned that I don't like tatte's decaf espresso at all, but I do like their walnut carrot loaf thing :) I learned also that no matter how much ...",
                                    imageURLs: ["https://firebasestorage.googleapis.com/v0/b/sol-us.appspot.com/o/90vbh87emDWvLyBuzaLOLrHKSPj2%2F0XMlzyLirphJYJx3qLe3%2Fphoto-0.jpg?alt=media&token=9d2db236-3ba5-46ba-b230-2cd2a512c4b6",
                                        "https://firebasestorage.googleapis.com/v0/b/sol-us.appspot.com/o/90vbh87emDWvLyBuzaLOLrHKSPj2%2FAilUN72SYKoULJQ2SgCn%2Fphoto-0.jpg?alt=media&token=95e3de7e-537b-4324-a762-121aac79aeda"],
                                    privateEntry: true
                                    )
}


struct SuggestedSoloDate: Identifiable, Codable {
    @DocumentID var id: String?
    let category: String
    let photo: String
    let description: String
}

struct Time: Identifiable, Equatable, Hashable, Codable {
    var id = UUID().uuidString
    var hour: Int
    var minute: Int
    var am: Bool
    
    var display: String {
        return "\(hour):\(minute == 0 ? "00" : "\(minute)") \(am ? "am" : "pm")"
    }
}
