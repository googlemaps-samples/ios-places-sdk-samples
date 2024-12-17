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
    
    @State private var currentLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State private var currentZoom: Float = 14.0
    @State private var markers: [GMSMarker] = []
    
    let parkTypes: Set<PlaceType> = [.park, .touristAttraction]
    
    private let mapOptions: GMSMapViewOptions = {
        var options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(
            latitude: 37.4220,  // Googleplex coordinates
            longitude: -122.0841,
            zoom: 11
        )
        return options
    }()
        
    var body: some View {
        VStack(spacing: 0) {
            GoogleMapView(options: mapOptions)
                .mapMarkers(markers)
                .onCameraIdle { position in
                    currentLocation = position.target
                    currentZoom = position.zoom
                }
                .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
                .frame(maxWidth: .infinity, minHeight: 325)
        }
        
        //TODO: Now call function to obtain the Nearby search place content based coordinates and radius
    }
    
    // Simple helper to calculate search radius based on zoom
    private func calculateSearchRadius(zoom: Float) -> Double {
        // At zoom level 10, radius = ~10km
        // At zoom level 15, radius = ~1km
        // At zoom level 20, radius = ~100m
        return 10000 * pow(0.5, Double(zoom - 10))
    }
    
}
