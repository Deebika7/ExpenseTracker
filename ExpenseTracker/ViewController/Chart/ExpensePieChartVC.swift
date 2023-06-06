//
//  PieChartVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class ExpensePieChartVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataSource = [Double]()
    
    private lazy var records: [Record] = RecordDataManager.shared.getAllRecordForAMonth(month: Helper.defaultMonth, year: Helper.defaultYear)

    private lazy var chartRecords = [ChartData]()

    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        headerViewContainer.addSubview(hollowPieChart)
        view.addSubview(tableView)
        view.addSubview(headerViewContainer)
        setupContraints()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChartCell")
        tableView.keyboardDismissMode = .onDrag
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
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2)
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Expense List"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = chartRecords[indexPath.row].name
        configuration.secondaryText = String(format: "%.2f", chartRecords[indexPath.row].percentage) + "%"
        configuration.prefersSideBySideTextAndSecondaryText = true
        configuration.image = UIImage(systemName: chartRecords[indexPath.row].sfSymbol)
        configuration.imageProperties.tintColor = .label
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let savedYearAndMonth = UserDefaultManager.shared.getUserDefaultObject(for: "selectedDate", SelectedDate.self) {
            records = RecordDataManager.shared.getAllRecordForAMonth(month: savedYearAndMonth.selectedMonth, year: savedYearAndMonth.selectedYear)
            }
        else {
            records = RecordDataManager.shared.getAllRecordForAMonth(month: Helper.defaultMonth, year: Helper.defaultYear)
        }
        chartRecords = Helper.getChartData(records, type: 1)
        dataSource = chartRecords.compactMap {$0.percentage}
        if let hollowPieChartView = hollowPieChart as? HollowPieChart {
            hollowPieChartView.data = dataSource
            hollowPieChartView.setNeedsDisplay()
        }
        tableView.reloadData()
    }
    
}
