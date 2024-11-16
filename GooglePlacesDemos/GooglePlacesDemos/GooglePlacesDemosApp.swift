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
import SwiftUI

@main
struct GooglePlacesDemosApp: App {
    init() {
        setupGooglePlaces()
    }
    
    var body: some Scene {
        WindowGroup {
           // AutocompleteBasic()
            AutocompleteWithWidget()
        }
    }
    
    private func setupGooglePlaces() {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            fatalError("Add your API_KEY to Info.plist - Get one at https://developers.google.com/places/ios-sdk/start#get-key")
        }
        
        let _ = PlacesClient.provideAPIKey(apiKey)
        
        #if DEBUG
        print("Places SDK Licenses:\n\(PlacesClient.openSourceLicenseInfo)")
        #endif
    }
}
