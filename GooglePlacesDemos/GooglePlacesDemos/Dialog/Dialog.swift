// Copyright 2025 Google LLC. All rights reserved.
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

struct Dialog: View {
    
    @StateObject private var placeDetailsManager = PlaceDetailsManager()
    private var viewModel = PlaceExampleViewModel()
    @StateObject private var configuration = ParameterConfiguration()
    private let placeID: String = .spaceNeedle
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // Top half - Place Photo and Details
                VStack(spacing: 0) {
                    if let place = placeDetailsManager.place {
                        if let photo = placeDetailsManager.placePhoto {
                            Image(uiImage: photo)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: UIScreen.main.bounds.height * 0.3)
                                .clipped()
                                .frame(maxWidth: .infinity)
                        }
                        
                        PlaceDetailsCard(place: place, isOpen: placeDetailsManager.isOpen)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        ProgressView()
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.5)
                
                // Bottom half - Examples List
                List(viewModel.examples) { example in
                    NavigationLink(destination: example.destination) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(example.title)
                                .font(.headline)
                            Text(example.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Google Places (New) Samples")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink("Configure") {
                    ConfigurationView(configuration: configuration)
                }
            }
        }
        .task {
            await placeDetailsManager.fetchPlaceDetails(placeID: placeID)
            await placeDetailsManager.checkIfOpen(placeID: placeID)
            await placeDetailsManager.fetchFirstPhoto(for: placeID)
        }
        .alert("Error", isPresented: .constant(placeDetailsManager.error != nil)) {
            Button("OK") {
                placeDetailsManager.error = nil
            }
        } message: {
            if let error = placeDetailsManager.error {
                Text(error.localizedDescription)
            }
        }
    }
}
