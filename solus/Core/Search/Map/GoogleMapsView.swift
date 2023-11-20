//
//  GoogleMapsView.swift
//  solus
//
//  Created by Victoria Ono on 8/9/23.
//

import SwiftUI
import GoogleMaps

struct MarkerInfoWindow: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UIView {
        let textView = UITextView()
        textView.text = text
        textView.font = UIFont(name: "GranthaSangamMN-Regular", size: 12)
        textView.textColor = UIColor(named: "darksage")

        return textView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}

struct GoogleMapsView: UIViewRepresentable {
    
//    @Binding var markers: [GMSMarker]
//    @Binding var selectedMarker: GMSMarker?
    
    private let defaultZoomLevel: Float = 15
    
    private let gmsMapView = GMSMapView(frame: .zero, mapID: GMSMapID(identifier: "e6fd7b9b496b38fa"), camera: GMSCameraPosition(latitude: 42.3523594, longitude: -71.0781525, zoom: 15))
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let boston = CLLocationCoordinate2D(latitude: 42.3523594, longitude: -71.0781525)
        gmsMapView.camera = GMSCameraPosition.camera(withTarget: boston, zoom: defaultZoomLevel)
        gmsMapView.delegate = context.coordinator
        
        let tatte = CLLocationCoordinate2D(latitude: 42.3521707, longitude: -71.0747614)
        let marker = GMSMarker(position: tatte)
        marker.title = "tatte"
        marker.icon = UIImage(named: "Marker")
        marker.map = gmsMapView

        return gmsMapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapView: GoogleMapsView
        var contentView = MapMarkerWindow(frame: CGRect(x: 0, y: 0, width: 40, height: 20), text: "tatte")
        
        init(_ mapView: GoogleMapsView) {
            self.mapView = mapView
        }
        
        func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
            return contentView
        }
    }
}

struct GoogleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleMapsView()
    }
}
