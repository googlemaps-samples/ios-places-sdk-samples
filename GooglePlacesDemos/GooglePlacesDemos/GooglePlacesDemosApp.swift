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
import SwiftUI

@main
struct GooglePlacesDemosApp: App {
    init() {
        setupGooglePlaces()
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
        
        // Create Secrets.xcconfig next to this app's Info.plist and add
        // `PLACES_API_KEY = <your key>`. It is git-ignored, so the key stays out of version
        // control. See the top-level README for setup instructions.
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "PLACES_API_KEY") as? String,
              !apiKey.isEmpty
        else {
            fatalError(
                "Add PLACES_API_KEY to Secrets.xcconfig next to this app's Info.plist. "
                    + "Get a key at https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key")
        }
        
        let _ = PlacesClient.provideAPIKey(apiKey)
        PlacesClient.addInternalUsageAttributionID("gmp_git_iosplacessamples_v1.0.0")
        #if DEBUG
        print("Places SDK Licenses:\n\(PlacesClient.openSourceLicenseInfo)")
        #endif
    }
}
