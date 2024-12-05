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

struct AutocompleteBasic: View {
    @StateObject private var manager = PlacesAutocompleteManager()
    @FocusState private var isAddressFocused: Bool
    @State private var address = "" //TODO: This is really acting like as the placeName, not the address
    @State private var placeID = ""
    
    // Form fields for address components
    @State private var streetNumber = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var display_address = "" //TODO: Rename to address

          
    var body: some View {
        Form {
            Section {
                HStack {
                    TextField("Search for a place", text: $address)
                        .focused($isAddressFocused)
                        .onChange(of: address) {
                            manager.fetchPredictions(for: $0)
                            if address == "" {
                                self.placeID = ""
                                self.clearAddressFields()
                            }
                        }
                        .onAppear {
                            isAddressFocused = true
                        }
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }
                if (isAddressFocused) && (address != "") {
                    self.predictions
                }
            
            } footer: {
                Text("Places autocomplete displays relevant addresses while you type.")
            }
            
            //additional address fields
            Section {
               TextField("Address", text: $display_address)
               TextField("City", text: $city)
                
                HStack {
                    TextField("State", text: $state)
                    TextField("Zipcode", text: $zipCode)
                }
            }
            
            Section {
                TextField("", text: $placeID)
                
            } footer: {
                Text("The Place ID represents a unique identifer for a selected place. This can be used with additional services such as place details, text search and nearby search.")
            }
        }
    }
    
    private var predictions: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(manager.predictions, id: \.self) { suggestion in
                if case .place(let place) = suggestion {
                    PlaceRow(place: place)
                        .onTapGesture {
                            address = place.attributedPrimaryText.plainString()
                            isAddressFocused = false
                            self.placeID = place.placeID
                            
                            // Fetch and process additional address components
                            Task {
                                await fetchAddressDetails(for: place.placeID)
                            }
                        }
                }
            }
        }
        .frame(maxHeight: 300)
    }

    //reset dependent address fields
    private func clearAddressFields() {
        self.streetNumber = ""
        self.city = ""
        self.state = ""
        self.zipCode = ""
        self.display_address = ""
    }
    
    // Function to fetch and process address details
    private func fetchAddressDetails(for placeID: String) async {
        let placeDetailsManager = PlaceDetailsManager()
        await placeDetailsManager.fetchBasicDetails(placeID: placeID)
        
        if let components = placeDetailsManager.place?.addressComponents {
            print(components)
            processAddressComponents(components)
        }
    }

    func processAddressComponents(_ components: [AddressComponent]) {
        // Clear existing values first
        streetNumber = ""
        city = ""
        state = ""
        zipCode = ""
        
        print("Started processing address components")
        
        for component in components {
            // Check all types for each component
            for type in component.types {
                print("Processing type: \(type) with name: \(component.name)")
                
                switch type {
                case .streetNumber:
                    streetNumber = component.name
                    print("Set street number: \(streetNumber)")
                    
                case .locality:
                    city = component.name
                    print("Set city: \(city)")
                    
                case .route:
                    display_address = "\(streetNumber) \(component.name)"
                    print("Set display address: \(display_address)")
                    
                case .administrativeAreaLevel1:
                    state = component.shortName ?? component.name
                    print("Set state: \(state)")
                    
                case .postalCode:
                    zipCode = component.name
                    print("Set zipcode: \(zipCode)")
                    
                default:
                    break
                }
            }
        }
        
        //TODO: Comment out once verified.
        // Print final values to verify
        print("""
        Final address components:
        Street Number: \(streetNumber)
        City: \(city)
        State: \(state)
        Zip: \(zipCode)
        """)
        
    }
    
}

struct PlaceRow: View {
    let place: AutocompletePlaceSuggestion
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(place.attributedPrimaryText)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
                                    
            if let secondaryText = place.attributedSecondaryText {
                Text(secondaryText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }
}
