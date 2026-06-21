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
import GooglePlacesSwift

struct PlaceCardView: View {
    let placeId: String
    @StateObject private var placeDetailsManager = PlaceDetailsManager()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if let place = placeDetailsManager.place {

                    // Place photo or location display - 45% of screen
                    Group {
                        if !placeDetailsManager.loadedPhotos.isEmpty {
                            // Show first photo if available
                            Image(uiImage: placeDetailsManager.loadedPhotos[0])
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.45)
                                .clipped()
                        } else if placeDetailsManager.photos != nil && !placeDetailsManager.photos!.isEmpty {
                            // Loading photo
                            ProgressView("Loading photo...")
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.45)
                                .background(Color(.systemGroupedBackground))
                        } else {
                            // No photos available - show location info
                            VStack(spacing: 12) {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray.opacity(0.5))

                                Text("No photos available")
                                    .font(.headline)
                                    .foregroundColor(.secondary)

                                Text("Lat: \(String(format: "%.4f", place.location.latitude)), Lon: \(String(format: "%.4f", place.location.longitude))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.45)
                            .background(Color(.systemGroupedBackground))
                        }
                    }

                    // Content below photo
                    VStack(alignment: .leading, spacing: 12) {
                        // Place Details Card
                        PlaceDetailsCard(place: place, isOpen: placeDetailsManager.isOpen)
                            .padding(.horizontal)
                            .padding(.top, 16)

                        //provide place summary
                        if let summary = place.editorialSummary {
                            Text(summary)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }

                        Spacer()
                    }
                    .frame(maxHeight: .infinity)

                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .task {
            // Fetch place details with photos included
            let propertiesWithPhotos: [PlaceProperty] = [
                .businessStatus,
                .displayName,
                .placeID,
                .priceLevel,
                .rating,
                .numberOfUserRatings,
                .types,
                .currentOpeningHours,
                .supportsDineIn,
                .supportsTakeout,
                .supportsDelivery,
                .supportsCurbsidePickup,
                .coordinate,
                .editorialSummary,
                .photos
            ]
            await placeDetailsManager.fetchPlaceDetails(placeID: placeId, properties: propertiesWithPhotos)
            await placeDetailsManager.checkIfOpen(placeID: placeId)
            // Fetch actual photo images
            await placeDetailsManager.fetchPhotosForPlace(placeID: placeId, maxPhotos: 1)
        }
    }
}
