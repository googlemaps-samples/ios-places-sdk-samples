// Copyright 2025 Google LLC. All rights reserved.
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

import SwiftUI
import GoogleMaps

struct PlaceCardView: View {
    let placeId: String
    @StateObject private var placeDetailsManager = PlaceDetailsManager()
    @State private var cameraPosition: GMSCameraPosition?
    
    var body: some View {
        VStack(spacing: 16) {
            if let place = placeDetailsManager.place {
                
                // Map View in top portion
                GoogleMapView(options: GMSMapViewOptions())
                    .camera(cameraPosition)
                    .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
                    .frame(maxWidth: .infinity, minHeight: 325)
                
                // Place Details Card in bottom portion
                PlaceDetailsCard(place: place, isOpen: placeDetailsManager.isOpen)
                    .frame(maxWidth: .infinity, alignment: .leading)

                //provide place summary
                if let summary = place.editorialSummary {
                    Text(summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await placeDetailsManager.fetchPlaceDetails(placeID: placeId)
            
            if let place = placeDetailsManager.place {
                cameraPosition = GMSCameraPosition(
                    latitude: place.location.latitude,
                    longitude: place.location.longitude,
                    zoom: 15
                )
            }
            
            await placeDetailsManager.checkIfOpen(placeID: placeId)
        }
    }
}
