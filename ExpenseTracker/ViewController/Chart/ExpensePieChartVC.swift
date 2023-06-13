//
//  PieChartVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit
import SwiftUI

class ExpensePieChartVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataSource = [Double: UIColor]()
    
    private lazy var records: [Record] = RecordDataManager.shared.getAllRecordForAMonth(month: Helper.defaultMonth, year: Helper.defaultYear)

    private lazy var chartRecords = [ChartData]()
    
    private lazy var searchResults = [ChartData]()
    
    private lazy var colors = [UIColor]()
    
    private lazy var searchText = String()
    
    private lazy var hollowPieChart: UIView = {
        let hollowPieChartView = HollowPieChart()
        hollowPieChartView.data = dataSource
        hollowPieChartView.translatesAutoresizingMaskIntoConstraints = false
        hollowPieChartView.backgroundColor = .secondarySystemGroupedBackground
        return hollowPieChartView
    }()
    
    private lazy var headerViewContainer: UIView = {
        let headerViewContainer = UIView()
        headerViewContainer.translatesAutoresizingMaskIntoConstraints = false
        headerViewContainer.backgroundColor = .secondarySystemGroupedBackground
        headerViewContainer.layer.cornerRadius = 8
        return headerViewContainer
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        return tableView
    }()
    
    private lazy var searchController = SearchController()
    
    private lazy var noDataFoundView: UIView = {
        let noDataFoundView = NoDataFoundView(image: "menubar.dock.rectangle.badge.record", message: "No records found")
        return noDataFoundView
    }()
    
    func configureTable() {
        if chartRecords.isEmpty {
            headerViewContainer.isHidden = true
        }
        else {
            headerViewContainer.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        headerViewContainer.addSubview(hollowPieChart)
        view.addSubview(noDataFoundView)
        view.addSubview(tableView)
        view.addSubview(headerViewContainer)
        setupContraints()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChartCell")
        tableView.keyboardDismissMode = .onDrag
        configureTable()
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            hollowPieChart.heightAnchor.constraint(equalToConstant: 160),
            hollowPieChart.widthAnchor.constraint(equalToConstant: 160),
            hollowPieChart.centerYAnchor.constraint(equalTo: headerViewContainer.centerYAnchor),
            hollowPieChart.centerXAnchor.constraint(equalTo: headerViewContainer.centerXAnchor),
            
            headerViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -16),
            headerViewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            headerViewContainer.heightAnchor.constraint(equalToConstant: 160),
            
            tableView.topAnchor.constraint(equalTo: headerViewContainer.bottomAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -4),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2),
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  searchResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        searchResults.isEmpty ? "" : "Expense List"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        let category = searchResults[indexPath.row].name
        let attributedText = NSMutableAttributedString(string: category)
        if let range = category.range(of: searchText, options: .caseInsensitive) {
            let nsRange = NSRange(range, in: category)
            attributedText.addAttributes([.foregroundColor: UIColor.systemBlue], range: nsRange)
        }
        configuration.attributedText = attributedText
        let percentage = String(format: "%.2f", searchResults[indexPath.row].percentage) + "%"
        let secondaryAttributedText = NSMutableAttributedString(string: percentage)
        if let range = percentage.range(of: searchText, options: .caseInsensitive) {
            let nsRange = NSRange(range, in: percentage)
            secondaryAttributedText.addAttributes([.foregroundColor: UIColor.systemBlue], range: nsRange)
        }
        configuration.secondaryAttributedText = secondaryAttributedText
        configuration.prefersSideBySideTextAndSecondaryText = true
        configuration.image = UIImage(systemName: searchResults[indexPath.row].sfSymbol)
        configuration.imageProperties.tintColor = searchResults[indexPath.row].color
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let graphVc = GraphVC(records: records, categoryName: searchResults[indexPath.row].name, type: 1, color: Color(uiColor: searchResults[indexPath.row].color))
        graphVc.hidesBottomBarWhenPushed = true
        graphVc.title = searchResults[indexPath.row].name
        navigationController?.pushViewController(graphVc, animated: true)
    }
    
    func configureDataSource() {
        if let savedYearAndMonth = UserDefaultManager.shared.getUserDefaultObject(for: "selectedDateForChart", SelectedDate.self) {
            records = RecordDataManager.shared.getAllRecordForAMonth(month: savedYearAndMonth.selectedMonth, year: savedYearAndMonth.selectedYear)
        }
        else {
            records = RecordDataManager.shared.getAllRecordForAMonth(month: Helper.defaultMonth, year: Helper.defaultYear)
        }
        chartRecords = Helper.getChartData(records, type: 1)
        
        chartRecords = chartRecords.sorted(by: {
            $0.percentage > $1.percentage
        })
        
        dataSource = chartRecords.reduce(into: [Double: UIColor]()){
            result, chartRecord in result[chartRecord.percentage] = chartRecord.color
        }
        searchResults = chartRecords
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureDataSource()
        if let hollowPieChartView = hollowPieChart as? HollowPieChart {
            hollowPieChartView.data = dataSource
            hollowPieChartView.setNeedsDisplay()
        }
        configureTable()
        tableView.reloadData()
    }
    
    func updateSearchResults(_ text: String) {
        configureDataSource()
        searchText = text
        searchResults = chartRecords.filter{ chartData in
            let percentage = String(format: "%.2f", chartData.percentage) + "%"
            return chartData.name.localizedCaseInsensitiveContains(text) || percentage.localizedCaseInsensitiveContains(text)
        }
        if text.isEmpty {
            searchResults = chartRecords
        }
        tableView.reloadData()
    }
    
}
