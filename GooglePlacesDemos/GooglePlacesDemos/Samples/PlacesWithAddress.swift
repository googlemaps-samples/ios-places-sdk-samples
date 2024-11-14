import SwiftUI
import GooglePlacesSwift

struct PlacesWithAddress: View {
    @StateObject private var autocompleteManager = PlacesAutocompleteManager()
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            TextField("Search places...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onChange(of: searchText) { query in
                    autocompleteManager.fetchPredictions(for: query)
                }
            
            List(autocompleteManager.predictions, id: \.self) { suggestion in
                if case .place(let place) = suggestion {
                    VStack(alignment: .leading) {
                        Text(place.attributedPrimaryText)
                            .font(.headline)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        if let secondaryText = place.attributedSecondaryText {
                            Text(secondaryText)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                    .onTapGesture {
                        print("Selected place ID: \(place.placeID)")
                    }
                }
            }
        }
    }
}
