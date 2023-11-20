//
//  ProfileView.swift
//  solus
//
//  Created by Victoria Ono on 7/25/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import Kingfisher
import PhotosUI

enum SubTab {
    case SoloDate
    case SavedSpot
    case Goal
    case Chat
}

struct ProfileView: View {
    @EnvironmentObject var router: Router
    @StateObject var profileVM: ProfileViewModel
    
    @FirestoreQuery(collectionPath: "users",
                    predicates: [.where("date", isLessThan: Date()), .order(by: "date", descending: true)])
        var soloDates: [SoloDate]
    @FirestoreQuery(collectionPath: "users") var goals: [Goal]
    @FirestoreQuery(collectionPath: "users", predicates: [.limit(to: 10)]) var savedSpots: [SavedSpot]
    
    private let user: User
    @State private var selectedTab: SubTab = .SoloDate
        
    init(user: User) {
        self.user = user
        self._profileVM = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack(path: $router.profileNavigation) {
                VStack {
                    ZStack(alignment: .bottom) {
                        VStack {
                            Spacer()
                                .frame(height: 63)
                            HStack {
                                Spacer()
                                NavigationLink(value: ProfileDestination.settings) {
                                    Image("Settings")
                                        .padding()
                                }
                            }
                            
                            HStack {
                                Text(user.fullname)
                                    .modifier(Title(fontSize: 40, fontColor: "whiteish"))
                                    .frame(maxWidth: 229, alignment: .leading)
                                
                                Spacer()
                                PhotosPicker(selection: $profileVM.selectedImage, matching: .images) {
                                    if let imageUrl = profileVM.updatedImageUrl {
                                        CircularImageView(imageName: imageUrl, type: .profile, size: .l)
                                    } else if let imageUrl = user.profileImageUrl {
                                        CircularImageView(imageName: imageUrl, type: .profile, size: .l)
                                    } else {
                                        Text(user.initials)
                                            .modifier(Title())
                                            .frame(width: ImageSize.l.rawValue, height: ImageSize.l.rawValue)
                                            .background(Color("whiteish"))
                                            .clipShape(Circle())
                                    }
                                }
                            }.padding()
                            
                            Spacer()
                        }
                        .background(Color("sage"))
                        .cornerRadius(25)
                        .padding(.horizontal, 12)
                        .frame(height: 282)
                        
                            HStack {
                                Button {
                                    withAnimation {
                                        selectedTab = .SoloDate
                                    }
                                } label: {
                                    TabItemView(tabName: "Heart", isSelected: selectedTab == .SoloDate)
                                }
                                Button {
                                    withAnimation {
                                        selectedTab = .Goal
                                    }
                                } label: {
                                    TabItemView(tabName: "Check", isSelected: selectedTab == .Goal)
                                }
                                Button {
                                    withAnimation {
                                        selectedTab = .SavedSpot
                                    }
                                } label: {
                                    TabItemView(tabName: "Bookmark", isSelected: selectedTab == .SavedSpot)
                                }
                                Button {
                                    withAnimation {
                                        selectedTab = .Chat
                                    }
                                } label: {
                                    TabItemView(tabName: "Chat", isSelected: selectedTab == .Chat)
                                }
                            }
                            .padding(.horizontal)
                            .frame(height: 62)
                            .frame(width: geo.size.width * 0.8)
                            .background(Color("lightsage"))
                            .cornerRadius(20)
                        .offset(y: 31)
                    }
                    .offset(y: -25)
                    
                    Spacer()
                        .frame(height: 14)
                    
                    if selectedTab == .SoloDate {
                        ScrollView {
                            VStack(alignment: .leading) {
                                let count = Int(ceil(Double(soloDates.count)/3.0))
                                ForEach(0 ..< count, id: \.self) { i in
                                    HStack {
                                        ForEach(0..<3) { j in
                                            let index = i*3 + j
                                            if index < soloDates.count {
                                                let solodate = soloDates[index]
                                                NavigationLink(value: ProfileDestination.solodateView(user, solodate)) {
                                                    if let imageURLs = solodate.imageURLs, !imageURLs.isEmpty {
                                                        KFImage(URL(string: imageURLs[0]))
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 100, height: 111)
                                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                    //                                            .cancelOnDisappear(true) if it's out of the screen?
                                                    }
                                                    else {
                                                        ZStack {
                                                            RoundedRectangle(cornerRadius: 20)
                                                                .fill(Color("lightsage"))
                                                                .frame(width: 100, height: 111)
                                                            Image("Cafe")
                                                        }
                                                    }
                                                }
                                            }
                                            else {
                                                Rectangle()
                                                    .frame(width: 100, height: 111)
                                                    .opacity(0)
                                            }
                                        }
                                    }
                                    .frame(width: geo.size.width * 0.85)
                                }
                            }
                        }
                    }
                        
                    if selectedTab == .Goal {
                        VStack(alignment: .trailing) {
                            WeekScrollerView() { week in WeekView(week: week) }
                                .frame(width: 250, height: 50)
                            ScrollView {
                                ForEach(goals) { goal in
                                    NavigationLink(value: ProfileDestination.goalView(user, goal)) {
                                        GoalItemView(user: user, goal: goal)
                                    }
                                }
                            }
                        }
                        .environmentObject(WeekStore())
                        .frame(width: geo.size.width * 0.85)
                    }
                    
                    if selectedTab == .SavedSpot {
                        VStack(alignment: .trailing, spacing: 10) {
                            NavigationLink(value: ProfileDestination.saved(user)) {
                                HStack {
                                    Text("more details")
                                        .modifier(Default())
                                        .offset(y: 4)
                                    Image("Chevron-Right")
                                }
                            } 
                            ScrollView {
                                ForEach(savedSpots) { spot in
                                    SavedSpotView(savedSpot: spot)
                                }
                            }
                        }
                        .frame(width: geo.size.width * 0.85)
                    }
                }
                .frame(maxHeight: .infinity)
                .navigationDestination(for: ProfileDestination.self) { destination in
                    switch destination {
                    case let .solodateView(user, solodate):
                        SoloDateView(user: user, solodate: solodate, mode: .view)
                    case let .goalView(user, goal):
                        GoalView(user: user, goal: goal, mode: .view)
                    case let .saved(user):
                        SavedSpotsView(user: user)
                    case .settings:
                        ProfileSettingsView()
                    }
                }
                .edgesIgnoringSafeArea(.top)

            }
        }
        .task {
            $soloDates.path = "users/\(user.id)/solodates"
            $goals.path = "users/\(user.id)/goal"
            $savedSpots.path = "users/\(user.id)/saved"
        }
    }
}

extension ProfileView {
    struct SavedSpotView: View {
        var savedSpot: SavedSpot
        
        var body: some View {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("whiteish"))
                    .frame(height: 70)
                HStack(alignment: .center) {
                    Text(savedSpot.id ?? "")
                        .modifier(Default())
                        .padding(.top, 5)
                    Spacer()
                    Image(savedSpot.category)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        
        ProfileView(user: User.MOCK_USER)
            .environmentObject({() -> AuthViewModel in
                let envObj = AuthViewModel()
                envObj.currentUser = User.MOCK_USER
                return envObj
            }() )
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("iPhone 14")

        ProfileView(user: User.MOCK_USER)
            .environmentObject({() -> AuthViewModel in
                let envObj = AuthViewModel()
                envObj.currentUser = User.MOCK_USER
                return envObj
            }() )
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
            .previewDisplayName("iPhone 14 Pro Max")
        
    }
}
