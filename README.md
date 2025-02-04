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
- API keys from Google Cloud with the following APIs enabled:
  - [Places API (New)](https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key)
  - [Maps SDK for iOS](https://developers.google.com/maps/documentation/ios-sdk/get-api-key)
- Swift and SwiftUI knowledge

## Setup

1. [Set up a Google Cloud project](https://developers.google.com/maps/documentation/places/ios-sdk/cloud-setup) and enable the [Places API (New)](https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key) and [Maps API's](https://developers.google.com/maps/documentation/ios-sdk/get-api-key).

2. Clone this repository
   ```
   git clone git@github.com:googlemaps-samples/ios-places-sdk-samples.git
   ```
3. Change into the `GooglePlacesDemos` folder
   ```
   cd ios-places-sdk-samples/GooglePlacesDemos
   ```
4. Open GooglePlacesDemos.xcodeproj to open the project in Xcode.
   ```
   open GooglePlacesDemos.xcodeproj/
   ```
5. Create a local configuration file for your API key in the same directory (`GooglePlacesDemos/GooglePlacesDemos`) as the demo application's "Info.plist" file. Name the file "GooglePlacesDemos.xcconfig". This will not be checked into source control since `.xcconfig` is on the `.gitignore` list.
6. Add two lines to `GooglePlacesDemos.xcconfig` for setting the values of your API keys. Substitute the "YOUR_PLACES_API_KEY" and "YOUR_MAPS_API_KEY" in the snippet below with the API keys from Step 1.
   ```
   PLACES_API_KEY = "YOUR_PLACES_API_KEY"
   MAPS_API_KEY = "YOUR_MAPS_API_KEY"
   ```
   This should be enough for the demo app to retrieve your key to use for
    requests. (See https://help.apple.com/xcode/#/dev745c5c974 for more
    information about xcconfig files.)

## Architecture

- Built with SwiftUI and MVVM design pattern
- Uses `ObservableObject` view models for state management 
- Custom SwiftUI wrapper for Google Maps integration
- Modular components for reusability

### Key Components

- `PlaceDetailsManager` - Handles place details data fetching and state
- `GoogleMapView` - SwiftUI wrapper for GMSMapView 
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
- [Maps SDK for iOS Documentation](https://developers.google.com/maps/documentation/ios-sdk)

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md).

## Terms of Service

This repository uses Google Maps Platform services. Use of Google Maps Platform services through this library is subject to the Google Maps Platform [Terms of Service](https://cloud.google.com/maps-platform/terms).

This repository is not a Google Maps Platform Core Service. Therefore, the Google Maps Platform Terms of Service (e.g. Technical Support Services, Service Level Agreements, and Deprecation Policy) do not apply to the code in this repository.

## Support

This repository is offered via an open source [license](LICENSE). It is not governed by the Google Maps Platform Support [Technical Support Services Guidelines](https://cloud.google.com/maps-platform/terms/tssg), the [SLA](https://cloud.google.com/maps-platform/terms/sla), or the [Deprecation Policy](https://cloud.google.com/maps-platform/terms) (however, any Google Maps Platform services used by the library remain subject to the Google Maps Platform Terms of Service).

If you find a bug, or have a feature request, please [file an issue](https://github.com/googlemaps-samples/ios-places-sdk-samples/issues) on GitHub. If you would like to get answers to technical questions from other Google Maps Platform developers, ask through one of our [developer community channels](https://developers.google.com/maps/developer-community). If you'd like to contribute, please check the [Contributing guide](CONTRIBUTING.md).

You can also discuss this library on our [Discord server](https://discord.gg/hYsWbmk).