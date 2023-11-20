//
//  ProfileViewModel.swift
//  solus
//
//  Created by Victoria Ono on 8/18/23.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task {
            try await loadImage(from: selectedImage)
            try await uploadProfileImage()
        } }
    }
    
    @Published var profileImage: Image?
    @Published var updatedImageUrl: String?
    private var uiImage: UIImage?
    
    init(user: User) {
        self.user = user
    }
    
    func loadImage(from item: PhotosPickerItem?) async throws {
        guard let item = item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func uploadProfileImage() async throws {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        guard let imageData = uiImage?.jpegData(compressionQuality: 0.3) else { return }
        let ref = Storage.storage().reference().child("profile_images/\(user.id)")
            
        do {
            let _ = try await ref.putDataAsync(imageData, metadata: metadata)
            let url = try await ref.downloadURL().absoluteString
            try await Firestore.firestore().collection("users").document(user.id).updateData([
                "profileImageUrl": url
            ])
            updatedImageUrl = url
        } catch {
            print("Failed to upload profile image")
            return
        }
    }
}
