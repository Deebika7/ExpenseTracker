//
//  TitleVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 12/05/23.
//

import UIKit

class TypeVC: UITableViewController {
    
    var selectedRowIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .secondarySystemBackground
        navigationItem.searchController = SearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "title")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath)
        cell.backgroundColor = .systemBackground
        let indexPathValue = RecordType.allCases[indexPath.row]
        switch indexPathValue {
        case .expense:
            cell.textLabel?.text = "Expense"
            cell.textLabel?.textColor = .label
        case .income:
            cell.textLabel?.text = "Income"
            cell.textLabel?.textColor = .label
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedRowIndex = selectedRowIndex {
            let previousSelectedIndexPath = IndexPath(row: selectedRowIndex, section: indexPath.section)
            let previousSelectedCell = tableView.cellForRow(at: previousSelectedIndexPath)
            previousSelectedCell?.accessoryType = .none
        }
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
        selectedRowIndex = indexPath.row
    }
    
    init() {
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
