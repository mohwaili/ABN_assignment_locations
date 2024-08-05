//
//  LocationsIntegrationTests.swift
//  LocationsTests
//
//  Created by Mohammed Alwaili on 05/08/2024.
//

import XCTest
import Combine
@testable import Locations

final class LocationsIntegrationTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() async throws {
        try await super.setUp()
        cancellables = Set()
    }
    
    @MainActor
    func test_onLoad_stateError() async {
        URLProtocolMock.error = NSError(domain: "LocationsIntegrationTests", code: 0)
        let components = makeComponents()
        let expectation = expectation(description: "wait for load")
        expectation.expectedFulfillmentCount = 2
        
        var receivedStates: [LocationsViewModel.State] = []
        components.sut.$state
            .subscribe(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { state in
                receivedStates.append(state)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await components.sut.onLoad()
        
        await fulfillment(of: [expectation], timeout: 5)
        XCTAssertEqual(receivedStates, [
            .loading,
            .error
        ])
    }
    
    @MainActor
    func test_onLoad_stateData() async throws {
        let json = """
        {
            "locations": [
                {
                    "name": "Amsterdam",
                    "lat": 52.3547498,
                    "long": 4.8339215
                },
                {
                    "lat": 40.4380638,
                    "long": -3.7495758
                }
            ]
        }
        """
        let responseData = try XCTUnwrap(json.data(using: .utf8))
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(
                url: URL(string: GitHubAPIConfig.urlString)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, responseData)
        }
        let components = makeComponents()
        let expectation = expectation(description: "wait for load")
        expectation.expectedFulfillmentCount = 2
        
        var receivedStates: [LocationsViewModel.State] = []
        components.sut.$state
            .subscribe(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { state in
                receivedStates.append(state)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await components.sut.onLoad()
        
        await fulfillment(of: [expectation], timeout: 5)
        
        XCTAssertEqual(
            receivedStates,
            [
                .loading,
                .data(
                    locations: [
                        .amsterdam,
                        .init(
                            name: "location_name_unknown".localized(),
                            coordinates: .init(
                                latitude: 40.4380638,
                                longitude: -3.7495758
                            )
                        )
                    ]
                )
            ]
        )
    }
    
    @MainActor
    func test_onTapLocation_showsWikipediaNotInstalledError() async {
        let components = makeComponents(wikipediaAppInstalled: false)
        
        XCTAssertFalse(components.sut.wikipediaNotInstalledErrorShown)
        
        components.sut.onTapLocation(.amsterdam)
        
        XCTAssertTrue(components.sut.wikipediaNotInstalledErrorShown)
        XCTAssertFalse(components.coordinator.coordinateCalled)
    }
    
    @MainActor
    func test_hideWikipediaNotInstalledAlert_hidesError() async {
        let components = makeComponents(wikipediaAppInstalled: false)
        
        XCTAssertFalse(components.sut.wikipediaNotInstalledErrorShown)
        
        components.sut.onTapLocation(.amsterdam)
        
        XCTAssertTrue(components.sut.wikipediaNotInstalledErrorShown)
        
        components.sut.hideWikipediaNotInstalledAlert()
        
        XCTAssertFalse(components.sut.wikipediaNotInstalledErrorShown)
    }
    
    @MainActor
    func test_onTapLocation_opensDeeplink() async {
        let components = makeComponents(wikipediaAppInstalled: true)
        
        components.sut.onTapLocation(.amsterdam)
        
        XCTAssertFalse(components.sut.wikipediaNotInstalledErrorShown)
    }
    
    fileprivate typealias Components = (
        sut: LocationsViewModel,
        coordinator: CoordinatorMock
    )
    
    @MainActor
    fileprivate func makeComponents(wikipediaAppInstalled: Bool = true) -> Components {
        let service = RemoteLocationsService(
            urlSession: makeURLSessionMock(),
            urlString: GitHubAPIConfig.urlString
        )
        let coordinator = CoordinatorMock()
        let sut = LocationsViewModel(
            locationsService: service,
            coordinator: coordinator,
            appInstalledChecker: { _ in wikipediaAppInstalled }
        )
        
        addTeardownBlock { [
            weak service,
            weak coordinator,
            weak sut
        ] in
            XCTAssertNil(service)
            XCTAssertNil(coordinator)
            XCTAssertNil(sut)
        }
        
        return (sut, coordinator)
    }
}

fileprivate extension LocationViewModel {
    static var amsterdam: LocationViewModel {
        .init(
            name: "Amsterdam",
            coordinates: .init(
                latitude: 52.3547498,
                longitude: 4.8339215
            )
        )
    }
}

private class CoordinatorMock: Coordinator {
    
    var coordinateCalled: Bool {
        coordinateReceivedRoute != nil
    }
    var coordinateReceivedRoute: Route?
    func coordinate(route: Route) {
        coordinateReceivedRoute = route
    }
}

extension LocationsViewModel.State: Equatable {
    
    public static func == (
        lhs: LocationsViewModel.State,
        rhs: LocationsViewModel.State
    ) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.error, .error):
            return true
        case (.data(locations: let lhsLocations), .data(locations: let rhsLocations)):
            return lhsLocations == rhsLocations
        default:
            return false
        }
    }
}

extension LocationViewModel: Equatable {
    public static func == (
        lhs: LocationViewModel,
        rhs: LocationViewModel
    ) -> Bool {
        return lhs.name == rhs.name &&
        lhs.coordinates == rhs.coordinates
    }
}

extension Coordinates: Equatable {
    public static func == (
        lhsCoordinates: Coordinates,
        rhsCoordinates: Coordinates
    ) -> Bool {
        return lhsCoordinates.latitude == rhsCoordinates.latitude &&
        lhsCoordinates.longitude == rhsCoordinates.longitude
    }
}
