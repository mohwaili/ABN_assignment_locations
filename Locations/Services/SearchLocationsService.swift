//
//  SearchLocationsService.swift
//  Locations
//
//  Created by Mohammed Alwaili on 05/08/2024.
//

import Foundation
import CoreLocation

protocol SearchLocationsService {
    func search(for searchText: String) async throws -> [Location]
}

final class GeocoderSearchLocationsService: SearchLocationsService {
    
    private let geocoder = CLGeocoder()
    
    func search(for searchText: String) async throws -> [Location] {
        let placemarks = try await geocoder.geocodeAddressString(searchText)
        return placemarks.compactMap { placemark in
            guard let name = placemark.name,
                  let coordinates = placemark.location?.coordinate else {
                return nil
            }
            return Location(
                name: name,
                coordinates: .init(
                    latitude: coordinates.latitude,
                    longitude: coordinates.longitude
                )
            )
        }
    }
}
