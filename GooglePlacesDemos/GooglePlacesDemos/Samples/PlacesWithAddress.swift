import SwiftUI
import GooglePlacesSwift

struct PlacesWithAddress: View {
    
    @StateObject private var autocompleteManager = PlacesAutocompleteManager()
    @FocusState private var isAddressFocused: Bool
    @FocusState private var isAddressFocused2: Bool
    
    @State private var field_address = ""
    @State private var field_address2 = ""
    @State private var field_city = ""
    @State private var field_state = ""
    @State private var field_zipcode = ""
        
    var body: some View {
        Form {
            Section(header: Text("Places autocomplete provides location-based addresses as users type into an address input field.") .textCase(nil)) {
                TextField("Address", text: $field_address)
                    .focused($isAddressFocused)
                    .outlinedBox()
                
                    .onChange(of: field_address) { query in
                        autocompleteManager.fetchPredictions(for: query)
                    }
                
                if isAddressFocused {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                            ForEach(autocompleteManager.predictions, id: \.self) { suggestion in
                                if case .place(let place) = suggestion {
                                    VStack(alignment: .leading) {
                                        Text(place.attributedPrimaryText)
                                            .font(.subheadline)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        
                                        if let secondaryText = place.attributedSecondaryText {
                                            Text(secondaryText)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                        }
                                    }
                                    .onTapGesture {
                                        print("Selected place ID: \(place.placeID)")
                                        field_address = String(place.attributedPrimaryText.characters) //TODO: we want the actual 1st line address
                                        isAddressFocused = false
                                        isAddressFocused2 = true //set focus to the next field
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: 300)
                   }
                }
                
                TextField("Apt., suite, etc (Optional)", text: $field_address2)
                    .focused($isAddressFocused2)
                    .outlinedBox()
                
            } //end section
        } //end form
    }
}
