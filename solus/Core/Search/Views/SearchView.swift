//
//  SearchView.swift
//  solus
//
//  Created by Victoria Ono on 7/23/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import Kingfisher

struct SearchView: View {
    
    @State private var keyword : String = ""
    @FirestoreQuery(collectionPath: "users", predicates: [.limit(to: 10)]) var savedSpots: [SavedSpot]
    @FirestoreQuery(collectionPath: "solodates", predicates: [.limit(to: 5)]) var suggestedSoloDates: [SuggestedSoloDate]
    @StateObject var viewModel: SearchViewModel
    @EnvironmentObject var router: Router
    @State var showResults = false
    @State var isLoading = true
    @State var scale = 0.1
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: SearchViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack(path: $router.searchNavigation) {
            ZStack {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 20)
                    Text("Search.")
                            .modifier(Title())
                            .padding()
                
                    VStack {
                        HStack {
                            Spacer()
                                .frame(width: 30)
                            VStack(alignment: .leading) {
                                Spacer()
                                    .frame(height: 11)
                                ZStack(alignment: .trailing) {
                                    InputView(text: $keyword, placeholder: "Search for ideas...", alignment: .leading)
                                        .onSubmit {
                                            Task {
                                                
                                            }
//                                            showResults.toggle()
                                        }
                                    
                                    Image("SearchBar")
                                }
                                .padding(.trailing)
                                    
                                VStack(alignment: .leading, spacing: 5) {
                                    NavigationLink(value: SearchDestination.savedView) {
                                        HStack(alignment: .center) {
                                            Text("my saved spots")
                                                .modifier(Default())
                                                .padding(.top, 6)
                                                .padding(.leading, 8)
                                            Image("Chevron-Right")
                                        }
                                    }
                                    
                                    ScrollView(.horizontal) {
                                        HStack {
                                            if isLoading {
                                                SpotView(name: "", logo: "Cafe")
                                                    .opacity(0)
                                            } else {
                                                ForEach(savedSpots) { spot in
                                                    if let logo = spot.logo, logo.count > 0 {
                                                        SpotView(name: spot.id ?? "", logo: logo)
                                                    } else {
                                                        SpotView(name: spot.id ?? "", logo: spot.category)
                                                    }
                                                }
                                                .scaleEffect(scale)
                                                .animate {
                                                    scale = 1
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("suggested solo dates in Boston")
                                        .modifier(Default())
                                        .padding(.top)
                                        .padding(.leading, 8)
                                    
                                    ScrollView(.horizontal) {
                                        HStack {
                                            if isLoading {
                                                SuggestedSoloDateView(description: "", image: "")
                                                    .opacity(0)
                                            } else {
                                                ForEach(suggestedSoloDates) { solodate in
                                                    SuggestedSoloDateView(description: solodate.description, image: solodate.photo)
                                                }
                                                .scaleEffect(scale)
                                                .animate {
                                                    scale = 1
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("search by category")
                                        .modifier(Default())
                                        .padding(.top)
                                        .padding(.leading, 8)
                                    
                                    ScrollView(.horizontal) {
                                        HStack(spacing: 15) {
                                            ForEach(SpotType.allCases, id: \.self) { category in
                                                NavigationLink(value: SearchDestination.map(category)) {
                                                    Image("\(category)")
                                                        .resizable()
                                                    .frame(width: 25, height: 25)
                                                }
                                            }
                                            .padding(.horizontal, 20)
                                        }
                                        .frame(height: 64)
                                        .background(Color.white)
                                        .cornerRadius(20)
                                    }
                                }
                                
                                Spacer()
                            }
                        }

                    }.frame(maxWidth: .infinity)
                    .background(Color("lightgrey"))
                    .cornerRadius(25)
                    
                }.offset(y: 25)
            }
            .navigationDestination(for: SearchDestination.self) { destination in
                switch destination {
                case .savedView:
                    SavedSpotsView(user: viewModel.user)
                case .map(let category):
                    MapView(type: category)
                }
            }
        }
        .task {
            $savedSpots.path = "users/\(viewModel.user.id)/saved"
            try? await Task.sleep(nanoseconds: 500_000_000)
            isLoading = false
        }
    }
}

extension SearchView {
    struct SpotView: View {
        var name: String
        var logo: String
        
        var body: some View {
            VStack(spacing: 5) {
                Spacer()
                if logo.first == "h" {
                    CircularImageView(imageName: logo, type: .logo, size: .m)
                } else {
                    CircularImageView(imageName: logo, type: .icon, size: .m)
                }
                Text(name)
                    .modifier(Default(fontSize: 11))
                    .multilineTextAlignment(.center)
                    .frame(maxHeight: .infinity)
            }
            .frame(width: 100, height: 111)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
    
    struct SuggestedSoloDateView: View {
        var description: String
        var image: String
        
        var body: some View {
            ZStack(alignment: .bottom) {
                KFImage(URL(string: image))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text(description)
                    .modifier(Default(fontSize: 11, fontColor: "whiteish"))
                    .fontWeight(.bold)
                    .shadow(color: .black, radius: 5, x: 0, y: 0)
                    .multilineTextAlignment(.center)
                    .frame(width: 120)
                    .offset(y: -5)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(user: User.MOCK_USER)
    }
}
