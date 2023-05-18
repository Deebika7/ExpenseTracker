//
//  SelectedIndexPath.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 18/05/23.
//

import Foundation

class SelectedIndexPath: Codable {
    
    var selectedIndexPathRow: Int
    
    var selectedIndexPathSection: Int
    
    init(selectedIndexPathRow: Int, selectedIndexPathSection: Int) {
        self.selectedIndexPathRow = selectedIndexPathRow
        self.selectedIndexPathSection = selectedIndexPathSection
    }
    
}
