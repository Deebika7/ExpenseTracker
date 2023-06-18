////
////  GraphVC.swift
////  ExpenseTracker
////
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit
import Charts
import SwiftUI

class GraphVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    private lazy var categoryName: String = ""
    
    private lazy var type: Int16 = -1
    
    private lazy var color: Color = .clear
    
    private lazy var searchResult = [GraphData]()
    
    private lazy var graphData = [GraphData]()
    
    private lazy var records = [Record]()
    
    private lazy var totalAmount: Double = 0
    
    private lazy var averageAmount: Double = 0
    
    private lazy var searchText = String()
    
    private lazy var totalAmountLabel: UILabel = {
        let totalAmount = UILabel()
        totalAmount.translatesAutoresizingMaskIntoConstraints = false
        return totalAmount
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private lazy var monthLabel: UILabel = {
        let monthLabel = UILabel()
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        return monthLabel
    }()
    
    private lazy var noDataFoundView: UIView = {
        let noDataFoundView = NoDataFoundView(image: "magnifyingglass", message: "Search results not found")
        return noDataFoundView
    }()
    
    private lazy var averageAmountLabel: UILabel = {
        let averageAmount = UILabel()
        averageAmount.translatesAutoresizingMaskIntoConstraints = false
        averageAmount.font = UIFont.systemFont(ofSize: 14)
        averageAmount.textColor = .secondaryLabel
        return averageAmount
    }()
    
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
        navigationItem.searchController = searchController
        let controller = UIHostingController(rootView: GraphView(graphValues: generateGraphValues(), color: color))
        guard let graphView = controller.view else {
            return
        }
        view.addSubview(graphContainerView)
        view.addSubview(tableView)
        graphContainerView.addSubview(totalAmountLabel)
        graphContainerView.addSubview(averageAmountLabel)
        graphContainerView.addSubview(monthLabel)
        graphContainerView.addSubview(graphView)
        graphView.backgroundColor = .secondarySystemGroupedBackground
        graphView.translatesAutoresizingMaskIntoConstraints = false
        setupContraints()
        NSLayoutConstraint.activate([
            graphView.leadingAnchor.constraint(equalTo: graphContainerView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: graphContainerView.trailingAnchor, constant: -8),
            graphView.bottomAnchor.constraint(equalTo: graphContainerView.bottomAnchor, constant: -4),
        ])
        tableView.register(GraphCell.self, forCellReuseIdentifier: GraphCell.reuseIdentifier)
        tableView.allowsSelection = false
        totalAmount = searchResult.reduce(0) {
            result , data in
            return result + (Double(data.amount) ?? 0)
        }
        let dateProperties = Helper.getDateProperties(date: graphData.first?.date ?? Date())
        monthLabel.text = "\(Helper.getMonthName(dateProperties.month) ?? "") \(dateProperties.year)"
        totalAmountLabel.text = "Total: \(totalAmount)"
        averageAmount = totalAmount / Double(generateGraphValues().count)
        averageAmountLabel.text = "Average daily: \(String(format: "%.2f", averageAmount))"
        if presentingViewController != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissGraphVC))
        }
        tableView.keyboardDismissMode = .onDrag
    }; @objc func dismissGraphVC() {
        view.endEditing(true)
                dismiss(animated: true)
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            totalAmountLabel.topAnchor.constraint(equalTo: graphContainerView.topAnchor, constant: 12),
            totalAmountLabel.leadingAnchor.constraint(equalTo: graphContainerView.leadingAnchor, constant: 4),
            totalAmountLabel.trailingAnchor.constraint(equalTo: graphContainerView.trailingAnchor),
            totalAmountLabel.heightAnchor.constraint(equalToConstant: 14),
            
            monthLabel.heightAnchor.constraint(equalToConstant: 14),
            monthLabel.centerYAnchor.constraint(equalTo: graphContainerView.centerYAnchor, constant: -30),
            monthLabel.centerXAnchor.constraint(equalTo: graphContainerView.centerXAnchor),
            
            averageAmountLabel.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 8),
            averageAmountLabel.leadingAnchor.constraint(equalTo: graphContainerView.leadingAnchor, constant: 4),
            averageAmountLabel.trailingAnchor.constraint(equalTo: graphContainerView.trailingAnchor, constant: 12),
            averageAmountLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GraphCell.reuseIdentifier, for: indexPath) as? GraphCell else {
           return UITableViewCell()
        }
        cell.configure(percentage: String(format: "%.2f", searchResult[indexPath.row].percentage), date: Helper.convertDateToString(date: searchResult[indexPath.row].date), amount: String(searchResult[indexPath.row].amount), searchText: searchText)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResult.count
    }
    
    func generateGraphValues() -> [GraphValue] {
        searchResult = Helper.getGraphData(records, type: type, category: categoryName)
        graphData = Helper.getGraphData(records, type: type, category: categoryName)
        lazy var graphValues = [GraphValue]()
        let date = records.first?.date ?? Date()
        let availableDates = Helper.generateDateForgraph(date)
        var dict: [String: [Double]] = [:]
        for data in searchResult {
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
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        searchText = text
        searchResult = graphData.filter {
            graphData in
            let date = Helper.convertDateToString(date: graphData.date)
            let percentage = String(format: "%.2f", graphData.percentage)
            return date.localizedCaseInsensitiveContains(text) || percentage.localizedCaseInsensitiveContains(text) || graphData.amount.localizedCaseInsensitiveContains(text)
        }
        
        if text.isEmpty {
            searchResult = graphData
        }
        
        if searchResult.isEmpty {
            tableView.backgroundView = noDataFoundView
        }
        else {
            tableView.backgroundView = nil
        }
        tableView.reloadData()
    }
    
}
