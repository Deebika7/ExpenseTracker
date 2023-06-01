//
//  SelectedIndexPath.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 18/05/23.
//

import Foundation

class SelectedDate: Codable {
    
    var selectedYear: Int
    
    var selectedMonth: Int
    
    init(selectedYear: Int, selectedMonth: Int) {
        self.selectedYear = selectedYear
        self.selectedMonth = selectedMonth
    }
    
}
