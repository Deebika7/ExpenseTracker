//
//  GraphVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit
import Charts
import SwiftUI

class GraphVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    private lazy var categoryName: String = ""
    
    private lazy var type: Int16 = -1
    
    private lazy var color: Color = .clear
    
    private lazy var searchResult = [GroupedGraphData]()
    
    private lazy var graphData = [GroupedGraphData]()
    
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
    
    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGroupedBackground
        return separatorView
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
        view.addSubview(separatorView)
        graphContainerView.addSubview(totalAmountLabel)
        graphContainerView.addSubview(averageAmountLabel)
        graphContainerView.addSubview(monthLabel)
        graphContainerView.addSubview(graphView)
        graphView.backgroundColor = .secondarySystemGroupedBackground
        graphView.translatesAutoresizingMaskIntoConstraints = false
        setupContraints()
        NSLayoutConstraint.activate([
            graphView.leadingAnchor.constraint(equalTo: graphContainerView.leadingAnchor, constant: 28),
            graphView.trailingAnchor.constraint(equalTo: graphContainerView.trailingAnchor, constant: -16),
            graphView.bottomAnchor.constraint(equalTo: graphContainerView.bottomAnchor, constant: -12),
            graphView.heightAnchor.constraint(equalToConstant: 100)
        ])
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderFooterView.reuseIdentifier)
        tableView.register(GraphCell.self, forCellReuseIdentifier: GraphCell.reuseIdentifier)
        tableView.allowsSelection = false
        totalAmount = graphData.reduce(0.0) { result, dataArray in
            return result + dataArray.GraphDataRows.reduce(0.0) { subResult, data in
                return subResult + (Double(data.amount) ?? 0.0)
            }
        }
        let dateProperties = Helper.getDateProperties(date: graphData.first?.Date ?? Date())
        monthLabel.text = "\(Helper.getMonthName(dateProperties.month) ?? "") \(dateProperties.year)"
        let recordType = type == 0  ? RecordType.income.rawValue :  RecordType.expense.rawValue
        var totalAmount = (String(format: "%.2f", totalAmount))
        if Double(totalAmount) ?? 0 > 1 {
            totalAmount = Helper.formatNumber(input: totalAmount)
        }
        else if totalAmount.first == "." {
            totalAmount = "0"+totalAmount
        }
        totalAmountLabel.text = "Total \(recordType): \(totalAmount)"
        averageAmount = self.totalAmount / Double(generateGraphValues().count)
        var averageAmount = (String(format: "%.2f", averageAmount))
        if Double(averageAmount) ?? 0 > 1 {
            averageAmount = Helper.formatNumber(input: averageAmount)
        }
        else if averageAmount.first == "." {
            averageAmount = "0"+averageAmount
        }
        averageAmountLabel.text = "Average daily: \(averageAmount)"
        if presentingViewController != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissGraphVC))
        }
        tableView.keyboardDismissMode = .onDrag
    }
    
    @objc func dismissGraphVC() {
        view.endEditing(true)
                dismiss(animated: true)
    }
                                                                                                                                        
    func setupContraints() {
        NSLayoutConstraint.activate([
            graphContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            graphContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20 ),
            graphContainerView.heightAnchor.constraint(equalToConstant: 220),
            graphContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.topAnchor.constraint(equalTo: graphContainerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            totalAmountLabel.topAnchor.constraint(equalTo: graphContainerView.topAnchor, constant: 20),
            totalAmountLabel.leadingAnchor.constraint(equalTo: graphContainerView.leadingAnchor, constant: 8),
            totalAmountLabel.trailingAnchor.constraint(equalTo: graphContainerView.trailingAnchor),
            totalAmountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            monthLabel.heightAnchor.constraint(equalToConstant: 14),
            monthLabel.centerYAnchor.constraint(equalTo: graphContainerView.centerYAnchor, constant: -30),
            monthLabel.centerXAnchor.constraint(equalTo: graphContainerView.centerXAnchor),
            
            averageAmountLabel.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 4),
            averageAmountLabel.leadingAnchor.constraint(equalTo: graphContainerView.leadingAnchor, constant: 8),
            averageAmountLabel.trailingAnchor.constraint(equalTo: graphContainerView.trailingAnchor, constant: 12),
            averageAmountLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        searchResult.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        54
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderFooterView.reuseIdentifier) as? CustomHeaderFooterView else {
            return UITableViewCell()
        }
        headerView.configureView(with: Helper.convertDateToString(date: graphData[section].Date), bold: false)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GraphCell.reuseIdentifier, for: indexPath) as? GraphCell else {
           return UITableViewCell()
        }
        let graphData = graphData[indexPath.section].GraphDataRows[indexPath.row]
        var amount = graphData.amount
        if Double(amount) ?? 0 > 1 {
            amount = Helper.formatNumber(input: amount)
        }
        else if amount.first == "." {
            amount = "0"+amount
        }
        cell.configure(percentage: String(format: "%.2f", graphData.percentage), amount: String(amount), category: Category(sfSymbolName: graphData.icon, categoryName: graphData.name, color: graphData.color), searchText: searchText)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        graphData[section].GraphDataRows.count
    }
    
    func generateGraphValues() -> [GraphValue] {
        let searchResult = Helper.getGraphData(records, type: type, category: categoryName)
        let graphData = Helper.getGraphData(records, type: type, category: categoryName)
        lazy var graphValues = [GraphValue]()
        
        var graphDataDic: [Date:[GraphData]] = [:]
        for data in graphData {
            if graphDataDic[data.date]  != nil {
                graphDataDic[data.date]?.append(data)
            }
            else {
                graphDataDic[data.date] = []
                graphDataDic[data.date]?.append(data)
            }
        }
        
        let groupedGraphData = graphDataDic.map({
            GroupedGraphData(Date: $0.key, GraphDataRows: $0.value)
        })
        
        for data in 0..<groupedGraphData.count {
            groupedGraphData[data].GraphDataRows.sorted(by: {
                $0.percentage > $1.percentage
            })
        }
        
        self.graphData = groupedGraphData
        self.searchResult = groupedGraphData
                
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }

        searchText = text
        searchResult = []
        
        searchResult = graphData.filter { graphData in
            let filteredRows = graphData.GraphDataRows.filter { data in
                let date = Helper.convertDateToString(date: data.date)
                let percentage = String(format: "%.2f", data.percentage)
                return date.localizedCaseInsensitiveContains(text) ||
                       percentage.localizedCaseInsensitiveContains(text) ||
                       data.amount.localizedCaseInsensitiveContains(text) ||
                       data.name.localizedCaseInsensitiveContains(text)
            }
            return !filteredRows.isEmpty
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
