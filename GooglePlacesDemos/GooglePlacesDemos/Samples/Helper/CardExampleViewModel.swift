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

class CardExampleViewModel: ObservableObject {
    @Published var places: [CardExample] = [
        CardExample(
            name: "Taj Mahal Palace Hotel",
            placeId: "ChIJEaA-2MPiDDkR6C6xllFemnE",
            type: "lodging",
            description: "Historic luxury hotel in Mumbai, India",
            systemIcon: "star.fill"
        ),
        CardExample(
            name: "Gardens by the Bay",
            placeId: "ChIJMxZ-kwQZ2jERdsqftXeWCWI",
            type: "park",
            description: "Nature park in Singapore",
            systemIcon: "star.fill"
        ),
        CardExample(
            name: "Sydney Opera House",
            placeId: "ChIJ3S-JXmauEmsRUcIaWtf4MzE",
            type: "performing_arts_theater",
            description: "Iconic arts venue in Sydney, Australia",
            systemIcon: "star.fill"
        ),
        CardExample(
            name: "Noma",
            placeId: "ChIJpYCQZztTUkYRFOE368Xs6kI",
            type: "restaurant",
            description: "Restaurant in Copenhagen, Denmark",
            systemIcon: "star.fill"
        ),
        CardExample(
            name: "Eiffel Tower",
            placeId: "ChIJLU7jZClu5kcR4PcOOO6p3I0",
            type: "tourist_attraction",
            description: "Iconic iron lattice tower in Paris, France",
            systemIcon: "star.fill"
        ),
        CardExample(
            name: "Central Park",
            placeId: "ChIJ4zGFAZpYwokRGUGph3Mf37k",
            type: "park",
            description: "Urban park in New York City, USA",
            systemIcon: "star.fill"
        ),
        CardExample(
            name: "British Museum",
            placeId: "ChIJB9OTMDIbdkgRp0JWbQGZsS8",
            type: "museum",
            description: "Major public museum in London, UK",
            systemIcon: "star.fill"
        ),
        CardExample(
            name: "Sistine Chapel",
            placeId: "ChIJ268jxWVgLxMRIj61f4fIFqs",
            type: "church",
            description: "Famous chapel in Vatican City",
            systemIcon: "star.fill"
        )
    ]
}
