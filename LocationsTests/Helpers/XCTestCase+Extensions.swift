//
//  XCTestCase+Extensions.swift
//  LocationsTests
//
//  Created by Mohammed Alwaili on 05/08/2024.
//

import XCTest
import SwiftUI
import UIKit
import SnapshotTesting

extension XCTestCase {
    
    func host<V: View>(_ view: V) -> UIViewController {
        UIHostingController(rootView: view)
    }
}
