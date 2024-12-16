// Copyright 2024 Google LLC. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.

import SwiftUI
import GooglePlacesSwift

struct PlacePhotosView: View {
    let placeId: String
    @StateObject private var placeDetailsManager = PlaceDetailsManager()
    private let photosHeight: CGFloat = 450
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let place = placeDetailsManager.place {

                //Place Details Card
                PlaceDetailsCard(place: place, isOpen: placeDetailsManager.isOpen)
                
                // Editorial summary
                if let summary = place.editorialSummary {
                    Text(summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                
                // Photo Gallery
                if !placeDetailsManager.loadedPhotos.isEmpty {
                    TabView {
                        ForEach(placeDetailsManager.loadedPhotos.indices, id: \.self) { index in
                            VStack {
                                Image(uiImage: placeDetailsManager.loadedPhotos[index])
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.horizontal, 10)
                                Spacer()
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(height: photosHeight)
                } else { //TODO: Is there any way to simplify all of these else clauses in code?
                    if let photos = place.photos, !photos.isEmpty {
                        LoadingView()
                    } else {
                        LoadingView()
                    }
                }
                Spacer()
            } else {
                LoadingView()
            }
        }
        .task {
            await placeDetailsManager.fetchPlaceDetails(placeID: placeId)
            await placeDetailsManager.checkIfOpen(placeID: placeId)
            await placeDetailsManager.fetchPhotosForPlace(placeID: placeId)
        }
    }
}
