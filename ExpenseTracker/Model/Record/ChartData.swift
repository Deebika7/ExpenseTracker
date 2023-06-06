//
//  ChartData.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 05/06/23.
//

import Foundation

struct ChartData {
    let percentage: Double
    let sfSymbol: String
    let name: String
    
    init(percentage: Double, sfSymbol: String, name: String) {
        self.percentage = percentage
        self.sfSymbol = sfSymbol
        self.name = name
    }

}
