//
//  LocationsRTLSnapshotTests.swift
//  LocationsTests
//
//  Created by Mohammed Alwaili on 05/08/2024.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import Locations

final class LocationsRTLSnapshotTests: XCTestCase {
    
//     to re-record the snapshots
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
                on: .iPhoneSe,
                traits: .init(layoutDirection: .rightToLeft)
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
                traits: .init(mutations: { mutableTraits in
                    mutableTraits.userInterfaceStyle = .dark
                    mutableTraits.layoutDirection = .rightToLeft
                })
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
                traits: .init(mutations: { mutableTraits in
                    mutableTraits.preferredContentSizeCategory = .extraExtraExtraLarge
                    mutableTraits.layoutDirection = .rightToLeft
                })
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
                on: .iPhoneSe,
                traits: .init(layoutDirection: .rightToLeft)
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
                traits: .init(mutations: { mutableTraits in
                    mutableTraits.userInterfaceStyle = .dark
                    mutableTraits.layoutDirection = .rightToLeft
                })
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
                traits: .init(mutations: { mutableTraits in
                    mutableTraits.preferredContentSizeCategory = .extraExtraExtraLarge
                    mutableTraits.layoutDirection = .rightToLeft
                })
            )
        )
    }
    
    @MainActor
    func makeViewModel(
        error: Error? = nil,
        locations: [Location] = []
    ) async -> LocationsViewModel {
        let service = LocationsServiceMock()
        service.fetchError = error
        service.fetchReturnValue = locations
        let viewModel = LocationsViewModel(
            locationsService: service,
            coordinator: CoordinatorMock(),
            appInstalledChecker: { _ in false }
        )
        await viewModel.onLoad()
        return viewModel
    }
}

fileprivate class LocationsServiceMock: LocationsService {
    
    var fetchError: Error?
    var fetchReturnValue: [Location] = []
    func fetch() async throws -> [Location] {
        if let fetchError {
            throw fetchError
        }
        return fetchReturnValue
    }
}

fileprivate class CoordinatorMock: Coordinator { }
