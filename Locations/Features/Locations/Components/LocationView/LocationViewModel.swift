//
//  LocationViewModel.swift
//  Locations
//
//  Created by Mohammed Alwaili on 04/08/2024.
//

import Foundation
import MapKit

struct LocationViewModel: Identifiable {
    
    var id: String {
        "\(coordinates.latitude)-\(coordinates.longitude)"
    }
    
    let name: String
    let coordinates: Coordinates
    
    init(name: String?, coordinates: Coordinates) {
        self.name = name ?? "location_name_unknown".localized()
        self.coordinates = coordinates
    }
}

extension Coordinates {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
}
