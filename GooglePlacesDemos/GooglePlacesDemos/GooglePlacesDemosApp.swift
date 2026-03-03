// Copyright 2025 Google LLC. All rights reserved.
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
    
    private var isTestEnvironment: Bool {
        // Check if running in any test environment (unit tests or UI tests)
        NSClassFromString("XCTestCase") != nil ||
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    private func setupGooglePlaces() {
        // Skip API key requirement in test environments
        if isTestEnvironment {
            let _ = PlacesClient.provideAPIKey("TEST_DUMMY_KEY")
            return
        }
        
        guard let apiKey = Bundle.main.infoDictionary?["PLACES_API_KEY"] as? String, !apiKey.isEmpty else {
            fatalError("Add your PLACES_API_KEY to Info.plist - Get one at https://developers.google.com/places/ios-sdk/start#get-key")
        }
        
        let _ = PlacesClient.provideAPIKey(apiKey)
        
        #if DEBUG
        print("Places SDK Licenses:\n\(PlacesClient.openSourceLicenseInfo)")
        #endif
    }
    
    private func setupGoogleMaps() {
        // Skip API key requirement in test environments
        if isTestEnvironment {
            let _ = GMSServices.provideAPIKey("TEST_DUMMY_KEY")
            return
        }
        
        guard let mapKey = Bundle.main.infoDictionary?["MAPS_API_KEY"] as? String, !mapKey.isEmpty else {
            fatalError("Add your MAPS_API_KEY to Info.plist - Get one at https://developers.google.com/maps/documentation/ios-sdk/get-api-key")
        }
        
        let _ = GMSServices.provideAPIKey(mapKey)
    }
}
