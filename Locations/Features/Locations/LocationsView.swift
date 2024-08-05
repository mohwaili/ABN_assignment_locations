//
//  LocationsView.swift
//  Locations
//
//  Created by Mohammed Alwaili on 04/08/2024.
//

import SwiftUI
import MapKit

struct LocationsView<MapContent: View>: View {
    
    @ObservedObject var viewModel: LocationsViewModel
    let mapContentProvider: (MKCoordinateRegion, CLLocationCoordinate2D) -> MapContent
    
    var body: some View {
        content
            .navigationTitle("locations_title".localized())
            .navigationBarTitleDisplayMode(.inline)
            .onLoad {
                await viewModel.onLoad()
            }
        
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .data(locations: let locationViewModels):
            makeLocationsList(from: locationViewModels)
                .alert(
                    "wikipedia_not_installed_alert_title",
                    isPresented: $viewModel.wikipediaNotInstalledErrorShown,
                    actions: {
                        Button {
                            viewModel.hideWikipediaNotInstalledAlert()
                        } label: {
                            Text("common_ok".localized())
                        }

                    }
                )
                .searchable(
                    text: $viewModel.searchText,
                    isPresented: $viewModel.searchIsBeingUsed,
                    prompt: "search_prompt"
                )
        case .error:
            Text("locations_fetch_failed".localized())
        }
    }
    
    func makeLocationsList(from locationViewModels: [LocationViewModel]) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(locationViewModels, id: \.id) { locationViewModel in
                    LocationView(viewModel: locationViewModel, mapContentProvider: {
                        mapContentProvider($0, $1)
                    })
                    .accessibilityAction(named: Text("a11y_location_item_action".localized(arguments: locationViewModel.name)), {
                        viewModel.onTapLocation(locationViewModel)
                    })
                    .onTapGesture {
                        viewModel.onTapLocation(locationViewModel)
                    }
                }
            }
        }
    }
}

#Preview {
    struct PreviewLocationsService: FetchLocationsService {
        func fetch() async throws -> [Location] {
            [
                .init(
                    name: "Amsterdam",
                    coordinates: .init(
                        latitude: 52.3547498,
                        longitude: 4.8339215
                    )
                ),
                .init(
                    name: "Mumbai",
                    coordinates: .init(
                        latitude: 19.0823998,
                        longitude: 72.8111468
                    )
                )
            ]
        }
    }
    class PreviewCoordinator: Coordinator {
        func coordinate(route: Route) { }
    }
    return LocationsView(
        viewModel: LocationsViewModel(
            service: LocationsService(
                fetchLocationsService: PreviewLocationsService(),
                searchLocationsService: GeocoderSearchLocationsService()
            ),
            coordinator: PreviewCoordinator(),
            appInstalledChecker: {
                _ in true
            }
        ),
        mapContentProvider: {
            _, _ in Color.primary
        }
    )
}
