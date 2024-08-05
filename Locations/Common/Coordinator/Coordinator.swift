//
//  Coordinator.swift
//  Locations
//
//  Created by Mohammed Alwaili on 04/08/2024.
//

import Foundation
import UIKit

enum Route: Hashable {
    case deeplink(url: URL)
}

protocol Coordinator: AnyObject {
    func coordinate(route: Route)
}

extension Coordinator {
    
    func coordinate(route: Route) {
        switch route {
        case .deeplink(let url):
            openURL(url)
        }
    }
    
    private func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
