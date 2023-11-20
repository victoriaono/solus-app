//
//  MapViewController.swift
//  solus
//
//  Created by Victoria Ono on 8/9/23.
//

import SwiftUI
import GoogleMaps
import UIKit

class MapMarkerWindow: UIView {
    lazy var title: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "GranthaSangamMN-Regular", size: 14)
        title.textColor = UIColor(named: "darksage")
        title.textAlignment = .center
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        
        return title
    }()
    
//    let backgroundView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.white
//        view.layer.cornerRadius = 10
//        return view
//    }()
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        setupView(text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView(_ text: String) {
//        addSubview(backgroundView)
        addSubview(title)
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        title.setContentHuggingPriority(.required, for: .vertical)
        title.setContentCompressionResistancePriority(.required, for: .vertical)
        title.text = text
        NSLayoutConstraint.activate([
//            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            backgroundView.topAnchor.constraint(equalTo: topAnchor),
//            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            title.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func sizeHeaderToFit(headerView: UIView) -> CGFloat {
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        return height
    }
}

class MapViewController: UIViewController {
    
    let map = GMSMapView(frame: .zero)
    var isAnimating: Bool = false
    
    var markers: [GMSMarker] = []
    var type: SpotType = .Cafe
    var contentView: MapMarkerWindow?

    lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: 42.349927, longitude: -71.078123, zoom: 15)
        let mapID = GMSMapID(identifier: "e6fd7b9b496b38fa")
        return GMSMapView(frame: .zero, mapID: mapID, camera: camera)
      }()
    
    override func loadView() {
        super.loadView()

        mapView.delegate = self
        view = mapView
        addMarkers()
    }
    
    func addMarkers() {
        markers.forEach { marker in
            marker.map = mapView
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let title = marker.title else { return nil }
        
        let contentView = MapMarkerWindow(frame: CGRect(x: 0, y: 0, width: 120, height: 60), text: title)
        
//        let contentView: UIView = UIView()
//        contentView.addSubview(label)
//        contentView.setNeedsDisplay()
//        contentView.frame = CGRectMake(0, 0, 80, self.view.frame.height)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(contentView)
        
//        NSLayoutConstraint.activate([
//            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            contentView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
//        ])
        
//        let stackView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 60))
//        stackView.axis = .vertical
        
//        stackView.addConstraint(NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80))
//        contentView.setNeedsLayout()
//        contentView.layoutIfNeeded()
        
//        label.setContentHuggingPriority(.required, for: .vertical)
//        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            label.topAnchor.constraint(equalTo: contentView.topAnchor),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
        
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 10
//        contentView.sizeToFit()
        return contentView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let name = marker.title {
            showSpotDetailView(name: name)
        }
    }
    
    func showSpotDetailView(name: String) {
        let host = UIHostingController(rootView: SpotDetailView(name: name, type: self.type))
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(host, animated: true)
    }
    
    func animateToResult(marker: GMSMarker?) {
        guard let position = marker?.position else { return }
        CATransaction.begin()
        CATransaction.setValue(Int(1.25), forKey: kCATransactionAnimationDuration)
        let positionCam = GMSCameraUpdate.setTarget(position, zoom: 13)
        mapView.animate(with: positionCam)
        mapView.selectedMarker = marker
        CATransaction.commit()
    }
    
}
