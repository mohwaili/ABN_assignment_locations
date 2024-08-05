//
//  String+Localized.swift
//  Locations
//
//  Created by Mohammed Alwaili on 04/08/2024.
//

import Foundation

extension String {
    
    func localized() -> String {
        self.localized(arguments: [])
    }
    
    func localized(arguments: any CVarArg...) -> String {
        String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}
