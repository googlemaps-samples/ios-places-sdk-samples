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

import Foundation
import GooglePlacesSwift

@MainActor
class PlaceDetailsManager: ObservableObject {
    @Published var place: Place?
    @Published var error: Error?
    
    private static let placesClient = PlacesClient.shared
    
    private let defaultProperties: [PlaceProperty] = [
        .addressComponents,
        .businessStatus,
        .displayName,
        .formattedAddress,
        .coordinate,
        .photos,
        .placeID,
        .priceLevel,
        .rating,
        .numberOfUserRatings,
        .editorialSummary,
        .reviews
    ]
    
    func fetchPlaceDetails(placeID: String, properties: [PlaceProperty]? = nil) async {
        let fetchPlaceRequest = FetchPlaceRequest(
            placeID: placeID,
            placeProperties: properties ?? defaultProperties
        )
        
        let result = await Self.placesClient.fetchPlace(with: fetchPlaceRequest)
        switch result {
        case .success(let fetchedPlace):
            self.place = fetchedPlace
        case .failure(let placesError):
            self.error = placesError
            self.place = nil
        }
    }
    
    // Fetch basic place details without reviews
    func fetchBasicDetails(placeID: String) async {
        let basicProperties: [PlaceProperty] = [
            .addressComponents,
            .displayName,
            .formattedAddress,
            .coordinate,
            .rating,
            .numberOfUserRatings,
            .priceLevel
        ]
        await fetchPlaceDetails(placeID: placeID, properties: basicProperties)
    }
    
    // Fetch only photos metadata
    func fetchPhotoDetails(placeID: String) async {
        let photoProperties: [PlaceProperty] = [
            .displayName,
            .photos
        ]
        await fetchPlaceDetails(placeID: placeID, properties: photoProperties)
    }
    
    // Clear current place details
    func clearDetails() {
        place = nil
        error = nil
    }
}
