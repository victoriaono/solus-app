//
//  SoloDateViewModel.swift
//  solus
//
//  Created by Victoria Ono on 8/2/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI
import PhotosUI

class SoloDateViewModel: ItemViewModel {
    
    @Published var entry: SoloDate
    @Published var user: User
    @Published var photoSelections: [PhotosPickerItem] = [] {
        didSet {
            Task {
                await setImages(from: photoSelections)
            }
        }
    }
    @Published var selectedImages: [UIImage] = [] 
    private var collectionRef: CollectionReference
    private var imagePath = ""
    private let storage = Storage.storage()
    
    init(user: User, solodate: SoloDate = SoloDate.MOCK_DATE) {
        self.user = user
        self.entry = solodate
        self.collectionRef = Firestore.firestore().collection("users").document(user.id).collection("solodates")
    }
    
    @MainActor
    func saveSoloDate(_ solodate: SoloDate) async throws {
        do {
            let documentRef = try collectionRef.addDocument(from: solodate)
            self.entry = solodate
            self.entry.id = documentRef.documentID
        } catch {
            print("Failed to save solo date with error: \(error.localizedDescription)")
        }
    }
    
    func updateSoloDate(entry: SoloDate, dict: [String: String]) {
        if let id = entry.id {
            collectionRef.document(id).updateData(dict)
        }
    }
    
    func saveImages(solodate: SoloDate, images: [UIImage]) async throws {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        guard let solodateID = solodate.id else { return }
        
        var urls: [String] = solodate.imageURLs ?? []
        let count = urls.count
        
        for (i, image) in images.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            
            let storageRef = storage.reference().child("\(user.id)/\(solodateID)/photo-\(i + count).jpg")
            do {
                let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
                let url = try await storageRef.downloadURL()
                urls.append(url.absoluteString)
            } catch {
                print("Failed to upload images")
            }
        }
        try await uploadImageData(id: solodateID, urls: urls)
    }
    
    func uploadImageData(id: String, urls: [String]) async throws {
        do {
            var updatedData = entry
            updatedData.imageURLs = urls
            try collectionRef.document(id).setData(from: updatedData)
        } catch {
            print("Failed to upload image URLs: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func setImages(from selections: [PhotosPickerItem]) async {
        var images: [UIImage] = []
        for item in selections {
            if let imageData = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                images.append(image)
            }
        }
        selectedImages = images
    }
    
    func switchPublicity() {
        if let id = entry.id {
            collectionRef.document(id).updateData([
                "privateEntry": !entry.privateEntry
            ])
        }
    }
    
    func removeEntry() {
        if let id = entry.id {
            collectionRef.document(id).delete() { error in
                if let _ = error {
                    print("Failed to delete entry")
                }
            }
            let storageRef = storage.reference().child("\(user.id)/\(id)/photo-0.jpg")
            storageRef.delete { error in
                if let _ = error {
                print("Failed to delete photo")
              }
            }
        }
    }
}
