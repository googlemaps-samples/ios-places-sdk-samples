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

/// A SwiftUI view that renders a 5-star rating display using SF Symbols.
/// Supports fractional ratings with filled, half-filled, and empty stars.
///
/// - Parameter rating: A Double value between 0 and 5 representing the rating

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
        if Double(index) + 1.0 <= rating {
            return "star.fill"
        } else if Double(index) + 0.5 <= rating {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}
