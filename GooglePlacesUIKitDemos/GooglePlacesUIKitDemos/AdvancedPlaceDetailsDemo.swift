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

/// Demonstrates the Advanced Place Details component, a Places UI Kit Pro component.
///
/// Unlike the compact variant, the full view can show reviews, opening hours, contact
/// details, and feature highlights, and supports searching reviews as well as media.
/// Pro components are billed under their own SKU, separately from the Essentials components:
/// https://developers.google.com/maps/documentation/places/ios-sdk/advanced-place-details-ui-kit
struct AdvancedPlaceDetailsDemo: View {
  @State private var query = PlaceDetailsQuery(
    identifier: .placeID(SamplePlace.presets[0].placeID))
  @State private var actionsMode: PlaceActionsDemoMode = .customActions
  @State private var favoritePlaceIDs: Set<String> = []
  @AccessibilityFocusState private var placePickerFocused: Bool

  // A curated set; use `AdvancedPlaceDetailsView.allContent` to show everything.
  private var configuration: AdvancedPlaceDetailsConfiguration {
    AdvancedPlaceDetailsConfiguration(
      content: [
        .media(), .address(), .rating(), .type(), .reviews(), .summary(),
        .openingHours(), .openNowStatus(), .website(), .phoneNumber(),
        .featureList(), .typeSpecificHighlights(),
      ],
      theme: PlacesMaterialTheme()
    )
  }

  var body: some View {
    // No outer ScrollView here: the full-size details component scrolls its own
    // content and collapses to zero height when nested in a ScrollView.
    VStack(spacing: 12) {
      Text("Advanced Place Details Demo")
        .font(.title2)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)

      Text(
        "A Places UI Kit Pro component showing full place details with reviews and media "
          + "search. Pick a place, then switch between default, no, and custom actions "
          + "with a Save favorite toggle."
      )
      .font(.subheadline)
      .foregroundColor(.secondary)
      .multilineTextAlignment(.center)
      .padding(.horizontal)

      PlacePickerView(query: $query)
        .accessibilityFocused($placePickerFocused)

      Picker("Actions", selection: $actionsMode) {
        ForEach(PlaceActionsDemoMode.allCases) { mode in
          Text(mode.rawValue).tag(mode)
        }
      }
      .pickerStyle(.segmented)

      placeDetailsView
    }
    .padding()
  }

  @ViewBuilder private var placeDetailsView: some View {
    let view = AdvancedPlaceDetailsView(
      orientation: .vertical,
      query: $query,
      configuration: configuration,
      placeDetailsCallback: { result in
        placePickerFocused = true
        if let place = result.place {
          print("Place: \(place.description)")
        } else {
          print("Error: \(String(describing: result.error))")
        }
      }
    )
    .searchMediaOptions(SearchMediaOptions(rankPreference: .mostRelevant)) { results in
      guard let result = results.first else { return }
      switch result {
      case .success(let summary):
        print("Found \(summary.numberOfResults) media items.")
      case .failure(let error):
        print("Failed to search media: \(error)")
      }
    }
    .searchReviewsOptions(SearchReviewsOptions(rankPreference: .mostRelevant)) { results in
      guard let result = results.first else { return }
      switch result {
      case .success(let summary):
        print("Found \(summary.numberOfResults) reviews.")
      case .failure(let error):
        print("Failed to search reviews: \(error)")
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
  AdvancedPlaceDetailsDemo()
}
