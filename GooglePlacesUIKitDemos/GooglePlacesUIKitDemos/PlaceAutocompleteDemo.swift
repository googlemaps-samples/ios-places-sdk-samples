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

struct PlaceAutocompleteDemo: View {
  @State private var text: String = "No results to display."
  @State private var fetchedPlace: Place?
  @State private var placesError: PlacesError?
  @State private var showAutocomplete: Bool = false
  @State private var selectedPlace: AutocompletePlaceSuggestion?
  @State private var selectedPlaceQuery: PlaceDetailsQuery = .init( identifier: .placeID(""))

  // State to control the presentation of the details sheet.
  @State private var showDetailsSheet = false


  var body: some View {
    let types: Set<PlaceType> = [.bakery, .cafe, .restaurant]
    let countries: Set<String> = ["US"]
    let origin = CLLocation(latitude: 36.19030535579595, longitude: -115.25397680618019)
    let coordinateRegion = RectangularCoordinateRegion(
      northEast: CLLocationCoordinate2D(
        latitude: 36.25290087640495, longitude: -115.08025549571225),
      southWest: CLLocationCoordinate2D(latitude: 36.06607422287787, longitude: -115.33431432920293)
    )
    let regionCode = "US"

    let filter = AutocompleteFilter(
      types: types,
      countries: countries,
      origin: origin,
      coordinateRegionBias: coordinateRegion,
      regionCode: regionCode)
    let uiCustomization = AutocompleteUICustomization(
      listDensity: .multiLine,
      listItemIcon: .noIcon)

    VStack {
      Image(systemName: "building.2.crop.circle.fill")
          .font(.system(size: 60))
          .foregroundColor(.blue)

      Text("Places UI Kit Place Autocomplete Demo")
          .font(.title)
          .fontWeight(.bold)

      Text("Tap the button to search. The selected result will be displayed using the official `PlaceDetailsCompactView` component.")
          .font(.subheadline)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal)

      // Button to trigger the autocomplete search.
      Button {
          showAutocomplete.toggle()
      } label: {
          HStack {
              Image(systemName: "magnifyingglass")
              Text("Search for a Place")
          }
      }
      .buttonStyle(.borderedProminent)
      .padding()

        if let placesError = $placesError.wrappedValue {
          Text(placesError.localizedDescription)
            .frame(maxWidth: .infinity, alignment: .leading)
        } else if let fetchedPlace = $fetchedPlace.wrappedValue {
          Text(String(describing: fetchedPlace))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    .placeAutocomplete(
      filter: filter,
      uiCustomization: uiCustomization,
      show: $showAutocomplete,
      onSelection: { placeSuggestion, sessionToken in
        let placeID = placeSuggestion.placeID
        self.selectedPlace = placeSuggestion
        self.selectedPlaceQuery = .init(identifier: .placeID(placeID))


        // Once we have a query, command the sheet to appear.
        self.showDetailsSheet = true
        print("Place ID: \(placeID)")
      },
      onError: { placesError in
        self.placesError = placesError
      })
    .sheet(isPresented: $showDetailsSheet) {

      NavigationStack {
        PlaceDetailsCompactView(
          orientation: .vertical,
          query: $selectedPlaceQuery,
          configuration: PlaceDetailsCompactConfiguration(
            content: [.address(), .rating(), .type(), .media()],
            theme: PlacesMaterialTheme()
          ),
          placeDetailsCallback: { placeDetails in
            if let place = placeDetails.place {
              print("Place: \(place.description)")
            } else {
              print("Error: \(String(describing: placeDetails.error))")
              self.placesError = .internal("Failed to fetch place details.")
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
        .frame(width: 300, height: 350, alignment: .center)
      }
      
    }

  }
}
