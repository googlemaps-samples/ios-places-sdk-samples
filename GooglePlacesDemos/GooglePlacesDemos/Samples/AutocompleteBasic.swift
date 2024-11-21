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
    @State private var address = ""
    @State private var field_place_id = ""
         
    var body: some View {
        Form {
            Section {
                HStack {
                    TextField("Search for a place or address", text: $address)
                        .focused($isAddressFocused)
                        .onChange(of: address) {
                            manager.fetchPredictions(for: $0)
                            if address == "" {
                                field_place_id = ""
                            }
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
            Section {
                TextField("", text: $field_place_id)
                .disabled(true)
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
                            field_place_id = place.placeID
                        }
                }
            }
        }
        .frame(maxHeight: 300)
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
