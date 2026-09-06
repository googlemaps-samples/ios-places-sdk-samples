// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SwiftUI
import GooglePlacesSwift

@main
struct GooglePlacesUIKitDemosApp: App {
  init() {
    // To use GooglePlacesUIKitDemos, please register an API Key for your application. Your API Key
    // should be kept private and not be checked in.
    //
    // Create a "Secrets.xcconfig" file next to this app's "Info.plist" and add a line like
    // `PLACES_API_KEY = <insert your API key here>`. It is git-ignored, so your key stays out of
    // version control. (The tracked "GooglePlacesUIKitDemos.xcconfig" wrapper includes it.)
    //
    // See documentation on getting an API Key for your API Project here:
    // https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key
    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "PLACES_API_KEY") as? String,
      !apiKey.isEmpty
    else {
      fatalError(
        "Add PLACES_API_KEY to Secrets.xcconfig next to this app's Info.plist. "
          + "Get a key at https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key")
    }
    let _ = PlacesClient.provideAPIKey(apiKey)
    PlacesClient.addInternalUsageAttributionID("gmp_git_iosplacesuikitsamples_v1.0.0")

    // Log the required open source licenses! Yes, just NSLog-ing them is not enough but is good
    // for a demo.
    print("Google Places Swift open source licenses:\n%@", PlacesClient.openSourceLicenseInfo)
  }
    var body: some Scene {
        WindowGroup {
          Text("Google Places UIKit Demos")
          NavigationView {
            List {
              Section("Places UI Kit") {
                NavigationLink(destination: BasicPlaceAutocompleteDemo()) {
                  Text("Basic Place Autocomplete")
                }
                NavigationLink(destination: PlaceAutocompleteDemo()) {
                  Text("Place Autocomplete")
                }
                NavigationLink(destination: PlaceDetailsDemo()) {
                  Text("Place Details")
                }
                NavigationLink(destination: PlaceSearchDemo()) {
                  Text("Place Search")
                }
              }
              Section("Places UI Kit Pro") {
                NavigationLink(destination: AdvancedPlaceDetailsCompactDemo()) {
                  Text("Advanced Place Details (Compact)")
                }
                NavigationLink(destination: AdvancedPlaceDetailsDemo()) {
                  Text("Advanced Place Details")
                }
                NavigationLink(destination: AdvancedPlaceListDemo()) {
                  Text("Advanced Place List")
                }
                NavigationLink(destination: AdvancedPlaceSearchDemo()) {
                  Text("Advanced Place Search")
                }
              }
            }
          }
        }
    }
}
