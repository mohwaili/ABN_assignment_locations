//
//  RemoteLocationsService.swift
//  Locations
//
//  Created by Mohammed Alwaili on 03/08/2024.
//

import Foundation

protocol LocationsService {
    func fetch() async throws -> [Location]
}

enum RemoteLocationsServiceError: Error {
    case invalidURL
}

final class RemoteLocationsService: LocationsService {
    
    struct Response: Decodable {
        let locations: [Location]
    }
    
    private let urlSession: URLSession
    private let urlString: String
    
    init(urlSession: URLSession,
         urlString: String) {
        self.urlSession = urlSession
        self.urlString = urlString
    }
    
    func fetch() async throws -> [Location] {
        guard let url = URL(string: urlString) else {
            throw RemoteLocationsServiceError.invalidURL
        }
        let (data, _) = try await urlSession.data(from: url)
        let result = try JSONDecoder().decode(Response.self, from: data)
        
        return result.locations
    }
}
