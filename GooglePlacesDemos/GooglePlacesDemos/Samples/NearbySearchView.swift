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
    
    @State private var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(
          latitude: 37.4220,
          longitude: -122.0841
      )
      @State private var currentZoom: Float = 14.0
      @State private var showingPlacesList = false
      @State private var markers: [GMSMarker] = []
      @StateObject private var searchManager = NearbySearchManager()
      
      private let mapOptions: GMSMapViewOptions = {
          var options = GMSMapViewOptions()
          options.camera = GMSCameraPosition(
              latitude: 37.4220,
              longitude: -122.0841,
              zoom: 14
          )
          return options
      }()
      
    private func calculateSearchRadius(zoom: Float) -> Double {
        // At zoom level 20 (maximum zoom): ~500m radius
        // At zoom level 15: ~8km radius
        // At zoom level 10: ~128km radius
        let baseRadius = 500.0  // meters at max zoom
        let zoomScale = pow(2.0, Double(20 - zoom))
        return min(baseRadius * zoomScale, 50000) // Cap at 50km (API limit)
    }
      
      private func updateMarkers(from places: [Place]) {
          markers = places.map { place in
              let marker = GMSMarker(position: place.location)
              marker.title = place.displayName
              return marker
          }
      }
      
      var body: some View {
          GoogleMapView(options: mapOptions)
              .mapMarkers(markers)
              .onMarkerTapped { marker in
                  if let mapView = marker.map {
                          mapView.selectedMarker = marker
                      }
                  //Prevent default centering behavior
                  return true
              }
              .onCameraIdle { position in
                  currentLocation = position.target
                  currentZoom = position.zoom
                  
                  Task {
                      await searchManager.searchNearby(
                          location: position.target,
                          includedTypes: [.cafe],
                          radius: calculateSearchRadius(zoom: position.zoom)
                      )
                      
                      if let places = searchManager.places {
                          updateMarkers(from: places)
                      }
                      showingPlacesList = true
                  }
              }
            /*
              .sheet(isPresented: $showingPlacesList) {
                  NearbyPlacesListView(searchManager: searchManager)
                      .presentationDetents([.medium, .large])
              }
            */
              .ignoresSafeAreaExceptTop()
      }

}
