//
//  LocationView.swift
//  Locations
//
//  Created by Mohammed Alwaili on 04/08/2024.
//

import SwiftUI
import MapKit

struct LocationView: View {
    
    let viewModel: LocationViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            map
            .frame(maxWidth: .infinity)
            .aspectRatio(3/2, contentMode: .fit)
            VStack(alignment: .leading) {
                locationText
                coordinatesText
            }
            .padding(.horizontal, 16)
        }
        .accessibilityElement()
        .accessibilityLabel(
            Text(
                "a11y_location_item_label".localized()
            )
        )
        .accessibilityValue(
            Text(
                "a11y_location_item_value".localized(
                    arguments: viewModel.name,
                    viewModel.coordinates.latitude.formatted(),
                    viewModel.coordinates.longitude.formatted()
                )
            )
        )
    }
    
    private var coordinates2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: viewModel.coordinates.latitude,
            longitude: viewModel.coordinates.longitude
        )
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinates2D,
            span: MKCoordinateSpan(
                latitudeDelta: 0.05,
                longitudeDelta: 0.05
            )
        )
    }
    
    @ViewBuilder
    private var map: some View {
        if isRunningTests {
            Color.primary
        } else {
            Map(
                position: .constant(.region(region)),
                interactionModes: []
            ) {
                Marker("", coordinate: coordinates2D)
            }
        }
    }
    
    private var locationText: some View {
        Text(String(
            "location_name".localized(arguments: viewModel.name)
        ))
        .font(.headline)
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var coordinatesText: some View {
        Text(
            "location_coordinates".localized(
                arguments: viewModel.coordinates.latitude.formatted(),
                viewModel.coordinates.longitude.formatted()
            )
        )
        .font(.subheadline)
        .foregroundStyle(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

fileprivate let coordinates = Coordinates(
    latitude: 52.3547498,
    longitude: 4.8339215
)

#Preview("light mode") {
    LocationView(
        viewModel: LocationViewModel(
            name: "Amsterdam",
            coordinates: coordinates
        )
    )
        .preferredColorScheme(.light)
}

#Preview("dark mode") {
    LocationView(
        viewModel: LocationViewModel(
            name: "Amsterdam",
            coordinates: coordinates
        )
    )
        .preferredColorScheme(.dark)
}

#Preview("dynamic type size xxxLarge") {
    LocationView(
        viewModel: LocationViewModel(
            name: "Amsterdam",
            coordinates: coordinates
        )
    )
        .dynamicTypeSize(.xxxLarge)
}

#Preview("rtl") {
    LocationView(
        viewModel: LocationViewModel(
            name: "Amsterdam",
            coordinates: coordinates
        )
    )
    .environment(\.layoutDirection, .rightToLeft)
}
