//
//  SavedSpotsView.swift
//  solus
//
//  Created by Victoria Ono on 8/12/23.
//

import SwiftUI

struct SavedSpotsView: View {
    @StateObject var viewModel: SavedSpotsViewModel
    private let user: User
    @State private var selectedTab: SpotType = .Cafe
    @State private var showSpots = false
    @GestureState private var offSet = CGSize.zero
    @Environment(\.dismiss) private var dismiss
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: SavedSpotsViewModel(user: user, category: .Cafe))
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
                .frame(height: 40)
            HStack(alignment: .lastTextBaseline) {
                HeaderView(title: "my saved spots")
                Spacer()
                Image("Bookmark")
            }
            
            HStack {
                ForEach(SpotType.allCases, id:\.self) { category in
                    Button {
                        withAnimation {
                            selectedTab = category
                        }
                    } label: {
                        TabItemView(tabName: "\(category)", isSelected: selectedTab == category)
                    }
                }
            }
            .onChange(of: selectedTab) { newTab in
                viewModel.fetchData(with: newTab)
            }
            .frame(height: 50)
            .padding(.horizontal)
            
            Divider()
                .overlay(Color("slate"))
                .padding(.bottom, 25)

            ScrollView {
                VStack(alignment: .leading) {
                    if viewModel.spots.count > 0 {
                        ForEach(viewModel.spots.sorted(by: {$0.key < $1.key}), id:\.key) { name, locations in
                            ForEach(locations, id:\.self) { location in
                                if let url = viewModel.logos.first(where: {$0.key == name}), url.value.count > 0 {
                                    SpotRowView(imageName: url.value, name: name, addressLine1: location.addressLine1, addressLine2: location.addressLine2)
                                } else {
                                    SpotRowView(imageName: "\(selectedTab)", name: name, addressLine1: location.addressLine1, addressLine2: location.addressLine2)
                                }
                                
                            }
                            
                        }
                    }
                    else {
                        Text("nothing saved!")
                            .modifier(Default())
                    }
                }
                .padding(.leading, 20)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.fetchData(with: selectedTab)
        }
        .gesture(DragGesture().updating($offSet, body: { (value, state, transaction) in
            if (value.startLocation.x < 20 && value.translation.width > 100) {
                self.dismiss()
            }
        }))
    }
    
    private func delayView() async {
        showSpots = false
        try? await Task.sleep(nanoseconds: 500_000_000)
        showSpots = true
    }
    
}

struct SavedSpotsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSpotsView(user: User.MOCK_USER)
    }
}
