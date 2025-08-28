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
import CoreLocation

struct PlaceSearchDemo: View {
  @State private var searchToggle: Bool = true
  @State private var placeTextSearchRequest: PlaceSearchViewRequest = .searchByText(
    SearchByTextRequest(
      textQuery: "Spicy Vegetarian Food",
      placeProperties: [.all],
      locationBias: CircularCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.533481,  longitude: -0.125487),
        radius: 1000)
    )
  )

  @State private var placeSearchNearbyRequest: PlaceSearchViewRequest = .searchNearby(
    SearchNearbyRequest(
      locationRestriction: CircularCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.533481,  longitude: -0.125487),
        radius: 1000),
      placeProperties: [.all],
      includedTypes: [.restaurant, .cafe]
    )
  )

  private let configuration = PlaceSearchConfiguration(
    content: [.address(), .rating(), .media(size: .large)],
      preferTruncation: false,
      theme: PlacesMaterialTheme(),
      attributionPosition: .top,
      selectable: false
  )

  var body: some View {
    VStack {
      if(searchToggle) {
        Text ("Search by Text")
      } else {
        Text ("Search Nearby")
      }

      PlaceSearchView(
        orientation: .vertical,
        request: searchToggle ? $placeTextSearchRequest : $placeSearchNearbyRequest,
        configuration: configuration
      )
      .padding()
      Button("Change Search Type") {
        searchToggle.toggle()
      }
    }
  }
}
