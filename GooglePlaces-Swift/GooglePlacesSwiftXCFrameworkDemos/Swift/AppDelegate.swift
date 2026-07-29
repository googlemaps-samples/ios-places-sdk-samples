// Copyright 2020 Google LLC. All rights reserved.
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
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // To use GooglePlacesSwiftXCFrameworkDemos, please register an API Key for your application.
    // Your API Key should be kept private and not be checked in.
    //
    // Create a "Secrets.xcconfig" file next to this app's "Info.plist" and add a line like
    // `PLACES_API_KEY = <insert your API key here>`. It is git-ignored, so your key stays out of
    // version control. (The tracked "GooglePlacesSwiftXCFrameworkDemos.xcconfig" wrapper includes it.)
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
    GMSPlacesClient.provideAPIKey(apiKey)
    GMSPlacesClient.addInternalUsageAttributionID("gmp_git_iosplacesswiftsamples_v1.0.0")
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
