//
//  CategoriesListVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class CategoriesListVC: UITableViewController {
    
    weak var selectionDelegate: SelectionDelegate?
    
    var sfSymbol = [String]()
    
    var label = [String]()
    
    var selectedRowIndex: Int?
    
    private lazy var searchController = SearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .secondarySystemBackground
        staticData()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.resuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        tableView.estimatedSectionHeaderHeight = 10
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    func staticData() {
        label.append("Food")
        label.append("Gym")
        label.append("Rent")
        sfSymbol.append("fork.knife")
        sfSymbol.append("dumbbell")
        sfSymbol.append("house")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sfSymbol.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.resuseIdentifier, for: indexPath) as! CategoryCell
        cell.configure(with: sfSymbol[indexPath.row], and: label[indexPath.row])
        cell.backgroundColor = .systemBackground
        return cell
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
        selectionDelegate?.selectedCategory(Category(sfSymbolName: sfSymbol[indexPath.row], categoryName: label[indexPath.row]))
        tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
