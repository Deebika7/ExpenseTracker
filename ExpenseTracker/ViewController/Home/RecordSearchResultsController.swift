//
//  RecordSearchResultsController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 01/06/23.
//

import Foundation
import UIKit

class RecordSearchResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var searchResults = [SectionData]()
    
    private lazy var searchText = String()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .insetGrouped)
        return tableView
    }()
    
    private lazy var noDataFoundView: UIView = {
        let noDataFoundView = NoDataFoundView(image: "magnifyingglass", message: "Search results not found")
        return noDataFoundView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecordSearchResults")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
    }
    
    func updateSearchResults(_ results: [SectionData], searchText: String) {
        searchResults = results
        self.searchText =  searchText
        if searchResults.isEmpty {
            tableView.backgroundView = noDataFoundView
        }
        else {
            tableView.backgroundView = nil
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults[section].rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Helper.convertDateToString(date: searchResults[section].date)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordSearchResults", for: indexPath)
        let record = searchResults[indexPath.section].rows[indexPath.row]
        var configuration = cell.defaultContentConfiguration()
        let simplifiedAmount = Helper.simplifyNumbers([record.amount ?? "0"])
        configuration.secondaryText = (record.type == 0) ? "\(simplifiedAmount)" : "-\(simplifiedAmount)"
        configuration.prefersSideBySideTextAndSecondaryText = true
        configuration.image = UIImage(systemName: record.icon ?? "")
        let category = record.category ?? ""
        let attributedString = NSMutableAttributedString(string: category)
        if let range = category.range(of: searchText, options: .caseInsensitive) {
            let nsRange = NSRange(range, in: category)
            attributedString.addAttributes([.foregroundColor: UIColor.systemBlue], range: nsRange)
        }
            configuration.attributedText = attributedString
        
        configuration.imageProperties.tintColor = .label
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
                                                                        
}

