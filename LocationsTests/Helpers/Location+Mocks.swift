//
//  Location+Mocks.swift
//  LocationsTests
//
//  Created by Mohammed Alwaili on 05/08/2024.
//

import Foundation
@testable import Locations

extension Location {
    static var amsterdam: Location {
        .init(
            name: "Amsterdam",
            coordinates: .init(
                latitude: 52.3547498,
                longitude: 4.8339215
            )
        )
    }
    
    static var mumbai: Location {
        .init(
            name: "Mumbai",
            coordinates: .init(
                latitude: 19.0823998,
                longitude: 72.8111468
            )
        )
    }
    
    static var unknown: Location {
        .init(
            name: nil,
            coordinates: .init(
                latitude: 40.4380638,
                longitude: -3.7495758
            )
        )
    }
}
