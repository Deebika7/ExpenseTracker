//
//  TitleVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 12/05/23.
//

import UIKit

class TypeVC: UITableViewController {
    
    var selectedRowIndex: Int?
    
    weak var selectionDelegate: SelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .secondarySystemBackground
        navigationItem.searchController = SearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(popTypeVC))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "title")
    }
    
    @objc func popTypeVC() {
        self.navigationController?.popViewController(animated: true)
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
            cell.textLabel?.text = indexPathValue.rawValue
            cell.textLabel?.textColor = .label
            cell.textLabel?.adjustsFontForContentSizeCategory = true
        case .income:
            cell.textLabel?.text = indexPathValue.rawValue
            cell.textLabel?.textColor = .label
            cell.textLabel?.adjustsFontForContentSizeCategory = true
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
        selectionDelegate?.selectedType( RecordType.allCases[indexPath.row].rawValue)
    }
    
    init() {
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
