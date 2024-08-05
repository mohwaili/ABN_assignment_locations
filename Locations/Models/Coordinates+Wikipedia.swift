//
//  Coordinates+Wikipedia.swift
//  Locations
//
//  Created by Mohammed Alwaili on 04/08/2024.
//

import Foundation

extension Coordinates {
    
    var wikipediaDeeplink: URL? {
        URL(string: "wikipedia://placeWithCoordinates?latitude=\(self.latitude)&longitude=\(self.longitude)")
    }
}
