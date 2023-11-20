//
//  SpotDetailView.swift
//  solus
//
//  Created by Victoria Ono on 8/19/23.
//

import SwiftUI

struct SpotDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @GestureState private var offSet = CGSize.zero
    @ObservedObject var viewModel: SpotDetailViewModel
    private var type: SpotType
    @State var save = false
    
    init(name: String, type: SpotType) {
        self.type = type
        self._viewModel = ObservedObject(wrappedValue: SpotDetailViewModel(name: name, type: "\(type)"))
        viewModel.fetchSpot()
        viewModel.fetchDetails()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Group {
                if let logo = viewModel.spot?.logo {
                    CircularImageView(imageName: logo, type: .logo, size: .m)
                } else {
                    CircularImageView(imageName: viewModel.type, type: .icon, size: .m)
                }
            }
            .padding([.leading, .bottom], 10)
            HeaderView(title: viewModel.name)
            HStack(alignment: .center) {
                Image(viewModel.type)
                    .resizable()
                    .scaledToFill()
                    .frame(width: ImageSize.xs.rawValue, height: ImageSize.xs.rawValue)
                    .padding(.bottom, 7)
                Text(type.displayName)
                    .modifier(Default(fontSize: 12))
            }
            
            
            Text("locations & hours")
                .modifier(Default())
            Divider()
                .overlay(Color("slate"))
                .padding(.bottom, 15)
        
            ScrollView() {
                ForEach(viewModel.details, id: \.self) { location in
                    ZStack(alignment: .topTrailing) {
                        VStack(alignment: .leading) {
                            // if locationName count is 1 that means the ID is "0" aka it's the only location
                            if let locationName = location.id, locationName.count > 1 {
                                Text(locationName)
                            }
                            Text(location.addressLine1)
                            Text(location.addressLine2)
                            if let hours = location.hours, !hours.isEmpty {
                                ForEach(hours, id:\.self) { hour in
                                    Text(hour)
                                }
                            }
                        }
                        .padding(.bottom, 15)
                        .modifier(Default())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // need a non-filled one
                        // need to know if the spot is already saved to display the right label and perform the right action
                        Button {
                            if let locationName = location.id {
                                viewModel.saveOrUnsaveSpot(locationName)
                            }
                        } label: {
                            // change based on viewModel.locationSaved
                            if let saved = viewModel.locationSaved[location.id ?? "0"], saved {
                                Image("Bookmark-Small")
                            } else {
                                Image("Plus-Active")
                            }
                        }
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .navigationBarBackButtonHidden(true)
        .gesture(DragGesture().updating($offSet, body: { (value, state, transaction) in
            if (value.startLocation.x < 20 && value.translation.width > 100) {
                self.dismiss()
            }
        }))
    }
        
}

struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SpotDetailView(name: "pavement coffeehouse", type: SpotType.Cafe)
    }
}
