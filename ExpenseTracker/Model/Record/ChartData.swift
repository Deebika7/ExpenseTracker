//
//  ChartData.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 05/06/23.
//

import Foundation
import UIKit

struct ChartData {
    let percentage: Double
    let sfSymbol: String
    let name: String
    let color: UIColor
    
    init(percentage: Double, sfSymbol: String, name: String, color: UIColor) {
        self.percentage = percentage
        self.sfSymbol = sfSymbol
        self.name = name
        self.color = color
    }

}
