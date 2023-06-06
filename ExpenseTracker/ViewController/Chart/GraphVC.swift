////
////  GraphVC.swift
////  ExpenseTracker
////
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit
import Charts
import SwiftUI

class GraphVC: UIViewController {
    
    private lazy var categoryName: String = ""
    
    private lazy var type: Int16 = -1
    
    private lazy var color: Color = .clear
    
    private lazy var graphData = [GraphData]()
    
    private lazy var records = [Record]()
    
    convenience init(records: [Record], categoryName: String, type: Int16, color: Color){
        self.init()
        self.records = records
        self.categoryName = categoryName
        self.type = type
        self.color = color
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        let controller = UIHostingController(rootView: GraphView(graphValues: graphValues, color: color))
        guard let expenseGraph = controller.view else {
            return
        }
        view.addSubview(expenseGraph)
        expenseGraph.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expenseGraph.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expenseGraph.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expenseGraph.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func generateGraphValues() -> [GraphData] {
        graphData = Helper.getGraphData(records, type: type, category: categoryName)
        lazy var graphValues: [GraphValue] = []
        let date = Helper.convertDateToString(date: records.first?.date ?? Date())
        let availableDates = Helper.generateDateForgraph(date)
        for date in availableDates {
            
        }
        for data in graphData {
            lazy var percentage = Double(data.percentage)
            graphValues.append(GraphValue(percentage: Double(String(format: "%.2f", percentage )) ?? 0, date: Helper.convertDateToString(date: data.date) ))
        }
    }
    
}
