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

/// A well-known place the demos can display without requiring the user to search first.
struct SamplePlace: Identifiable, Hashable {
  let name: String
  let placeID: String

  var id: String { placeID }

  /// Stable, globally recognizable places shared by the Places UI Kit Pro demos.
  static let presets: [SamplePlace] = [
    SamplePlace(name: "Peet's Coffee", placeID: "ChIJT7FdmYiAhYAROFOvrIxRJDU"),
    SamplePlace(name: "Googleplex", placeID: "ChIJj61dQgK6j4AR4GeTYWZsKWw"),
    SamplePlace(name: "Opera House", placeID: "ChIJ3S-JXmauEmsRUcIaWtf4MzE"),
  ]
}

/// A segmented control that points a `PlaceDetailsQuery` binding at one of the preset places.
struct PlacePickerView: View {
  @Binding var query: PlaceDetailsQuery

  @State private var selection: SamplePlace = SamplePlace.presets[0]

  var body: some View {
    Picker("Place", selection: $selection) {
      ForEach(SamplePlace.presets) { place in
        Text(place.name).tag(place)
      }
    }
    .pickerStyle(.segmented)
    .onChange(of: selection) { newSelection in
      query = PlaceDetailsQuery(identifier: .placeID(newSelection.placeID))
    }
  }
}
