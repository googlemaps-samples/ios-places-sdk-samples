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

import GooglePlacesSwift
import GoogleMaps
import SwiftUI

struct TextSearchView: View {
    @StateObject private var manager = PlaceDetailsManager()
    @FocusState private var isPromptFocused: Bool
    @State private var searchPrompt = ""
    @State private var isLoading = false
    
    // Googleplex (Google HQ) in Mountain View, CA
    private let defaultLocation = CLLocationCoordinate2D(
        latitude: 37.4220,
        longitude: -122.0841
    )
    private let defaultRadius = 5000.0 // 5km radius
    
    private let samplePrompts = [
        "Find me a cozy coffee shop near Google",
        "What's a good Italian restaurant that's open now?",
        "Where's an affordable gym in downtown?",
        "Show me highly rated sushi places under $30"
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Main search input area
            VStack(alignment: .leading, spacing: 16) {
                TextField("How can I help?",
                         text: $searchPrompt,
                         axis: .vertical)
                    .font(.system(size: 40))
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.center)  // Centers the text
                    .focused($isPromptFocused)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 100)
                    .padding(.horizontal)
                    .onChange(of: searchPrompt) { oldValue, newValue in
                        if newValue.isEmpty {
                            manager.textResults = nil  // Clear the results when text is empty
                        }
                    }
                    .onSubmit {
                        if !searchPrompt.isEmpty {
                            performSearch()
                        }
                    }
                
                // Sample prompts in horizontal scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(samplePrompts, id: \.self) { prompt in
                            Button(action: {
                                searchPrompt = prompt
                                performSearch()
                            }) {
                                Text(prompt)
                                    .font(.system(size: 16))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(20)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 24)
            
            Divider()
            
            // Results area
            if isLoading {
                ProgressView()
                    .padding()
            } else if let places = manager.textResults, !places.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(places, id: \.placeID) { place in
                            TextPlaceRow(place: place)
                            
                            if place.placeID != places.last?.placeID {
                                Divider()
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            Spacer()
        }
        .background(Color(uiColor: .systemBackground))
    }

    private func performSearch() {
        isLoading = true
        isPromptFocused = false
        
        Task {
            await manager.searchByText(
                query: searchPrompt,
                location: defaultLocation,
                radius: defaultRadius
            )
            isLoading = false
        }
    }
}

struct TextPlaceRow: View {
    let place: Place
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            // Place name
            Text(place.displayName ?? "")
                .font(.system(size: 18, weight: .medium))
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Rating, reviews and place type
            HStack(spacing: 4) {
                if let rating = place.rating {
                    HStack(spacing: 4) {
                        Text(String(format: "%.1f", rating))
                            .font(.system(size: 16, weight: .medium))
                        
                        // Using the existing RatingStarsView
                        RatingStarsView(rating: Double(rating))
                            .font(.system(size: 14)) // Maintain the desired font size
                                                                        
                        Text("(\(place.numberOfUserRatings))")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
            }
                
            HStack(spacing: 8) {
                if let firstType = place.types.first {
                    Text(firstType.displayString())
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                
                Text("•")
                
                if place.priceLevel != .unspecified {
                    Text(String(repeating: "$", count: place.priceLevel.dollarSignCount()))
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Address
            if let address = place.formattedAddress {
                Text(address)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(uiColor: .systemBackground))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Text Search View") {
  TextSearchView()
}
