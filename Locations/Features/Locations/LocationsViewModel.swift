//
//  LocationsViewModel.swift
//  Locations
//
//  Created by Mohammed Alwaili on 04/08/2024.
//

import Foundation
import Combine

@MainActor
final class LocationsViewModel: ObservableObject {
    
    enum State {
        case loading
        case data(locations: [LocationViewModel])
        case error
    }
    
    typealias Scheme = String
    
    private let service: LocationsService
    private let coordinator: Coordinator
    private let appInstalledChecker: (Scheme) -> Bool
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    @Published private(set) var state = State.loading
    @Published var wikipediaNotInstalledErrorShown: Bool = false
    @Published var searchText: String = ""
    @Published var searchIsBeingUsed = false
    
    init(
        service: LocationsService,
        coordinator: Coordinator,
        appInstalledChecker: @escaping (Scheme) -> Bool
    ) {
        self.service = service
        self.coordinator = coordinator
        self.appInstalledChecker = appInstalledChecker
        
        $searchText
            .dropFirst()
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .asyncMap({ [weak service] text in
                return (try? await service?.fetchLocations(searchText: text)) ?? []
            })
            .subscribe(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] locations in
                self?.state = .data(locations: locations.map { $0.toViewModel() })
            })
            .store(in: &cancellables)
    }
    
    func onLoad() async {
        state = .loading
        do {
            let locations = try await service.fetchLocations()
            state = .data(locations: locations.map { $0.toViewModel() })
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

private extension Location {
    
    func toViewModel() -> LocationViewModel {
        .init(
            name: self.name,
            coordinates: .init(
                latitude: self.coordinates.latitude,
                longitude: self.coordinates.longitude
            )
        )
    }
}
