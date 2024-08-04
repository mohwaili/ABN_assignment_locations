//
//  Location.swift
//  Locations
//
//  Created by Mohammed Alwaili on 03/08/2024.
//

import Foundation

struct Location: Decodable {
    let name: String
    let coordinates: Coordinates
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
        case coordinates
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown location"
        self.coordinates = Coordinates(latitude: latitude, longitude: longitude)
    }
}
