//
//  PieChartVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class PieChartVC: UITableViewController {
    
    var dataSource: [String : Double] = ["Category 1": 30, "Category 2": 40, "Category 3": 20, "Category 4": 10]
    
    private lazy var hollowPieChart: UIView = {
        let hollowPieChartView = HollowPieChart()
        hollowPieChartView.data = dataSource
        hollowPieChartView.translatesAutoresizingMaskIntoConstraints = false
        hollowPieChartView.backgroundColor = .secondarySystemBackground
        return hollowPieChartView
    }()
    
    private lazy var headerViewContainer: UIView = {
        let headerViewContainer = UIView()
        headerViewContainer.translatesAutoresizingMaskIntoConstraints = false
        headerViewContainer.backgroundColor = .secondarySystemBackground
        return headerViewContainer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = SearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.backgroundColor = .secondarySystemBackground
        headerViewContainer.addSubview(hollowPieChart)
        setupContraints()
        self.tableView.tableHeaderView = headerViewContainer
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChartCell")
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            hollowPieChart.leadingAnchor.constraint(equalTo: headerViewContainer.leadingAnchor, constant: 80),
            hollowPieChart.trailingAnchor.constraint(equalTo: headerViewContainer.trailingAnchor),
            hollowPieChart.heightAnchor.constraint(equalToConstant: 200),
            hollowPieChart.widthAnchor.constraint(equalToConstant: 200)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Chart"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath)
        cell.textLabel?.text = Array(dataSource.keys)[indexPath.row]
        cell.backgroundColor = .systemBackground
        return cell
    }
}
