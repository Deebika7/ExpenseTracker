//
//  File.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 06/06/23.
//

import Foundation

struct GraphData: Identifiable {
    var id = UUID()
    
    let percentage: Double
    let name: String
    let date: Date
    let icon: String
    let amount: String
    
    init(percentage: Double, name: String, date: Date, icon: String, amount: String) {
        self.percentage = percentage
        self.name = name
        self.date = date
        self.icon = icon
        self.amount = amount
    }
}
