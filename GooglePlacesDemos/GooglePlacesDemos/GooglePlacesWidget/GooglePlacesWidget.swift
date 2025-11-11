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

struct GooglePlacesWidget: View {
    @Binding var selectedPlace: Place?
    @Environment(\.dismiss) private var dismiss
    @State private var isPresented = true

    var body: some View {
        Color.clear
            .placeAutocomplete(
                // You can pass a filter, customization, initialQuery, and sessionToken if desired.
                // Using defaults for those here and only binding show.
                show: $isPresented,
                onSelection: { suggestion, sessionToken in
                    // suggestion is AutocompletePlaceSuggestion
                    // sessionToken is AutocompleteSessionToken (if you want to reuse it)
                    Task {
                        let request = FetchPlaceRequest(
                            placeID: suggestion.placeID,
                            placeProperties: [.displayName, .placeID, .coordinate, .formattedAddress]
                        )
                        switch await PlacesClient.shared.fetchPlace(with: request) {
                        case .success(let place):
                            selectedPlace = place
                        case .failure:
                            break
                        }
                        dismiss()
                    }
                },
                onError: { error in
                    // Handle PlacesError if needed
                    // print("Places error: \(error.localizedDescription)")
                    dismiss()
                }
            )
    }
}
