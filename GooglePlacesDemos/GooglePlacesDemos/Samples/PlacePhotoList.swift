//
//  PlacePhotoList.swift
//  GooglePlacesDemos
//
//  Created by Wayne Bishop on 12/13/24.
//

import SwiftUI

struct PlacePhotoList: View {
    @StateObject private var viewModel = CardExampleViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.places) { place in
                NavigationLink(destination: PlacePhotosView(placeId: place.placeId)) {
                    HStack {
                        /*
                        Image(systemName: place.systemIcon)
                            .foregroundColor(.yellow)
                            .imageScale(.medium)
                        */
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.headline)
                            Text(place.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Place Photos")  //TODO: Can we just remove this and have a regular VStack with a title heading?
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
