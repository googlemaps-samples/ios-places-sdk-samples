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

/// Manager class that handles nearby place searches using the Places SDK
/// Provides async search functionality and publishes results to observing views
@MainActor
class NearbySearchManager: ObservableObject {
    
    /// Currently loaded places, if any. Published to update observing views
    @Published var places: [Place]?
    
    /// Most recent error, if any. Published to update observing views
    @Published var error: Error?
    
    /// Dictionary of place open statuses keyed by placeID
    @Published var placeOpenStatuses: [String: Bool] = [:]
    
    /// Shared Places SDK client instance
    private static let placesClient = PlacesClient.shared
    
    /// PlaceDetailsManager instance for handling open status checks
    private let placeDetailsManager = PlaceDetailsManager()
    
    /// Default place properties to request for each returned place
    private let defaultProperties: [PlaceProperty] = [
        .displayName,          // Place name
        .placeID,              // For identification
        .rating,               // Rating out of 5
        .numberOfUserRatings,  // Number of ratings
        .coordinate,           // Location coordinates
        .photos,               // Place photos
        .editorialSummary,     // Brief description
        .currentOpeningHours,  // Operating hours
        .types,                // Place types (e.g., park, museum)
        .priceLevel            // Price level if applicable
    ]
    
    /// Fetches the open status for a single place
    /// - Parameter placeId: The ID of the place to check
    func fetchOpenStatus(for placeId: String) async {
        await placeDetailsManager.checkIfOpen(placeID: placeId)
        if let isOpen = placeDetailsManager.isOpen {
            placeOpenStatuses[placeId] = isOpen
        }
    }
    
    /// Performs a nearby search for places using the Places SDK
    /// - Parameters:
    ///   - location: Center point for the search
    ///   - includedTypes: Set of place types to search for
    ///   - radius: Search radius in meters from the center point
    ///   - maxResults: Maximum number of results to return (default: 20)
    ///   - rankPreference: How to rank results - by distance or popularity (default: distance)
    func searchNearby(
        location: CLLocationCoordinate2D,
        includedTypes: Set<PlaceType>,
        radius: Double,
        maxResults: Int = 20,
        rankPreference: SearchNearbyRequest.RankPreference = .distance
    ) async {
        
        // Clear previous open statuses when starting new search
        placeOpenStatuses.removeAll()
        
        // Create circular region for search area
        let region = CircularCoordinateRegion(
            center: location,
            radius: radius
        )
        
        // Configure the search request
        let searchNearbyRequest = SearchNearbyRequest(
            locationRestriction: region,
            placeProperties: defaultProperties,
            includedTypes: includedTypes,
            maxResultCount: maxResults,
            rankPreference: rankPreference
        )
        
        // Perform the search and handle results
        switch await Self.placesClient.searchNearby(with: searchNearbyRequest) {
        case .success(let foundPlaces):
            self.places = foundPlaces
            self.error = nil
        case .failure(let placesError):
            self.error = placesError
            self.places = nil
        }
    }
}
