//
//  LocationsApp.swift
//  Locations
//
//  Created by Mohammed Alwaili on 03/08/2024.
//

import SwiftUI

#if DEBUG
let isRunningTests = CommandLine.arguments.contains(where: { $0 == "isTesting" })
#else
let isRunningTests = false
#endif

@main
struct LocationsApp: App {
    
    @State var path = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            if isRunningTests {
                Text("")
            } else {
                AppCoordinator(path: $path) {
                    LocationsCoordinator().content
                }.content
            }
            
        }
    }
}
