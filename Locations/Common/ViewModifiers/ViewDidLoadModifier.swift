//
//  ViewDidLoadModifier.swift
//  Locations
//
//  Created by Mohammed Alwaili on 04/08/2024.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    
    @State private var didLoad = false
    private let task: @Sendable () async -> Void
    
    init(task: @escaping @Sendable () async -> Void) {
        self.task = task
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didLoad {
                    didLoad = true
                    Task {
                        await task()
                    }
                }
            }
    }
}
