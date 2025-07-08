# Places Swift SDK for iOS sample app

## Description

The GooglePlacesDemos folder contains a demo application showcasing various features of
the [Places Swift SDK for iOS](https://developers.google.com/maps/documentation/places/ios-sdk/google-places-swift).

## Requirements

- Xcode 15.3 or later with the iOS SDK 15.0 or later.
- A Simulator for a device running iOS 15 or later, or an iOS device connected to your computer as a run destination for Xcode.
- An API key from a Google Cloud project with the [Places API (New) enabled](https://developers.google.com/maps/documentation/places/ios-sdk/cloud-setup#enabling-apis). See [Get an API key](https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key) after enabling the API.

## Setup
1. [Set up a Google Cloud project](https://developers.google.com/maps/documentation/places/ios-sdk/cloud-setup) and enable the **Places API (New)**
2. [Get an API key](https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key) from the project
3. Clone this repository
   ```
   git clone git@github.com:googlemaps-samples/ios-places-sdk-samples.git
   ```
5. Change into the `GooglePlacesDemos` folder
   ```
   cd ios-places-sdk-samples/GooglePlacesDemos
   ```
6. Open GooglePlacesDemos.xcodeproj to open the project in Xcode.
   ```
   open  GooglePlacesDemos.xcodeproj/
   ```
7. Create a local configuration file for your API key in the same directory (`GooglePlacesDemos/GooglePlacesDemos`) as the demo application's "Info.plist" file. Name the file "GooglePlacesDemos.xcconfig". This will not be checked into source control since .xcconfig is on the .gitignore list.
8. Add one line to `GooglePlacesDemos.xcconfig` to set the value of your API key. Substitute the "YOUR_API_KEY" in the snippet below with your API key from Step 2.
   ```
   API_KEY = "YOUR_API_KEY"
   ```
   This should be enough for the demo app to retrieve your key to use for
    requests. (See https://help.apple.com/xcode/#/dev745c5c974 for more
    information about xcconfig files.)
9. Run the app. The Swift package for GooglePlacesSwift should automatically 

## Usage

### Sample List

A list of samples is presented at app startup. These samples each demonstrate a
specific capability or capabilities of the SDK. The "Samples" directory contains
most of the actual sample code. Everything else - with the exception of
ParameterConfiguration.swift - is just scaffolding for the sample app to enable easy
display of various samples.

### ParameterConfiguration.swift

The "Configure" button on the startup page allows setting place properties and
autocomplete filter options that allows easy configuration that can apply to
multiple samples. These options are set in ParameterConfiguration.swift which
can be used as a reference for using `PlaceType` and `AutocompleteFilter`.

## Documentation

- [Overview page](https://developers.google.com/maps/documentation/places/ios-sdk/google-places-swift) for the Places Swift SDK for iOS
- [Reference documentation](https://developers.google.com/maps/documentation/places/ios-sdk/reference/swift/Classes)
- [Migration guide](https://developers.google.com/maps/documentation/places/ios-sdk/migrate-places-sdk) for migrating from the Places SDK for iOS

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
   
