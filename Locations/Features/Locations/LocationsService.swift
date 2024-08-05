//
//  LocationsService.swift
//  Locations
//
//  Created by Mohammed Alwaili on 05/08/2024.
//

import Foundation

final class LocationsService {
    
    private var fetchLocations: [Location] = []
    
    private let fetchLocationsService: FetchLocationsService
    private let searchLocationsService: SearchLocationsService
    
    init(
        fetchLocationsService: FetchLocationsService,
        searchLocationsService: SearchLocationsService
    ) {
        self.fetchLocationsService = fetchLocationsService
        self.searchLocationsService = searchLocationsService
    }
    
    func fetchLocations(searchText: String? = nil) async throws -> [Location] {
        guard let searchText else {
            self.fetchLocations = try await fetchLocationsService.fetch()
            return fetchLocations
        }
        if searchText.isEmpty {
            return fetchLocations
        }
        return (try? await searchLocationsService.search(for: searchText)) ?? []
    }
}
