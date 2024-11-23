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


struct PlaceDetailsCard: View {
   let place: Place
   
   var body: some View {
       VStack(alignment: .leading, spacing: 4) {
           Text(place.displayName ?? "")
               .font(.title2)
               .fontWeight(.medium)
           
           HStack(spacing: 4) {
               if let rating = place.rating {
                   Text(String(format: "%.1f", rating))
                       .fontWeight(.medium)
                   RatingStarsView(rating: Double(rating))
                   Text("(\(place.numberOfUserRatings))")
                       .foregroundColor(.secondary)
               }
           }
           
           HStack(spacing: 8) {
               if let types = place.types.first {
                   Text(types.displayString())
               }
               
               Text(String(repeating: "$", count: place.priceLevel.dollarSignCount()))
               
               let estimatedTimeOfArrival: String? = "9 min"
               if let eta = estimatedTimeOfArrival {
                   Text("•")
                   HStack(spacing: 2) {
                       Image(systemName: "car.fill")
                           .imageScale(.small)
                       Text(eta)
                   }
               }
           }
           .foregroundColor(.secondary)
           
           HStack(spacing: 4) {
               Text("Open now")
                   .foregroundColor(.green)
               Text("•")
               Text("Closes 2 PM")
                   .foregroundColor(.secondary)
           }
                      
           HStack(spacing: 16) {
               Text("Dine-in")
               Text("•")
               Text("Takeout")
               Text("•")
               Text("No Delivery")
           }
           .foregroundColor(.secondary)
           .font(.subheadline)
           .padding(.top, 2)
       }
       .padding()
   }
    
    @ViewBuilder
    private func OpeningHoursView(_ openingHours: OpeningHours, isOpen: Bool?) -> some View {
        if let todayHours = openingHours.weekdayText.first {
            HStack(spacing: 4) {
                if let isOpen = isOpen {
                    Text(isOpen ? "Open Now" : "Closed")
                        .foregroundColor(isOpen ? .green : .red)
                    Text("•")
                }
                Text(todayHours)
                    .foregroundColor(.secondary)
            }
        }
    }
    
}

struct RatingStarsView: View {
   let rating: Double
   
   var body: some View {
       HStack(spacing: 2) {
           ForEach(0..<5) { index in
               Image(systemName: starType(for: index))
                   .foregroundColor(.yellow)
           }
       }
   }
   
   private func starType(for index: Int) -> String {
       if Double(index) + 0.5 < rating {
           return "star.fill"
       } else if Double(index) + 0.5 == rating {
           return "star.leadinghalf.filled"
       } else {
           return "star"
       }
   }
}
