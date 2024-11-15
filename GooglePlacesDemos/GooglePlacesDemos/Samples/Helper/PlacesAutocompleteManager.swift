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


/// PlacesAutocompleteManager handles place autocomplete functionality using the Google Places SDK.
/// The @MainActor attribute ensures all properties and methods run on the main thread,
/// which is essential for UI updates.
@MainActor
class PlacesAutocompleteManager: ObservableObject {
    
    /// Published property that holds the current autocomplete suggestions.
    /// Changes to this property will automatically trigger UI updates in SwiftUI views.
    @Published var predictions: [AutocompleteSuggestion] = []
    
    /// Published property to handle and expose any errors that occur during the autocomplete process.
    /// This allows the UI to react to and display error states.
    @Published var error: Error?
    
    /// Shared instance of PlacesClient for making Places API requests.
    /// This is kept private to encapsulate the implementation details.
    private static var placesClient = PlacesClient.shared
    
    /// Fetches autocomplete predictions based on the user's input query.
    /// This method is called as the user types to provide real-time suggestions.
    /// - Parameter query: The search text entered by the user
    func fetchPredictions(for query: String) {

        guard !query.isEmpty || query != "" else {
            predictions = []
            return
        }
                
        
        // Create an autocomplete request with the user's query
        // Note: sessionToken is set to nil here, but in production apps,
        // you might want to implement session tokens to group related place requests
        let autocompleteRequest = AutocompleteRequest(
            query: query,
            sessionToken: nil
        )
        
        // Create an async task to perform the network request
        Task {
            switch await PlacesClient.shared.fetchAutocompleteSuggestions(with: autocompleteRequest) {
            case .success(let suggestions):
                // Update the predictions property with the new suggestions
                // This will automatically trigger UI updates due to @Published
                self.predictions = suggestions
            case .failure(let placesError):
                // Handle any errors by updating the error property and clearing predictions
                self.error = placesError
                self.predictions = []
            }
        }
    }
}
