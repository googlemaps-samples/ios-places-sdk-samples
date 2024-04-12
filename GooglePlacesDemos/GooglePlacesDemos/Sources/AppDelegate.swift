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

import GooglePlaces
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else {
      fatalError("Info.plist not found")
    }
    guard let apiKey: String = infoDictionary["API_KEY"] as? String else {
      // To use GooglePlacesDemos, please register an API Key for your application, set it in an
      // xcconfig file, and use that config file for the configuration being built (Debug). Your
      // API Key should be kept private and not be checked in.
      //
      // See documentation on getting an API Key for your API Project here:
      // https://developers.google.com/places/ios-sdk/start#get-key
      fatalError("API_KEY not set in Info.plist")
    }
    GMSPlacesClient.provideAPIKey(apiKey)

    // Log the required open source licenses! Yes, just NSLog-ing them is not enough but is good
    // for a demo.
    print("Google Places open source licenses:\n%@", GMSPlacesClient.openSourceLicenseInfo())
    return true
  }

  func application(
    _ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    let config = UISceneConfiguration(
      name: "Default configuration", sessionRole: connectingSceneSession.role)
    config.delegateClass = SceneDelegate.self
    return config
  }
}
