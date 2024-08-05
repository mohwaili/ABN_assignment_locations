//
//  View+Extensions.swift
//  Locations
//
//  Created by Mohammed Alwaili on 04/08/2024.
//

import SwiftUI

extension View {
    
    func onLoad(_  task: @escaping @Sendable () async -> Void) -> some View {
        modifier(ViewDidLoadModifier(task: task))
    }
}
