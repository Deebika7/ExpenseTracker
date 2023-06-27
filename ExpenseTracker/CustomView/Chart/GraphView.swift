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
    
    @State private var isHidden = true
    @GestureState private var isDragging = false
    @State private var dragOffset: CGSize = .zero
    @State private var currentPercentage: Double = 0
    @State private var currentDate: String = ""
    @State private var labelPosition: CGPoint = .zero
    
    var body: some View {
        return ZStack {
            GeometryReader { geometry in
                Chart(graphValues) { expenseGraph in
                    AreaMark(
                        x: .value("Date", expenseGraph.date),
                        y: .value("amount", expenseGraph.percentage)
                    ).foregroundStyle(LinearGradient(colors: [color, .clear], startPoint: .top, endPoint: .bottom))
                        LineMark(
                            x: .value("Date", expenseGraph.date),
                            y: .value("amount", expenseGraph.percentage)
                        ).foregroundStyle(color)
                    
                    PointMark(
                        x: .value("Date", expenseGraph.date),
                        y: .value("amount", expenseGraph.percentage)
                    ).foregroundStyle(color)
                        .symbolSize(30)
                }.padding(.leading, -29).padding(.trailing, -8)
                    .chartXAxis {
                    }.labelsHidden()
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .chartYScale(domain: 0...100)
                    .gesture(
                        DragGesture()
                            .updating($isDragging) { value, state, _ in
                                state = true
                            }
                            .onChanged { value in
                                let x = value.location.x - dragOffset.width
                                let y = value.location.y - dragOffset.height
                                if let graphValue = graphValue(atX: x, y: y, in: geometry) {
                                    currentPercentage = graphValue.percentage
                                    currentDate = graphValue.date
                                    labelPosition = CGPoint(x: value.location.x, y: value.startLocation.y)
                                    isHidden = false
                                }
                            }
                            .onEnded { value in
                                dragOffset = .zero
                                Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                                    isHidden.toggle()
                                }
                            }
                    )
                    .offset(dragOffset)
                if currentPercentage >= 0 {
                    if isHidden {
                        Path { path in
                            path.move(to: CGPoint(x: labelPosition.x , y: 0))
                            path.addLine(to: CGPoint(x: labelPosition.x, y: 100))
                        }
                        .stroke(color, lineWidth: 2)
                        .animation(.easeIn(duration: 3))
                        .hidden()
                    } else {
                        Path { path in
                            path.move(to: CGPoint(x: labelPosition.x, y: 0))
                            path.addLine(to: CGPoint(x: labelPosition.x, y: 100))
                        }
                        .stroke(color, lineWidth: 2)
                    }
                }
            }.padding(.leading, 8)
            
            VStack {
                if isHidden {
                    let percentage = String(format: "%.2f", currentPercentage)
                    Text("\(percentage)%")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .bold))
                        .hidden()
                    Text("Date: \(currentDate)")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .bold))
                        .hidden()
                } else {
                    let percentage = String(format: "%.2f", currentPercentage)
                    Text("\(percentage)%")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .bold))
                    Text("Date: \(currentDate)")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .bold))
                }
            }
            .background(isHidden ? .clear : color)
            .padding(8)
            .cornerRadius(4)
            .position(x: labelPosition.x, y: -16)
        }
    }
    
    private func graphValue(atX x: CGFloat, y: CGFloat, in geometry: GeometryProxy) -> GraphValue? {
        let chartWidth = geometry.size.width
        let xRatio = x / chartWidth
        let index = Int(xRatio * CGFloat(graphValues.count - 1))
        
        guard index >= 0 && index < graphValues.count else {
            return nil
        }
        return graphValues[index]
    }
}
