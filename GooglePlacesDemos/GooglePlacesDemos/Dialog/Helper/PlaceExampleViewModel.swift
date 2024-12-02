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

class PlaceExampleViewModel: ObservableObject {
    
    @Published var examples: [PlaceExample] = [
        PlaceExample(
            title: "Autocomplete Address Form",
            description: "Demonstrates Places SDK (New) address autocomplete in a form context",
            destination: AnyView(AutocompleteBasic())
        ),
        PlaceExample(
            title: "Place Details Card",
            description: "Displays detailed place information without photos",
            destination: AnyView(PlaceExampleWithCard())
        ),
        PlaceExample(
            title: "Place Photos",
            description: "Demonstrates loading and displaying place photos",
            destination: AnyView(Text("Place Photos")) // Placeholder
        ),
        PlaceExample(
            title: "Nearby Search",
            description: "Performs location-based nearby place searches with results list",
            destination: AnyView(Text("Nearby Search")) // Placeholder
        ),
        PlaceExample(
            title: "Autocomplete with Controller",
            description: "Shows Places SDK implementation of GMSAutocompleteViewController",
            destination: AnyView(AutocompleteWithWidget())
        )
    ]
}
