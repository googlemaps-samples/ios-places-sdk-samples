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
  init(){
    /*
     API Key Setup:
     1. Get an API key using the instructions at: https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key#creating-api-keys
     2. Create a .xcconfig file at the project root level
     3. Add this line: API_KEY = your_api_key_here
     4. Replace "your_api_key_here" with the API key obtained in step 1

     Note: Never commit your actual API key to source control
    */
    guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else {
      fatalError("Info.plist not found")
    }
    guard let apiKey: String = infoDictionary["API_KEY"] as? String else {
      fatalError("API_KEY not set in Info.plist")
    }
    guard apiKey.isEmpty == false else {
      fatalError("API_KEY is empty in Info.plist")
    }
    let _ = PlacesClient.provideAPIKey(apiKey)
  }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
