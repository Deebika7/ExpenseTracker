//
//  CategoryIconVCTableViewController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 19/05/23.
//

import UIKit

class CategoryIconVC: UITableViewController, UISearchResultsUpdating {
    
    weak var categoryDelegate: CategoryDelegate?
    
    private lazy var selectedCategory: Category! = nil
    
    private lazy var customCategory = Helper.customCategory
    
    private lazy var searchResults = customCategory
    
    convenience init(selectedCategory: Category?) {
        self.init(style: .insetGrouped)
        self.selectedCategory = selectedCategory
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissCategoryIconVC) )
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryIcon")
        tableView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = Array(searchResults.keys)[section]
        return searchResults[sectionItem]?.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Array(searchResults.keys)[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryIcon", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        let sectionItem = Array(searchResults.keys)[indexPath.section]
        if let categoryItems = searchResults[sectionItem] {
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
        let sectionItem = Array(searchResults.keys)[indexPath.section]
        if let categoryItems = searchResults[sectionItem] {
            let category = categoryItems[indexPath.row]
            categoryDelegate?.selectedCategory(Category(sfSymbolName: category.sfSymbolName, categoryName: category.categoryName), categoryType: -1)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissCategoryIconVC() {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("destroyed")
    }
    
    // MARK: search
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        searchResults = searchResults.filter { key, value in
            key.localizedCaseInsensitiveContains(text) ||
            value.contains { $0.categoryName.localizedCaseInsensitiveContains(text) || $0.sfSymbolName.localizedCaseInsensitiveContains(text) }
        }.mapValues { value in
            value.filter { $0.categoryName.localizedCaseInsensitiveContains(text) || $0.sfSymbolName.localizedCaseInsensitiveContains(text)
            }
        }
        var searchedSection = customCategory.filter { customCategory in
            return customCategory.key.localizedCaseInsensitiveContains(text)
        }

        searchResults.merge(searchedSection) {
            (merge, _) in merge
        }
        searchResults = searchResults.filter { !$0.value.isEmpty }
        if text.isEmpty {
            searchResults = customCategory
        }
        tableView.reloadData()
    }
    
}
