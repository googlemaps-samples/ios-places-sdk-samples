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
import GooglePlacesSwift

struct Dialog: View {
    
    @StateObject private var placeDetailsManager = PlaceDetailsManager()
    
    private let placeID: String = .eiffelTower
    
    var body: some View {
        VStack(spacing: 0) {
            if let place = placeDetailsManager.place {
                // Photo section
                if let photo = placeDetailsManager.placePhoto {
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                }
                
                // Place details card
                PlaceDetailsCard(place: place, isOpen: placeDetailsManager.isOpen)
            } else {
                ProgressView()
            }
        }
        .task {
            // first, obtain fetch place details
            await placeDetailsManager.fetchPlaceDetails(placeID: placeID)
            
            //check for open status then retrieve photos
            await placeDetailsManager.checkIfOpen(placeID: placeID)
            await placeDetailsManager.fetchFirstPhoto(for: placeID)
        }
        .alert("Error", isPresented: .constant(placeDetailsManager.error != nil)) {
            Button("OK") {
                placeDetailsManager.error = nil
            }
        } message: {
            if let error = placeDetailsManager.error {
                Text(error.localizedDescription)
            }
        }
    }
}
