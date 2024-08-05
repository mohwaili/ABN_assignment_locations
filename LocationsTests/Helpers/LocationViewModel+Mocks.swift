//
//  LocationViewModel+mocks.swift
//  LocationsTests
//
//  Created by Mohammed Alwaili on 05/08/2024.
//

import Foundation
@testable import Locations

extension LocationViewModel {
    static var amsterdam: LocationViewModel {
        .init(
            name: "Amsterdam",
            coordinates: .init(
                latitude: 52.3547498,
                longitude: 4.8339215
            )
        )
    }
    
    static var mumbai: LocationViewModel {
        .init(
            name: "Mumbai",
            coordinates: .init(
                latitude: 19.0823998,
                longitude: 72.8111468
            )
        )
    }
}
