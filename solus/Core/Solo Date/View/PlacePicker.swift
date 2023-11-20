//
//  PlacePicker.swift
//  solus
//
//  Created by Victoria Ono on 8/27/23.
//

import SwiftUI
import MapKit

struct PlacePicker: View {
    @State private var locationService = LocationService(completer: .init())
    @State private var search = ""
    @Binding var searchResults: [SearchResult]
    @State private var isSearching = true
    
    var body: some View {
        VStack {
            if isSearching {
                InputView(text: $search, placeholder: "location", alignment: .leading)
                Spacer()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(Array(zip(locationService.completions.indices, locationService.completions)), id:\.0) { index, completion in
                            Button {
                                didTapOnCompletion(completion, row: index)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(completion.title)
                                        .modifier(Default())
                                        .multilineTextAlignment(.leading)
                                    if let address = completion.address {
                                        Text(address)
                                            .modifier(Default(fontSize: 12))
                                            .multilineTextAlignment(.leading)
                                    }
                                    Divider()
                                        .overlay(Color("slate"))
                                }
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                }
                .onChange(of: search) { _ in
                    locationService.update(queryFragment: search)
                }
            }
            else {
                Text(searchResults.first?.address ?? "")
                    .modifier(Default())
                    .padding(.leading, 10)
                    .padding(.top, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("whiteish"), in: RoundedRectangle(cornerRadius: 20))
                    .onTapGesture {
                        searchResults = []
                        isSearching.toggle()
                    }
            }
        } 
    }
    
    private func didTapOnCompletion(_ completion: SearchCompletion, row: Int) {
        Task {
            if let singleLocation = try? await locationService.didSelectRowAt(row: row).first {
                searchResults = [singleLocation]
            }
        }
        isSearching.toggle()
    }
}

struct PlacePicker_Previews: PreviewProvider {
    static var previews: some View {
        @State var searchRestuls = [SearchResult]()
        PlacePicker(searchResults: $searchRestuls)
    }
}
