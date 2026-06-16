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

import GooglePlacesSwift
import CoreLocation
import SwiftUI

struct NearbySearchView: View {
    @State private var selectedPlace: Place?
    @State private var hasInitializedSearch = false

    @StateObject private var searchManager = NearbySearchManager()
    
    private var selectedPlaceOpenStatus: Bool? {
        guard let placeId = selectedPlace?.placeID else {
            return nil
        }
        return searchManager.placeOpenStatuses[placeId]
    }

    // Hardcoded search parameters for demo
    private let searchLocation = CLLocationCoordinate2D(
        latitude: 37.7749,  // Central San Francisco
        longitude: -122.4194
    )
    private let searchRadius: Double = 500.0  // 500 meters
    private let searchType: PlaceType = .cafe

    private func performInitialSearch() async {
        guard !hasInitializedSearch else { return }

        await searchManager.searchNearby(
            location: searchLocation,
            includedTypes: [searchType],
            radius: searchRadius
        )

        hasInitializedSearch = true
    }

    var body: some View {
        VStack(spacing: 0) {
            // Search parameters display
            VStack(spacing: 4) {
                Text("Nearby Search Demo")
                    .font(.headline)
                Text("Searching for cafes within 500m of central San Francisco")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGroupedBackground))

            // Results list
            if let places = searchManager.places, !places.isEmpty {
                List(places, id: \.placeID) { place in
                    Button(action: {
                        selectedPlace = place
                        if let placeId = place.placeID {
                            Task {
                                await searchManager.fetchOpenStatus(for: placeId)
                            }
                        }
                    }) {
                        HStack {
                            Text(place.displayName ?? "Unknown Place")
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedPlace?.placeID == place.placeID {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            } else if searchManager.error != nil {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text("Failed to load places")
                        .font(.headline)
                    Button("Retry") {
                        hasInitializedSearch = false
                        Task {
                            await performInitialSearch()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ProgressView("Loading cafes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Selected place details
            if let selectedPlace = selectedPlace {
                PlaceDetailsCard(
                    place: selectedPlace,
                    isOpen: selectedPlaceOpenStatus
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("Select a place to see details")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .onAppear {
            Task {
                await performInitialSearch()
            }
        }
    }
}
