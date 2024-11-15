import SwiftUI
import GooglePlacesSwift

struct PlacesWithAddress: View {
    @StateObject private var manager = PlacesAutocompleteManager()
    @FocusState private var isAddressFocused: Bool
    @State private var address = ""
         
    var body: some View {
        Form {
            Section {
                TextField("Enter a place name or address", text: $address)
                    .focused($isAddressFocused)
                    .outlinedBox()
                    .onChange(of: address) { manager.fetchPredictions(for: $0) }
                
                if isAddressFocused {
                    predictions
                }
            } footer: {
                Text("Places autocomplete provides location-based addresses as users type into an address input field.")
            }
        }
        .scrollContentBackground(.hidden)
        .background(.white)
    }
    
    private var predictions: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(manager.predictions, id: \.self) { suggestion in
                if case .place(let place) = suggestion {
                    PlaceRow(place: place)
                        .onTapGesture {
                            address = place.attributedPrimaryText.plainString()
                            isAddressFocused = false
                        }
                }
            }
        }
        .frame(maxHeight: 300)
    }
}

struct PlaceRow: View {
    let place: AutocompletePlaceSuggestion
    
    var body: some View {
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
    }
}
