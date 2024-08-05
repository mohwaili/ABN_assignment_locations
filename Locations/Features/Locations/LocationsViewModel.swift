//
//  LocationsViewModel.swift
//  Locations
//
//  Created by Mohammed Alwaili on 04/08/2024.
//

import Foundation

@MainActor
final class LocationsViewModel: ObservableObject {
    
    enum State {
        case loading
        case data(locations: [LocationViewModel])
        case error
    }
    
    typealias Scheme = String
    
    private let locationsService: LocationsService
    private let coordinator: Coordinator
    private let appInstalledChecker: (Scheme) -> Bool
    
    @Published private(set) var state = State.loading
    @Published var wikipediaNotInstalledErrorShown: Bool = false
    
    init(
        locationsService: LocationsService,
        coordinator: Coordinator,
        appInstalledChecker: @escaping (Scheme) -> Bool
    ) {
        self.locationsService = locationsService
        self.coordinator = coordinator
        self.appInstalledChecker = appInstalledChecker
    }
    
    func onLoad() async {
        state = .loading
        do {
            let viewModels = try await locationsService.fetch().map {
                LocationViewModel(name: $0.name, coordinates: $0.coordinates)
            }
            state = .data(locations: viewModels)
        } catch {
            state = .error
        }
    }
    
    func onTapLocation(_ viewModel: LocationViewModel) {
        guard appInstalledChecker("wikipedia://") else {
            wikipediaNotInstalledErrorShown = true
            return
        }
        guard let url = viewModel.coordinates.wikipediaDeeplink else {
            return
        }
        coordinator.coordinate(route: .deeplink(url: url))
    }
    
    func hideWikipediaNotInstalledAlert() {
        wikipediaNotInstalledErrorShown = false
    }
}
