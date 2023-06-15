//
//  ExpensePieChartSearchResultsController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 14/06/23.
//

import UIKit
import SwiftUI

class PieChartSearchResultsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var noDataFoundView: UIView = {
        let noDataFoundView = NoDataFoundView(image: "magnifyingglass", message: "Search results not found")
        return noDataFoundView
    }()
        
    private lazy var type = Int16()
    
    private lazy var searchResults = [ChartData]()
    
    private lazy var records: [Record] = RecordDataManager.shared.getAllRecordForAMonth(month: Helper.defaultMonth, year: Helper.defaultYear)
    
    private lazy var searchText = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PieChartResultCell")
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartResultCell", for: indexPath)
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
        configuration.imageProperties.tintColor = .label
        cell.contentConfiguration = configuration
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func updateSearchResults(searchResults: [ChartData], _ text: String, _ type: Int16) {
        self.searchResults = searchResults
        searchText = text
        self.type = type
        if searchResults.isEmpty {
            tableView.backgroundView = noDataFoundView
        }
        else {
            tableView.backgroundView = nil
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let color = type != 0 ? Color(uiColor: .systemRed) : Color(uiColor: .systemBlue)
        let graphVc = GraphVC(records: records, categoryName: searchResults[indexPath.row].name, type: type, color: color)
        graphVc.hidesBottomBarWhenPushed = true
        graphVc.title = searchResults[indexPath.row].name
        let navigationController = UINavigationController(rootViewController: graphVc)
        present(navigationController, animated: true)
        
    }
    
}
