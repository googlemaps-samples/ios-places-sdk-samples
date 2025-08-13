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

import GooglePlacesSwift
import GoogleMaps
import SwiftUI

@main
struct GooglePlacesDemosApp: App {
    init() {
        setupGooglePlaces()
        setupGoogleMaps()
    }
    
    var body: some Scene {
        WindowGroup {
           Dialog()
        }
    }
    
    private var isUITestBypassEnabled: Bool {
        ProcessInfo.processInfo.arguments.contains("-UITESTS_NO_API_KEYS") ||
        ProcessInfo.processInfo.environment["UITESTS_NO_API_KEYS"] == "1"
    }

    private func setupGooglePlaces() {
        // Allow UI tests to bypass API key requirement by providing a dummy key
        if isUITestBypassEnabled {
            let _ = PlacesClient.provideAPIKey("UI_TEST_DUMMY_KEY")
            return
        }
        guard let apiKey = Bundle.main.infoDictionary?["PLACES_API_KEY"] as? String else {
            fatalError("Add your PLACES_API_KEY to Info.plist - Get one at https://developers.google.com/places/ios-sdk/start#get-key")
        }
        
        let _ = PlacesClient.provideAPIKey(apiKey)
        
        #if DEBUG
        print("Places SDK Licenses:\n\(PlacesClient.openSourceLicenseInfo)")
        #endif
    }
    
    private func setupGoogleMaps() {
        // Allow UI tests to bypass API key requirement by providing a dummy key
        if isUITestBypassEnabled {
            let _ = GMSServices.provideAPIKey("UI_TEST_DUMMY_KEY")
            return
        }
        guard let mapKey = Bundle.main.infoDictionary?["MAPS_API_KEY"] as? String else {
            fatalError("Add your MAPS_API_KEY to Info.plist - Get one at https://developers.google.com/maps/documentation/ios-sdk/get-api-key")
        }
        
        let _ = GMSServices.provideAPIKey(mapKey)
    }
}
