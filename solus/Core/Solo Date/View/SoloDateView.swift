//
//  SoloDateView.swift
//  solus
//
//  Created by Victoria Ono on 8/6/23.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct SoloDateView: View {
    
    @StateObject var viewModel: SoloDateViewModel
    @EnvironmentObject var router: Router
    private var mode: Mode = .edit
    @State private var feeling = ""
    @State private var favorite = ""
    @State private var thoughts = ""
    @State private var learning = ""
    @State private var isSaving = false
    @GestureState private var offSet = CGSize.zero
    @Environment(\.dismiss) private var dismiss
        
    init(user: User, solodate: SoloDate, mode: Mode) {
        self._viewModel = StateObject(wrappedValue: SoloDateViewModel(user: user, solodate: solodate))
        self.mode = mode
    }
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                if mode == .view {
                    HStack {
                        Spacer()
                        NavigationLink {
                                SettingsView(viewModel: viewModel, category: .SoloDate)
                            } label: {
                                Image("Settings-Active")
                                    .padding()
                            }
                    }
                } else {
                    Spacer()
                        .frame(height: 40)
                }
                HStack(alignment: .top) {
                    HeaderView(title: viewModel.entry.title)
                    Spacer()
                    
                    if mode == .edit {
                        Button {
                            isSaving.toggle()
                            Task {
                                try await self.handleDoneTapped()
                            }
                        } label: {
                            if !isSaving {
                                Text("done")
                                    .modifier(Default())
                                    .fontWeight(.bold)
                                    .padding(5)
                            } else {
                                ProgressView()
                            }
                        }
                    }
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        Image(viewModel.entry.privateEntry ?  "Locked" : "Unlocked")
                            .padding(.leading, 8)
                            .padding(.bottom, 5)
                        
                        Text(viewModel.entry.dateAndTime)
                            .modifier(Default())
                            .padding(.top, 8.0)
                            .padding(.leading, 12.0)
                            .modifier(LongText())
                        
                        
                        Text(viewModel.entry.location)
                            .modifier(Default())
                            .padding(.top, 8.0)
                            .padding(.leading, 12.0)
                            .modifier(LongText())
                        
                        if let rating = viewModel.entry.rating {
                            HStack {
                                RatingView(rating: .constant(rating), mode: .view)
                                    .frame(width: 120, height: 30)
                                    .padding(.horizontal)
                                    .background(Color("whiteish"), in: RoundedRectangle(cornerRadius: 20))
                                Spacer()
                            }
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color("whiteish"))
                            ScrollView(.horizontal) {
                                HStack(spacing: 30) {
                                    if let imageURLs = viewModel.entry.imageURLs {
                                        ForEach(imageURLs, id: \.self) { imageURL in
                                            KFImage(URL(string: imageURL))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 133)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                        }
                                    }
                                    if mode == .edit {
                                        // right now can only add photos but not delete
                                        ForEach(Array(viewModel.selectedImages.enumerated()), id: \.0) { index, img in
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: img)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 120, height: 133)
                                                    .cornerRadius(20)
                                            }
                                            
                                        }
                                        //                                    if let imageURLs = viewModel.entry.imageURLs, imageURLs.isEmpty {
                                        PhotosPicker(selection: $viewModel.photoSelections, maxSelectionCount: 3, matching: .any(of: [.images, .not(.videos)])) {
                                            Image("Plus-Active")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 20, height: 20)
                                        }
                                        .tint(Color("slate"))
                                        .frame(width: 120, height: 133)
                                        .background(Color("whiteish"))
                                        //                                    }
                                    }
                                }
                                .padding()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("how did this solo date make me feel?")
                                .padding(.leading, 8)
                            if mode == .view {
                                Text(viewModel.entry.feeling)
                                    .padding()
                                    .modifier(LongText())
                            } else {
                                LongInputView(text: $viewModel.entry.feeling)
                                    .onChange(of: viewModel.entry.feeling) { newValue in
                                        feeling = viewModel.entry.feeling
                                    }
                            }
                            
                            Text("favorite parts of this solo date")
                                .padding(.leading, 8)
                            if mode == .view {
                                Text(viewModel.entry.favorite)
                                    .padding()
                                    .modifier(LongText())
                            } else {
                                LongInputView(text: $viewModel.entry.favorite)
                                    .onChange(of: viewModel.entry.favorite) { newValue in
                                        favorite = viewModel.entry.favorite
                                    }
                            }
                            
                            Text("what insecurities or uncomfortable thoughts came up?")
                                .padding(.leading, 8)
                            if mode == .view {
                                Text(viewModel.entry.thoughts)
                                    .padding()
                                    .modifier(LongText())
                            } else {
                                LongInputView(text: $viewModel.entry.thoughts)
                                    .onChange(of: viewModel.entry.thoughts) { newValue in
                                        thoughts = viewModel.entry.thoughts
                                    }
                            }
                            
                            Text("what did I learn?")
                                .padding(.leading, 8)
                            if mode == .view {
                                Text(viewModel.entry.learning)
                                    .padding()
                                    .modifier(LongText())
                            } else {
                                LongInputView(text: $viewModel.entry.learning)
                                    .onChange(of: viewModel.entry.learning) { newValue in
                                        learning = viewModel.entry.learning
                                    }
                            }
                        }
                        .modifier(Default())
                    }
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .gesture(DragGesture().updating($offSet, body: { (value, state, transaction) in
                if (value.startLocation.x < 20 && value.translation.width > 100) {
                    self.dismiss()
                }
            }))
    }
    
    func handleDoneTapped() async throws {
        var data = [String: String]()
        if feeling.count > 0 {
            data["feeling"] = feeling
        }
        if favorite.count > 0 {
            data["favorite"] = favorite
        }
        if thoughts.count > 0 {
            data["thoughts"] = thoughts
        }
        if learning.count > 0 {
            data["learning"] = learning
        }
        if viewModel.selectedImages.count > 0 {
            try await viewModel.saveImages(solodate: viewModel.entry, images: viewModel.selectedImages)
        }
        self.viewModel.updateSoloDate(entry: viewModel.entry, dict: data)
        
        // solo date can be edited either from profile or home, so check which one it came from
        if !router.profileNavigation.isEmpty {
            router.profileNavigation.removeLast()
        } else if !router.homeNavigation.isEmpty {
            router.homeNavigation.removeLast()
        }
    }
}

struct SoloDateView_Previews: PreviewProvider {
    static var previews: some View {
        SoloDateView(user: User.MOCK_USER, solodate: SoloDate.MOCK_DATE, mode: .view)
    }
}
