//
//  StringExtension.swift
//  ExpenseTrackerFinal
//
//  Created by deebika-pt6680 on 20/06/23.
//

import Foundation

extension String {
    func trimMoreThanOneSpaces() -> String {
        let components = self.components(separatedBy: .whitespaces)
        let filteredComponents = components.filter { !$0.isEmpty }
        return filteredComponents.joined(separator: " ")
    }
}
