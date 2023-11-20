//
//  solusApp.swift
//  solus
//
//  Created by Victoria Ono on 7/23/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseAuth
import GoogleMaps
import GooglePlaces

public enum Environment {
    enum Keys {
        static let apiKey = "Firebase_API_Key"
        static let userId = "User_ID"
    }
    
    private static let infoDictionary: [String: Any] =  {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("info plist not found")
        }
        return dict
    }()
    
    static let apiKey: String = {
        guard let apiKeyString = Environment.infoDictionary[Keys.apiKey] as? String else {
            fatalError("API Key not found")
        }
        return apiKeyString
    }()
    
    static let userId: String = {
        guard let userIdString = Environment.infoDictionary[Keys.userId] as? String else {
            fatalError("User ID not found")
        }
        return userIdString
    }()
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
      FirebaseApp.configure()
      GMSServices.provideAPIKey("\(Environment.apiKey)")
      GMSPlacesClient.provideAPIKey("\(Environment.apiKey)")

    return true
  }
}

@main
struct solusApp: App {    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var viewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
