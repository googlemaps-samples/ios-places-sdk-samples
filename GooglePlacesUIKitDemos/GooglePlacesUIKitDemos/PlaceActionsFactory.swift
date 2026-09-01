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

/// The action-button configurations the Places UI Kit Pro demos let you switch between.
enum PlaceActionsDemoMode: String, CaseIterable, Identifiable {
  /// Leave the component's built-in actions untouched.
  case defaultActions = "Default"
  /// Hide all main and corner actions.
  case noActions = "None"
  /// Replace the built-in actions with custom ones, including a favorite toggle.
  case customActions = "Custom"

  var id: Self { self }
}

/// Builds custom main and corner actions for the Places UI Kit Pro ("Advanced") components.
///
/// The custom set combines a predefined action (`PlaceActionID.openDirections`) with a
/// fully custom "Save" action that toggles the place in a favorites set owned by the demo.
enum PlaceActionsFactory {

  static func mainActions(
    for place: Place,
    favoritePlaceIDs: Set<String>,
    toggleFavorite: @escaping (String) -> Void
  ) -> [MainPlaceActionElement] {
    guard let placeID = place.placeID else {
      return [.actionId(.openDirections())]
    }
    let isFavorite = favoritePlaceIDs.contains(placeID)
    return [
      .actionId(.openDirections()),
      .action(
        MainPlaceAction(
          image: Image(systemName: isFavorite ? "heart.fill" : "heart"),
          label: isFavorite ? "Saved" : "Save",
          accessibilityLabel: isFavorite ? "Remove from favorites" : "Add to favorites",
          style: .primary,
          onTap: { _ in toggleFavorite(placeID) }
        )
      ),
    ]
  }

  static func cornerActions(
    for place: Place,
    favoritePlaceIDs: Set<String>,
    toggleFavorite: @escaping (String) -> Void
  ) -> [CornerPlaceActionElement] {
    guard let placeID = place.placeID else { return [] }
    let isFavorite = favoritePlaceIDs.contains(placeID)
    return [
      .action(
        CornerPlaceAction(
          image: Image(systemName: isFavorite ? "heart.fill" : "heart"),
          accessibilityLabel: isFavorite ? "Remove from favorites" : "Add to favorites",
          onTap: { _ in toggleFavorite(placeID) }
        )
      ),
    ]
  }
}
