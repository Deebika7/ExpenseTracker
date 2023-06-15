//
//  ExpenseGraphModel.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 05/06/23.
//

import Foundation
import SwiftUI
import Charts

struct GraphValue: Identifiable {
    let id =  UUID()
    let percentage: Double
    let date: String
}

struct GraphView: View {
    
    var graphValues: [GraphValue]
    var color: Color
    
    init(graphValues: [GraphValue], color: Color) {
        self.graphValues = graphValues
        self.color = color
    }
    
    var body: some View {
        Chart(graphValues) { expenseGraph in
            AreaMark(
                x: .value("Date", expenseGraph.date),
                y: .value("amount", expenseGraph.percentage)
            ).foregroundStyle(LinearGradient(colors: [color,.clear], startPoint: .top, endPoint: .bottom))
            LineMark(
                x: .value("Date", expenseGraph.date),
                y: .value("amount", expenseGraph.percentage)
            ).foregroundStyle(color)
            PointMark(
                x: .value("Date", expenseGraph.date),
                y: .value("amount", expenseGraph.percentage)
            ).foregroundStyle(color)
        }.chartYAxis {
            AxisMarks(position: .leading)
        }.chartYScale(domain: 0...100)
    }
}
