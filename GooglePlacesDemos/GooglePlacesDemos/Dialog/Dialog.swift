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

import SwiftUI

import SwiftUI
import CoreLocation
import GooglePlacesSwift

struct Dialog: View {
    
    @StateObject private var placeDetailsManager = PlaceDetailsManager()
    private let placeID = "ChIJLU7jZClu5kcR4PcOOO6p3I0" //TODO: Instead of hardcoding, let's have a enum of strings similar to GoogleMaps-SwiftUI
    
    var body: some View {
        VStack {
            if let place = placeDetailsManager.place {
                PlaceDetailsCard(place: place) //TODO: This call needs to be updated to support placeDetailsManager.isOpen
            } else {
                ProgressView()
            }
        }
        .task {
            await placeDetailsManager.fetchPlaceDetails(placeID: placeID)
            await placeDetailsManager.checkIfOpen(placeID: placeID)
        }
        .onAppear {
            // Log any existing error
            if let error = placeDetailsManager.error {
                print("Place Details Error: \(error)")
            }
        }
    }
}
