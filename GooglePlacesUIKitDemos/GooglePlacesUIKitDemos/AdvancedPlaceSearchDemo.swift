// Copyright 2026 Google LLC
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

/// Demonstrates the Advanced Place Search component, a Places UI Kit Pro component.
///
/// The component runs a text or nearby search and lists the results. Rows are
/// selectable; tapping one presents the place in an Advanced Place Details Compact view.
/// Pro components are billed under their own SKU, separately from the Essentials components:
/// https://developers.google.com/maps/documentation/places/ios-sdk/advanced-place-search-ui-kit
struct AdvancedPlaceSearchDemo: View {
  @State private var searchToggle = true

  // The same London searches as the Essentials `PlaceSearchDemo`, for easy comparison.
  @State private var textSearchRequest: PlaceSearchViewRequest = .searchByText(
    SearchByTextRequest(
      textQuery: "Spicy Vegetarian Food",
      placeProperties: [.all],
      locationBias: CircularCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.533481, longitude: -0.125487),
        radius: 1000)
    )
  )
  @State private var nearbySearchRequest: PlaceSearchViewRequest = .searchNearby(
    SearchNearbyRequest(
      locationRestriction: CircularCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.533481, longitude: -0.125487),
        radius: 1000),
      placeProperties: [.all],
      includedTypes: [.restaurant, .cafe]
    )
  )

  @State private var actionsMode: PlaceActionsDemoMode = .customActions
  @State private var favoritePlaceIDs: Set<String> = []
  @State private var selectedPlaceQuery = PlaceDetailsQuery(identifier: .placeID(""))
  @State private var showDetailsSheet = false

  private var configuration: AdvancedPlaceSearchConfiguration {
    AdvancedPlaceSearchConfiguration(
      content: [.media(), .address(), .rating(), .type(), .openNowStatus()],
      theme: PlacesMaterialTheme(),
      attributionPosition: .top,
      selectable: true
    )
  }

  var body: some View {
    // No outer ScrollView here: the search component scrolls its own results.
    VStack(spacing: 12) {
      Text("Advanced Place Search Demo")
        .font(.title2)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)

      Text(
        "A Places UI Kit Pro component listing search results. Tap a row to open the "
          + "place in an Advanced Place Details Compact view, and use the control to "
          + "switch between default, no, and custom actions."
      )
      .font(.subheadline)
      .foregroundColor(.secondary)
      .multilineTextAlignment(.center)
      .padding(.horizontal)

      HStack {
        Text(searchToggle ? "Text Search" : "Nearby Search")
          .font(.subheadline)
          .fontWeight(.semibold)
        Spacer()
        Button("Change Search Type") {
          searchToggle.toggle()
        }
      }

      Picker("Actions", selection: $actionsMode) {
        ForEach(PlaceActionsDemoMode.allCases) { mode in
          Text(mode.rawValue).tag(mode)
        }
      }
      .pickerStyle(.segmented)

      placeSearchView
    }
    .padding()
    .sheet(isPresented: $showDetailsSheet) {
      NavigationStack {
        AdvancedPlaceDetailsCompactView(
          orientation: .vertical,
          query: $selectedPlaceQuery,
          configuration: AdvancedPlaceDetailsCompactConfiguration(
            content: [.media(), .address(), .rating(), .type(), .openNowStatus()],
            theme: PlacesMaterialTheme()
          ),
          placeDetailsCallback: { result in
            if let place = result.place {
              print("Sheet place: \(place.description)")
            } else {
              print("Sheet error: \(String(describing: result.error))")
            }
          }
        )
        .navigationTitle("Place Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Done") {
              showDetailsSheet = false
            }
          }
        }
      }
    }
  }

  @ViewBuilder private var placeSearchView: some View {
    let view = AdvancedPlaceSearchView(
      orientation: .vertical,
      request: searchToggle ? $textSearchRequest : $nearbySearchRequest,
      configuration: configuration
    )
    .onLoad { places in
      print("Loaded \(places.count) search results.")
    }
    .onRequestError { error in
      print("Search request failed: \(error)")
    }
    .onPlaceSelected { place in
      guard let placeID = place.placeID else { return }
      selectedPlaceQuery = PlaceDetailsQuery(identifier: .placeID(placeID))
      showDetailsSheet = true
      print("Selected: \(place.description)")
    }
    .searchMediaOptions(SearchMediaOptions(rankPreference: .mostRelevant)) { results in
      for result in results {
        if case .success(let summary) = result {
          print("Found \(summary.numberOfResults) media items.")
        } else if case .failure(let error) = result {
          print("Failed to search media: \(error)")
        }
      }
    }

    switch actionsMode {
    case .defaultActions:
      view
    case .noActions:
      view
        .mainActions { _ in [] }
        .cornerActions { _ in [] }
    case .customActions:
      view
        .mainActions { place in
          PlaceActionsFactory.mainActions(
            for: place,
            favoritePlaceIDs: favoritePlaceIDs,
            toggleFavorite: toggleFavorite
          )
        }
        .cornerActions { place in
          PlaceActionsFactory.cornerActions(
            for: place,
            favoritePlaceIDs: favoritePlaceIDs,
            toggleFavorite: toggleFavorite
          )
        }
    }
  }

  private func toggleFavorite(_ placeID: String) {
    if favoritePlaceIDs.contains(placeID) {
      favoritePlaceIDs.remove(placeID)
      print("Removed \(placeID) from favorites.")
    } else {
      favoritePlaceIDs.insert(placeID)
      print("Added \(placeID) to favorites.")
    }
  }
}

#Preview {
  AdvancedPlaceSearchDemo()
}
