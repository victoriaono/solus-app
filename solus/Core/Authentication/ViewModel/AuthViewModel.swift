//
//  AuthViewModel.swift
//  solus
//
//  Created by Victoria Ono on 7/28/23.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

protocol FormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var showError = false
    var errorMessage = ""
    @Published var emailSent = false
        
    init() {
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            print("logged in!")
        } catch {
            errorMessage = "wrong email or password"
            showError = true
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            print("success!")

        } catch {
            print("Failed to create user: \(error.localizedDescription), \(error)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // sign user out on backend
            self.userSession = nil // wipes out user session takes back to login screen
            self.currentUser = nil // wipes out current user data model
        } catch {
            print("Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        self.userSession = Auth.auth().currentUser
        guard let uid = self.userSession?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func resetPassword() {
        if let email = self.currentUser?.email {
            Auth.auth().sendPasswordReset(withEmail: email)
            emailSent = true
        }
    }
    
    func deleteUser() {
        self.userSession?.delete { err in
            if let _ = err {
                print("error deleting account")
                self.currentUser = nil
            } else {
                print("account deleted successfully")
            }
        }
    }
    
}
