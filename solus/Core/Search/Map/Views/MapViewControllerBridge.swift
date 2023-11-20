//
//  MapViewControllerBridge.swift
//  solus
//
//  Created by Victoria Ono on 8/9/23.
//

import SwiftUI
import GoogleMaps

struct MapViewControllerBridge: UIViewControllerRepresentable {
    
    @Binding var markers: [GMSMarker]
    @Binding var results: [GMSMarker]
    @Binding var showResults: Bool
    var type: SpotType
    
    func makeUIViewController(context: Context) -> MapViewController {
        let uiViewController = MapViewController()
        uiViewController.markers = markers
        uiViewController.type = type
        
        return uiViewController
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        if showResults {
            uiViewController.mapView.clear()
            uiViewController.markers = results
            uiViewController.addMarkers()
            uiViewController.animateToResult(marker: results.first)
        }
    }
}
