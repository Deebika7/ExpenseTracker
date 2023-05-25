//
//  CategoryIconVCTableViewController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 19/05/23.
//

import UIKit

class CategoryIconVC: UITableViewController {
    
    weak var categoryDelegate: CategoryDelegate?
    
    private lazy var selectedCategory: Category! = nil
    
    private lazy var customCategory = Helper.customCategory
    
    convenience init(selectedCategory: Category?) {
        self.init(style: .insetGrouped)
        self.selectedCategory = selectedCategory
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissCategoryIconVC) )
        navigationItem.searchController = SearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryIcon")
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = Array(customCategory.keys)[section]
        return customCategory[sectionItem]?.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return customCategory.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Array(customCategory.keys)[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryIcon", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        let sectionItem = Array(customCategory.keys)[indexPath.section]
        if let categoryItems = customCategory[sectionItem] {
            let category = categoryItems[indexPath.row]
            configuration.text = category.categoryName
            configuration.textProperties.color = .label
            configuration.image = UIImage(systemName: category.sfSymbolName)
            configuration.imageProperties.tintColor = .label
            if selectedCategory != nil {
                if category.categoryName  == selectedCategory.categoryName {
                    cell.accessoryType = .checkmark
                }
            }
        }
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionItem = Array(customCategory.keys)[indexPath.section]
        if let categoryItems = customCategory[sectionItem] {
            let category = categoryItems[indexPath.row]
            categoryDelegate?.selectedCategory(Category(sfSymbolName: category.sfSymbolName, categoryName: category.categoryName))
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func dismissCategoryIconVC() {
        dismiss(animated: true, completion: nil)
    }
    
}
