//
//  CategoryResultsController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 01/06/23.
//

import UIKit

class CategoryResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var searchResults = [String: [Category]]()
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategorySearchResults")
    }
    
    func updateSearchResults(_ results: [String:[Category]]) {
        searchResults = results
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let searchItem = Array(searchResults.keys)[section]
        return searchResults[searchItem]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Array(searchResults.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategorySearchResults", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        let sectionItem = Array(searchResults.keys)[indexPath.section]
        if let categoryItems = searchResults[sectionItem] {
            let category = categoryItems[indexPath.row]
            configuration.text = category.categoryName
            configuration.textProperties.color = .label
            configuration.image = UIImage(systemName: category.sfSymbolName)
            configuration.imageProperties.tintColor = .label
        }
        cell.contentConfiguration = configuration
        return cell
    }
    
}
