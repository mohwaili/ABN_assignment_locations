//
//  Mocks.swift
//  LocationsTests
//
//  Created by Mohammed Alwaili on 05/08/2024.
//

import Foundation
@testable import Locations

class FetchLocationsServiceMock: FetchLocationsService {
    
    var fetchError: Error?
    var fetchReturnValue: [Location] = []
    func fetch() async throws -> [Location] {
        if let fetchError {
            throw fetchError
        }
        return fetchReturnValue
    }
}

class SearchLocationsServiceMock: SearchLocationsService {
    var searchError: Error?
    var searchReceivedSearchText: String?
    var searchCalled: Bool {
        searchReceivedSearchText != nil
    }
    var searchReturnValue: [Location] = []
    func search(for searchText: String) async throws -> [Location] {
        if let searchError {
            throw searchError
        }
        searchReceivedSearchText = searchText
        return searchReturnValue
    }
}
