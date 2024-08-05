//
//  LocationsSnapshotTests.swift
//  LocationsTests
//
//  Created by Mohammed Alwaili on 05/08/2024.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import Locations

final class LocationsSnapshotTests: XCTestCase {
    
    // to re-record the snapshots
//    override func invokeTest() {
//        withSnapshotTesting(record: .all) {
//            super.invokeTest()
//        }
//    }
    
    @MainActor
    func test_errorState() async {
        let view = LocationsView(
            viewModel: await makeViewModel(
                error: NSError(
                    domain: "LocationsSnapshotTests",
                    code: 0
                )
            ),
            mapContentProvider: { _, _ in Color.primary }
        )
        assertSnapshot(
            of: host(view),
            as: .image(
                on: .iPhoneSe
            )
        )
    }
    
    @MainActor
    func test_errorState_darkMode() async {
        let view = LocationsView(
            viewModel: await makeViewModel(
                error: NSError(
                    domain: "LocationsSnapshotTests",
                    code: 0
                )
            ),
            mapContentProvider: { _, _ in Color.primary }
        )
        assertSnapshot(
            of: host(view),
            as: .image(
                on: .iPhoneSe,
                traits: .init(userInterfaceStyle: .dark)
            )
        )
    }
    
    @MainActor
    func test_errorState_extraExtraExtraLarge() async {
        let view = LocationsView(
            viewModel: await makeViewModel(
                error: NSError(
                    domain: "LocationsSnapshotTests",
                    code: 0
                )
            ),
            mapContentProvider: { _, _ in Color.primary }
        )
        assertSnapshot(
            of: host(view),
            as: .image(
                on: .iPhoneSe,
                traits: .init(preferredContentSizeCategory: .extraExtraExtraLarge)
            )
        )
    }
    
    @MainActor
    func test_dataState() async {
        let view = LocationsView(
            viewModel: await makeViewModel(
                locations: [
                    .amsterdam,
                    .mumbai,
                    .unknown
                ]
            ),
            mapContentProvider: { _, _ in Color.primary }
        )
        assertSnapshot(
            of: host(view),
            as: .image(
                on: .iPhoneSe
            )
        )
    }
    
    @MainActor
    func test_dataState_darkMode() async {
        let view = LocationsView(
            viewModel: await makeViewModel(
                locations: [
                    .amsterdam,
                    .mumbai,
                    .unknown
                ]
            ),
            mapContentProvider: { _, _ in Color.primary }
        )
        assertSnapshot(
            of: host(view),
            as: .image(
                on: .iPhoneSe,
                traits: .init(userInterfaceStyle: .dark)
            )
        )
    }
    
    @MainActor
    func test_dataState_extraExtraExtraLarge() async {
        let view = LocationsView(
            viewModel: await makeViewModel(
                locations: [
                    .amsterdam,
                    .mumbai,
                    .unknown
                ]
            ),
            mapContentProvider: { _, _ in Color.primary }
        )
        assertSnapshot(
            of: host(view),
            as: .image(
                on: .iPhoneSe,
                traits: .init(preferredContentSizeCategory: .extraExtraExtraLarge)
            )
        )
    }
    
    @MainActor
    func makeViewModel(
        error: Error? = nil,
        locations: [Location] = []
    ) async -> LocationsViewModel {
        let fetchLocationsServiceMock = FetchLocationsServiceMock()
        fetchLocationsServiceMock.fetchError = error
        fetchLocationsServiceMock.fetchReturnValue = locations
        let service = LocationsService(
            fetchLocationsService: fetchLocationsServiceMock,
            searchLocationsService: SearchLocationsServiceMock()
        )
        let viewModel = LocationsViewModel(
            service: service,
            coordinator: CoordinatorMock(),
            appInstalledChecker: { _ in false }
        )
        await viewModel.onLoad()
        return viewModel
    }
}

fileprivate class CoordinatorMock: Coordinator { }
