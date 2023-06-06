//
//  ExpenseGraphModel.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 05/06/23.
//

import Foundation
import SwiftUI
import Charts

struct ExpenseGraphData: Identifiable {
    let id =  UUID()
    let amount: Int
    let date: Date
}

struct ExpenseGraph: View {
    
    var graphValues: [ExpenseGraphData]
    var color: Color
    
    init(graphValues: [ExpenseGraphData], color: Color) {
        self.graphValues = graphValues
        self.color = color
    }
    
    var body: some View {
        Chart(graphValues) { expenseGraph in
            AreaMark(
                x: .value("Date", expenseGraph.date),
                y: .value("amount", expenseGraph.amount)
            ).foregroundStyle(LinearGradient(colors: [color,.clear], startPoint: .top, endPoint: .bottom))
            LineMark(
                x: .value("Date", expenseGraph.date),
                y: .value("amount", expenseGraph.amount)
            ).foregroundStyle(color)
            PointMark(
                x: .value("Date", expenseGraph.date),
                y: .value("amount", expenseGraph.amount)
            ).foregroundStyle(color)
        }.chartYAxis {
            AxisMarks(position: .leading)
        }
        
    }
}

