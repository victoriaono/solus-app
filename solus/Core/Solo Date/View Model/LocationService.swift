//
//  LocationService.swift
//  solus
//
//  Created by Victoria Ono on 8/28/23.
//  Source: https://www.polpiella.dev/mapkit-and-swiftui-searchable-map

import MapKit

struct SearchCompletion: Identifiable {
    let id = UUID()
    let title: String
    var address: String?
}

struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let address: String
    
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
            lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class LocationService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let completer: MKLocalSearchCompleter
    var completions = [SearchCompletion]()
    private var searchResults = [MKLocalSearchCompletion]()
    
    private let coordinate = CLLocationCoordinate2D(latitude: 42.3523594, longitude: -71.0781525)
    
    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
        self.completer.region = .init(center: coordinate, span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func update(queryFragment: String) {
        completer.resultTypes = .pointOfInterest
        completer.queryFragment = queryFragment
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results.map { completion in
            let mapItem = completion.value(forKey: "_mapItem") as? MKMapItem
            return .init(
                    title: completion.title,
                    address: mapItem?.placemark.title
                )
        }
        searchResults = completer.results
    }
    
    func didSelectRowAt(row: Int) async throws -> [SearchResult] {
        let result = searchResults[row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        let response = try await search.start()
        
        return response.mapItems.compactMap { mapItem in
            guard let address = mapItem.placemark.title else { return nil }
            return .init(address: address)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.completer.region = .init(center: location.coordinate, span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }
}
