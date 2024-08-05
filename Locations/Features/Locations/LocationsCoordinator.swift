//
//  LocationsCoordinator.swift
//  Locations
//
//  Created by Mohammed Alwaili on 04/08/2024.
//

import SwiftUI
import MapKit

@MainActor
final class LocationsCoordinator: Coordinator {
    
    var content: some View {
        let viewModel = LocationsViewModel(
            locationsService: RemoteLocationsService(
                urlSession: .shared,
                urlString: GitHubAPIConfig.urlString
            ),
            coordinator: self,
            appInstalledChecker: { scheme in
                if let url = URL(string: scheme) {
                    return  UIApplication.shared.canOpenURL(url)
                }
                return false
            }
        )
        return LocationsView(viewModel: viewModel) { region, coordinates in
            Map(
                position: .constant(.region(region)),
                interactionModes: []
            ) {
                Marker("", coordinate: coordinates)
            }
        }
    }
    
}
