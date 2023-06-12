//
//  RecordSearchResultsController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 01/06/23.
//

import Foundation
import UIKit

class RecordSearchResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var searchResults = [Date:[Record]]()
    private lazy var searchText = String()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecordSearchResults")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
    }
    
    func updateSearchResults(_ results: [Date:[Record]], searchText: String) {
        searchResults = results
        self.searchText =  searchText
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let recordItem = Array(searchResults.keys)[section]
        return searchResults[recordItem]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Helper.convertDateToString(date: Array(searchResults.keys)[section])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordSearchResults", for: indexPath)
        let record = Array(searchResults.keys)[indexPath.section]
        var configuration = cell.defaultContentConfiguration()
        if let recordItems = searchResults[record] {
            let simplifiedAmount = Helper.simplifyNumbers([recordItems[indexPath.row].amount!], 3)
            configuration.secondaryText = (recordItems[indexPath.row].type == 0) ? "\(simplifiedAmount)" : "-\(simplifiedAmount)"
            configuration.prefersSideBySideTextAndSecondaryText = true
            configuration.image = UIImage(systemName: recordItems[indexPath.row].icon!)
            let category = recordItems[indexPath.row].category ?? ""
            let attributedString = NSMutableAttributedString(string: category)
            if let range = category.range(of: searchText, options: .caseInsensitive) {
                let nsRange = NSRange(range, in: category)
                attributedString.addAttributes([.foregroundColor: UIColor.systemBlue], range: nsRange)
            }
            configuration.attributedText = attributedString
        }
        configuration.imageProperties.tintColor = .label
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recordItem = Array(searchResults.keys)[indexPath.section]
        if let recordItems = searchResults[recordItem]{
            let decriptionVc = DescriptionVC(recordId: recordItems[indexPath.row].id!)
            decriptionVc.title = "Details"
            decriptionVc.hidesBottomBarWhenPushed = true
            let navigationController = UINavigationController(rootViewController: decriptionVc)
            present(navigationController, animated: true)
        }
    }
                                                                        
                                                                            
                                                                            
}

