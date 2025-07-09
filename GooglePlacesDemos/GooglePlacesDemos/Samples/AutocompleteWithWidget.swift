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
import GooglePlaces

struct AutocompleteWithWidget: View {
    @State private var selectedPlace: GMSPlace?
    @State private var showingPlacePicker = false
    @State private var address = ""
    
    var body: some View {
        Form {
            Section {
                HStack {
                    TextField("Search for a place or address", text: $address)
                        .disabled(true)
                    
                    Button(action: {
                        showingPlacePicker = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            // Display selected place details if available
            //TODO: Change this to update a local GMSPlace object
            if let place = selectedPlace {
                Section("Selected Place Details") {
                    Text("Name: \(place.name ?? "N/A")")
                    Text("Address: \(place.formattedAddress ?? "N/A")")
                    Text("Place ID: \(place.placeID ?? "N/A")")
                    Text("Location \(place.coordinate.latitude), \(place.coordinate.longitude)")
                }
            }
        }
        .sheet(isPresented: $showingPlacePicker) {
            GooglePlacesWidget(selectedPlace: $selectedPlace)
                .onDisappear {
                    if let place = selectedPlace {
                        address = place.formattedAddress ?? place.name ?? ""
                    }
                }
        }
    }
}
