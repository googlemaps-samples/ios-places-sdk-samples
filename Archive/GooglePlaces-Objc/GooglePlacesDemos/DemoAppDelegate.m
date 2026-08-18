/*
 * Copyright 2016 Google LLC. All rights reserved.
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import "GooglePlacesDemos/DemoAppDelegate.h"

#import <GooglePlaces/GooglePlaces.h>
#import "GooglePlacesDemos/DemoSceneDelegate.h"

@implementation DemoAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"Build version: %s", __VERSION__);

  // Read the API key from the app bundle. Create a Secrets.xcconfig next to this app's
  // Info.plist (git-ignored) with `PLACES_API_KEY = <your key>`; the tracked
  // GooglePlacesDemos.xcconfig wrapper includes it. See the top-level README for setup.
  NSString *apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PLACES_API_KEY"];
  if (apiKey.length == 0) {
    @throw [NSException
        exceptionWithName:@"DemoAppDelegate"
                   reason:@"Add PLACES_API_KEY to Secrets.xcconfig next to this app's Info.plist. "
                          @"Get a key at https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key"
                 userInfo:nil];
  }

  // Provide the Places SDK with your API key.
  [GMSPlacesClient provideAPIKey:apiKey];

  // Log the required open source licenses! Yes, just NSLog-ing them is not enough but is good for a
  // demo.
  NSLog(@"Google Places open source licenses:\n%@", [GMSPlacesClient openSourceLicenseInfo]);
  return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application
    configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
                                   options:(UISceneConnectionOptions *)options {
  UISceneConfiguration *configuration =
      [UISceneConfiguration configurationWithName:@"Default Configuration"
                                      sessionRole:connectingSceneSession.role];
  configuration.delegateClass = [DemoSceneDelegate class];
  return configuration;
}

@end
