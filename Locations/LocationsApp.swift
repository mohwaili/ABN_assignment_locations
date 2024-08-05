//
//  LocationsApp.swift
//  Locations
//
//  Created by Mohammed Alwaili on 03/08/2024.
//

import SwiftUI

@main
struct LocationsApp: App {
    
    @State var path = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            if CommandLine.arguments.contains(where: { $0 == "isTesting"}) {
                Text("")
            } else {
                AppCoordinator(path: $path) {
                    LocationsCoordinator().content
                }.content
            }
            
        }
    }
}
