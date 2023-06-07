////
////  GraphVC.swift
////  ExpenseTracker
////
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit
import Charts
import SwiftUI

class GraphVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var categoryName: String = ""
    
    private lazy var type: Int16 = -1
    
    private lazy var color: Color = .clear
    
    private lazy var graphData = [GraphData]()
    
    private lazy var records = [Record]()
    
    private lazy var graphContainerView: UIView = {
        let graphContainerView = UIView()
        graphContainerView.backgroundColor = .secondarySystemGroupedBackground
        graphContainerView.layer.cornerRadius = 10
        graphContainerView.translatesAutoresizingMaskIntoConstraints = false
        return graphContainerView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
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
        let controller = UIHostingController(rootView: GraphView(graphValues: generateGraphValues(), color: color))
        guard let graphView = controller.view else {
            return
        }
        view.addSubview(graphContainerView)
        graphContainerView.addSubview(graphView)
        view.addSubview(tableView)
        graphView.backgroundColor = .secondarySystemGroupedBackground
        graphView.translatesAutoresizingMaskIntoConstraints = false
        setupContraints()
        NSLayoutConstraint.activate([
            graphView.leadingAnchor.constraint(equalTo: graphContainerView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: graphContainerView.trailingAnchor, constant: -4),
            graphView.bottomAnchor.constraint(equalTo: graphContainerView.bottomAnchor, constant: -4),
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GraphCell")
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            graphContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            graphContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            graphContainerView.heightAnchor.constraint(equalToConstant: 200),
            graphContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.topAnchor.constraint(equalTo: graphContainerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        graphData.first?.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.image =  UIImage(systemName: graphData[indexPath.row].icon)
        configuration.imageProperties.tintColor = .label
        configuration.secondaryText = String(format: "%.2f", graphData[indexPath.row].percentage) + "%"
        configuration.text = Helper.convertDateToString(date: graphData[indexPath.row].date)
        configuration.prefersSideBySideTextAndSecondaryText = true
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        graphData.count
    }
    
    func generateGraphValues() -> [GraphValue] {
        graphData = Helper.getGraphData(records, type: type, category: categoryName)
        lazy var graphValues = [GraphValue]()
        let date = records.first?.date ?? Date()
        let availableDates = Helper.generateDateForgraph(date)
        var dict: [String: [Double]] = [:]
        for data in graphData {
            lazy var percentage = Double(data.percentage)
            if dict[Helper.convertDateToString(date: data.date)] != nil {
                dict[Helper.convertDateToString(date: data.date)]?.append(percentage)
            }
            else {
                dict[Helper.convertDateToString(date: data.date)] = []
                dict[Helper.convertDateToString(date: data.date)]?.append(percentage)
            }
        }
        
        for date in availableDates {
            let dateProperties = Helper.getDateProperties(date: Helper.convertStringToDate(value: date))
            if let percentage = dict[date] {
                let total = percentage.reduce(0, +)
                graphValues.append(GraphValue(percentage: total, date: "\(dateProperties.day)/\(dateProperties.month)"))
            }
            else {
                graphValues.append(GraphValue(percentage: 0, date: "\(dateProperties.day)/\(dateProperties.month)"))
            }
        }
        return graphValues
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Graph"
    }
    
}
