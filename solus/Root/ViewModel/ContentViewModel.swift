//
//  ContentViewModel.swift
//  solus
//
//  Created by Victoria Ono on 8/7/23.
//

//import Foundation
//import Combine
//import FirebaseAuth
//
//class ContentViewModel: ObservableObject {
//
//    private let service = AuthViewModel.shared
//    private var cancellables = Set<AnyCancellable>()
//
//    @Published var userSession: FirebaseAuth.User?
//    @Published var currentUser: User?
//
//    init() {
//        setupSubscribers()
//    }
//
//    func setupSubscribers() {
//        service.$userSession.sink { [weak self] userSession in
//            self?.userSession = userSession
//        }
//        .store(in: &cancellables)
//
//        service.$currentUser.sink { [weak self] currentUser in
//            self?.currentUser = currentUser
//        }
//        .store(in: &cancellables)
//    }
//
//
//}
