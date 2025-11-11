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

import Foundation
import GooglePlacesSwift
import UIKit  //required for photos
import CoreLocation

@MainActor
class PlaceDetailsManager: ObservableObject {
    @Published var place: Place?
    @Published var error: Error?
    @Published var isOpen: Bool?
    @Published var placePhoto: UIImage?
    @Published var photos: [Photo]?
    @Published var loadedPhotos: [UIImage] = []
    @Published var textResults: [Place]?
    
    private static let placesClient = PlacesClient.shared
    
    private let defaultProperties: [PlaceProperty] = [
        .businessStatus,      // For open/closed status
        .displayName,         // For place name
        .placeID,             // For identification
        .priceLevel,          // For price level ($, $$, etc)
        .rating,              // For star rating
        .numberOfUserRatings, // For review count
        .types,               // For place category
        .currentOpeningHours, // For current "Open now" and closing time
        .supportsDineIn,      // Replaces previous .dineIn
        .supportsTakeout,     // Replaces previous .takeout
        .supportsDelivery,    // Replaces previous .delivery
        .supportsCurbsidePickup,
        .coordinate,          // Reserved for future use (e.g., mapping)
        .editorialSummary     // Reserved for future use (e.g., place description)
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
    
    // function for checking if place is open
    func checkIfOpen(placeID: String) async {
        let request = IsPlaceOpenRequest(placeID: placeID)
        switch await Self.placesClient.isPlaceOpen(with: request) {
            case .success(let response):
                self.isOpen = response.status
            case .failure(let error):
                self.error = error
                self.isOpen = nil
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
    
    //MARK: Photos functionality
    
    func fetchPhotoDetails(placeID: String) async {
        let photoProperties: [PlaceProperty] = [
            .photos
        ]
        
        let fetchPlaceRequest = FetchPlaceRequest(
            placeID: placeID,
            placeProperties: photoProperties
        )

        switch await Self.placesClient.fetchPlace(with: fetchPlaceRequest) {
        case .success(let fetchedPlace):
            self.photos = fetchedPlace.photos
        case .failure(let placesError):
            self.error = placesError
            self.photos = nil
        }
    }
    
    // Photos must first be fetched as metadata through a place details request
    func fetchPlacePhoto(photo: Photo, maxSize: CGSize = CGSize(width: 1000, height: 1000)) async {
        let fetchPhotoRequest = FetchPhotoRequest(photo: photo, maxSize: maxSize)
        
        switch await Self.placesClient.fetchPhoto(with: fetchPhotoRequest) {
        case .success(let uiImage):
            self.placePhoto = uiImage
        case .failure(let placesError):
            self.error = placesError
            self.placePhoto = nil
        }
    }
        
    //Obtains the first details photo
    func fetchFirstPhoto(for placeID: String) async {
        await fetchPhotoDetails(placeID: placeID)
        
        if let firstPhoto = photos?.first {
            await fetchPlacePhoto(photo: firstPhoto)
        }
    }
    
    //Obtains the first 10 details photos for presentation
    func fetchPhotosForPlace(placeID: String, maxPhotos: Int = 10) async {
        await fetchPhotoDetails(placeID: placeID)
        
        if let photos = self.photos?.prefix(maxPhotos) {
            var tempPhotos: [UIImage] = []
            
            for photo in photos {
                await fetchPlacePhoto(photo: photo)
                if let image = placePhoto {
                    tempPhotos.append(image)
                }
            }
            
            // Update loadedPhotos only once with all images
            self.loadedPhotos = tempPhotos
        }
    }

    
    //MARK: Text Search Functionality
    
    func searchByText(query: String, location: CLLocationCoordinate2D, radius: Double, isOpenNow: Bool = false) async {
        let searchPlaceFields: [PlaceProperty] = [
            .formattedAddress,
            .addressComponents,
            .displayName,
            .placeID,
            .priceLevel,
            .rating,
            .numberOfUserRatings,
            .types,
            .coordinate
        ]
        
        let locationBias = CircularCoordinateRegion(
            center: location,
            radius: radius
        )
        
        let searchByTextRequest = SearchByTextRequest(
            textQuery: query,
            placeProperties: searchPlaceFields,
            locationBias: locationBias,
            isOpenNow: isOpenNow // Add this parameter
        )
        
        switch await PlacesClient.shared.searchByText(with: searchByTextRequest) {
        case .success(let places):
            self.textResults = places
        case .failure(let error):
            self.error = error
            self.textResults = nil
        }
    
    }

    // Clear current place details
    func clearDetails() {
        place = nil
        error = nil
    }
}
