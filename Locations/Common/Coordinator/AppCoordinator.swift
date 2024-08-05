//
//  AppCoordinator.swift
//  Locations
//
//  Created by Mohammed Alwaili on 04/08/2024.
//

import SwiftUI

final class AppCoordinator<ContentView: View>: Coordinator {
    
    @Binding var path: NavigationPath
    
    private let contentView: () -> ContentView
    
    init(path: Binding<NavigationPath>,
         contentView: @escaping () -> ContentView) {
        _path = path
        self.contentView = contentView
    }
    
    var content: some View {
        NavigationStack(path: $path) {
            contentView()
        }
    }
}
