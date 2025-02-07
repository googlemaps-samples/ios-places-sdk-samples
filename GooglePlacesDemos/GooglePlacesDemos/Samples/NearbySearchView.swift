// Copyright 2024 Google LLC. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.

import GooglePlacesSwift
import GoogleMaps
import SwiftUI

struct NearbySearchView: View {
    @State private var selectedMarker: GMSMarker?
    @State private var markers: [GMSMarker] = []
    @State private var hasInitializedSearch = false
    
    @StateObject private var searchManager = NearbySearchManager()
    
    private var selectedPlaceOpenStatus: Bool? {
        guard let place = selectedMarker?.userData as? Place,
              let placeId = place.placeID else {
            return nil
        }
        return searchManager.placeOpenStatuses[placeId]
    }
    
    private let mapOptions: GMSMapViewOptions = {
        var options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(
            latitude: 37.4220,  // Googleplex coordinates
            longitude: -122.0841,
            zoom: 14
        )
        return options
    }()
    
    private func calculateSearchRadius(zoom: Float) -> Double {
        let baseRadius = 500.0
        let zoomScale = pow(2.0, Double(20 - zoom))
        return min(baseRadius * zoomScale, 50000)
    }
    
    private func updateMarkers(from places: [Place]) {
        markers = places.map { place in
            let marker = GMSMarker(position: place.location)
            marker.title = place.displayName
            marker.userData = place
            return marker
        }
    }
    
    private func performInitialSearch() async {
        guard !hasInitializedSearch else { return }

        if let camera = mapOptions.camera {
            
            await searchManager.searchNearby(
                location: camera.target,
                includedTypes: [.cafe],
                radius: calculateSearchRadius(zoom: camera.zoom)
            )
            
            if let places = searchManager.places {
                updateMarkers(from: places)
            }
            
            hasInitializedSearch = true
        }
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            GoogleMapView(options: mapOptions)
                .mapMarkers(markers)
                .onMarkerTapped { marker in
                    if let mapView = marker.map {
                        mapView.selectedMarker = marker
                        selectedMarker = marker
                        
                        if let place = marker.userData as? Place,
                           let placeId = place.placeID {
                            Task {
                                await searchManager.fetchOpenStatus(for: placeId)
                            }
                        }
                    }
                    return true
                }
                .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
                .frame(maxWidth: .infinity, minHeight: 325)
                .onAppear {
                    Task {
                        await performInitialSearch()
                    }
                }
            
            if let selectedPlace = selectedMarker?.userData as? Place {
                PlaceDetailsCard(
                    place: selectedPlace,
                    isOpen: selectedPlaceOpenStatus
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("Tap a marker to see place details")
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            Spacer()
        }
    }
}
