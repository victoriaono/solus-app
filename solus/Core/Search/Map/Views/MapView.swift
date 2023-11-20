//
//  MapView.swift
//  solus
//
//  Created by Victoria Ono on 7/24/23.
//

import SwiftUI
import GoogleMaps

struct MapView: View {
    
    @State private var keyword: String = ""
    @Environment(\.dismiss) private var dismiss
    private var type: SpotType
    @StateObject var viewModel: MapViewModel
    @State private var showMap = false
    @State private var showResults = false
    
    init(type: SpotType) {
        self.type = type
        self._viewModel = StateObject(wrappedValue: MapViewModel(type: "\(type)"))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: 40)
                
                HStack(alignment: .lastTextBaseline) {
                    Button {
                        dismiss()
                    } label: {
                        Image("Chevron-Left")
                    }
                    Text(type.displayName)
                        .modifier(Default(fontSize: 20))
                }
                
                Text("Boston, MA")
                    .modifier(Default(fontSize: 12))
                    .padding(.leading, 15)
            }
            .padding(.horizontal, 20)
                
            ZStack(alignment: .top) {
                if showMap {
                    MapViewControllerBridge(markers: $viewModel.markers, results: $viewModel.results, showResults: $showResults, type: type)
                    ZStack(alignment: .trailing) {
                        InputView(text: $keyword, placeholder: "Search", alignment: .leading)
                            .onSubmit {
                                viewModel.getResults(with: keyword)
                                keyword = ""
                                showResults = true
                            }
                            .onTapGesture {
                                showResults = false
                            }
                        Image("SearchBar")
                    }
                    .padding()
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await delayView()
        }
    }
    
    private func delayView() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        showMap = true
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(type: SpotType.Cafe)
    }
}
