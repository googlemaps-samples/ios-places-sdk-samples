# Places Swift SDK for iOS Sample App

## Description

The GooglePlacesDemos folder contains a comprehensive demo application showcasing various features of the [Places Swift SDK for iOS](https://developers.google.com/maps/documentation/places/ios-sdk/google-places-swift). Built with SwiftUI, it demonstrates modern iOS development practices while implementing key Places SDK functionality.

## Features

The demo app includes several sample implementations:
- Address Autocomplete Form with integrated map view
- Place Details Card showing business information, hours, and ratings  
- Places Search with text and nearby location options
- Place Photos integration and management
- Places Autocomplete with custom SwiftUI interface
- Interactive map integration using Google Maps SDK

## Requirements

- Xcode 16.2 or later with iOS SDK 17.0 or later
- iOS Simulator or device running iOS 17+
- An API key from Google Cloud with the [Places API (New)](https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key) enabled
- Swift and SwiftUI knowledge

## Setup

This repository contains six sample apps. All manage the Places API key the same way — you create a
git-ignored `Secrets.xcconfig` next to that app's `Info.plist`; only the folder changes. Each app has
a checked-in `<AppName>.xcconfig` that includes your `Secrets.xcconfig` (`#include? "Secrets.xcconfig"`);
if the key is missing the app still builds but fails at launch with a message naming the file to create.

| App | Open | Create `Secrets.xcconfig` at |
| --- | --- | --- |
| `GooglePlacesDemos` (SwiftUI) | `GooglePlacesDemos/GooglePlacesDemos.xcodeproj` | `GooglePlacesDemos/GooglePlacesDemos/Secrets.xcconfig` |
| `GooglePlacesUIKitDemos` (SwiftUI) | `GooglePlacesUIKitDemos/GooglePlacesUIKitDemos.xcodeproj` | `GooglePlacesUIKitDemos/GooglePlacesUIKitDemos/Secrets.xcconfig` |
| `GooglePlacesSwiftDemos` (UIKit, CocoaPods) | `GooglePlaces-Swift/GooglePlaces-Swift.xcworkspace` | `GooglePlaces-Swift/GooglePlacesSwiftDemos/Secrets.xcconfig` |
| `GooglePlacesSwiftXCFrameworkDemos` (UIKit, CocoaPods) | `GooglePlaces-Swift/GooglePlaces-Swift.xcworkspace` | `GooglePlaces-Swift/GooglePlacesSwiftXCFrameworkDemos/Secrets.xcconfig` |
| `GooglePlacesDemos` (Objective-C, archived) | `Archive/GooglePlaces-Objc/GooglePlaces-Objc.xcworkspace` | `Archive/GooglePlaces-Objc/GooglePlacesDemos/Secrets.xcconfig` |
| `GooglePlacesXCFrameworkDemos` (Objective-C, archived) | `Archive/GooglePlaces-Objc/GooglePlaces-Objc.xcworkspace` | `Archive/GooglePlaces-Objc/GooglePlacesXCFrameworkDemos/Secrets.xcconfig` |

The two `Archive/GooglePlaces-Objc` apps are older Objective-C samples kept for reference.

1. [Set up a Google Cloud project](https://developers.google.com/maps/documentation/places/ios-sdk/cloud-setup) and enable the [Places API (New)](https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key).

2. Clone this repository
   ```
   git clone git@github.com:googlemaps-samples/ios-places-sdk-samples.git
   ```

3. For the CocoaPods samples, install the pods first (this also generates the `.xcworkspace` you open):
   ```
   cd ios-places-sdk-samples/GooglePlaces-Swift && pod install          # GooglePlacesSwiftDemos, GooglePlacesSwiftXCFrameworkDemos
   cd ios-places-sdk-samples/Archive/GooglePlaces-Objc && pod install   # the two archived Obj-C apps
   ```

4. Open the app you want to run in Xcode (see the "Open" column above).

5. Create a `Secrets.xcconfig` file next to that app's `Info.plist` (see the last column above). It is
   git-ignored, so your key is never checked into source control.

6. Add a single line to `Secrets.xcconfig`, substituting your key from Step 1:
   ```
   PLACES_API_KEY = YOUR_PLACES_API_KEY
   ```
   (See https://help.apple.com/xcode/#/dev745c5c974 for more information about xcconfig files.)

## Architecture

- Built with SwiftUI and MVVM design pattern
- Uses `ObservableObject` view models for state management 
- Modular components for reusability

### Key Components

- `PlaceDetailsManager` - Handles place details data fetching and state
- `PlaceDetailsCard` - A reusable SwiftUI view component that displays formatted Place information including:
  - Business name and rating
  - Opening hours and current status
  - Price level and business type
  - Rating stars visualization
  - Support for editorial summary 

## Documentation

- [Places Swift SDK Overview](https://developers.google.com/maps/documentation/places/ios-sdk/google-places-swift)
- [Places Swift SDK Reference](https://developers.google.com/maps/documentation/places/ios-sdk/reference/swift/Classes)
- [Migration Guide](https://developers.google.com/maps/documentation/places/ios-sdk/migrate-places-sdk)

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md).

## Terms of Service

This repository uses Google Maps Platform services. Use of Google Maps Platform services through this library is subject to the Google Maps Platform [Terms of Service](https://cloud.google.com/maps-platform/terms).

**European Economic Area (EEA) developers**

If your billing address is in the European Economic Area, effective on 8 July 2025, the [Google Maps Platform EEA Terms of Service](https://cloud.google.com/terms/maps-platform/eea) will apply to your use of the Services. Functionality varies by region. [Learn more](https://developers.google.com/maps/comms/eea/faq).

This repository is not a Google Maps Platform Core Service. Therefore, the Google Maps Platform Terms of Service (e.g. Technical Support Services, Service Level Agreements, and Deprecation Policy) do not apply to the code in this repository.

## Support

This repository is offered via an open source [license](LICENSE). It is not governed by the Google Maps Platform Support [Technical Support Services Guidelines](https://cloud.google.com/maps-platform/terms/tssg), the [SLA](https://cloud.google.com/maps-platform/terms/sla), or the [Deprecation Policy](https://cloud.google.com/maps-platform/terms) (however, any Google Maps Platform services used by the library remain subject to the Google Maps Platform Terms of Service).

If you find a bug, or have a feature request, please [file an issue](https://github.com/googlemaps-samples/ios-places-sdk-samples/issues) on GitHub. If you would like to get answers to technical questions from other Google Maps Platform developers, ask through one of our [developer community channels](https://developers.google.com/maps/developer-community). If you'd like to contribute, please check the [Contributing guide](CONTRIBUTING.md).

You can also discuss this library on our [Discord server](https://discord.gg/hYsWbmk).