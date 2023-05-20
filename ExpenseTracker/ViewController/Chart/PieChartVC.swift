//
//  PieChartVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class PieChartVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataSource: [String : Double] = ["Category 1": 30, "Category 2": 40, "Category 3": 20, "Category 4": 10]
    
    private lazy var hollowPieChart: UIView = {
        let hollowPieChartView = HollowPieChart()
        hollowPieChartView.data = dataSource
        hollowPieChartView.translatesAutoresizingMaskIntoConstraints = false
        hollowPieChartView.backgroundColor = .systemBackground
        return hollowPieChartView
    }()
    
    private lazy var headerViewContainer: UIView = {
        let headerViewContainer = UIView()
        headerViewContainer.translatesAutoresizingMaskIntoConstraints = false
        headerViewContainer.backgroundColor = .systemBackground
        headerViewContainer.layer.cornerRadius = 8
        return headerViewContainer
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .secondarySystemBackground
        return tableView
    }()
    
    private lazy var searchController = SearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        headerViewContainer.addSubview(hollowPieChart)
        view.addSubview(headerViewContainer)
        view.addSubview(tableView)
        setupContraints()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChartCell")
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            hollowPieChart.heightAnchor.constraint(equalToConstant: 200),
            hollowPieChart.widthAnchor.constraint(equalToConstant: 200),
            hollowPieChart.centerYAnchor.constraint(equalTo: headerViewContainer.centerYAnchor),
            hollowPieChart.centerXAnchor.constraint(equalTo: headerViewContainer.centerXAnchor),
            
            headerViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -16),
            headerViewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            headerViewContainer.heightAnchor.constraint(equalToConstant: 200),
            
            tableView.topAnchor.constraint(equalTo: headerViewContainer.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -4),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Chart"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath)
        cell.textLabel?.text = Array(dataSource.keys)[indexPath.row]
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
