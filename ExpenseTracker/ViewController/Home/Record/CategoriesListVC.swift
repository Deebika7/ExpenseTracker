//
//  CategoriesListVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class CategoriesListVC: UITableViewController, PresentationModalSheetDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    weak var categoryDelegate: CategoryDelegate?
    
    private lazy var check = false
    
    private lazy var searchText = String()
    
    private lazy var searchedCategory: [Category] = {
        let category = (type == "Income") ? Helper.incomeCategory : Helper.expenseCategory
        return category
    }()
    
    private lazy var category: [Category] = {
        let category = (type == "Income") ? Helper.incomeCategory : Helper.expenseCategory
        return category
    }()
    
    private lazy var searchedCustomCategory = CustomCategoryDataManager.shared.getAllCustomCategory()
    
    private lazy var customCategory = CustomCategoryDataManager.shared.getAllCustomCategory()
   
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private var selectedCategory: Category?
    
    private lazy var type = String()
    
    private lazy var add: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewCategory))
    }()
    
    private lazy var noDataFoundView: UIView = {
        let noDataFoundView = NoDataFoundView(image: "magnifyingglass", message: "Search results not found")
        return noDataFoundView
    }()
    
    convenience init(selectedCategory: Category?, type: String) {
        self.init(style: .insetGrouped)
        self.selectedCategory = selectedCategory
        self.type = type
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [add]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissCategoryListVc))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        tableView.estimatedSectionHeaderHeight = 10
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
    }
    
    @objc func dismissCategoryListVc() {
        dismiss(animated: true)
    }
    
    
    @objc func addNewCategory(){
        searchController.searchBar.text = nil
        searchController.searchBar.endEditing(true)
        let addCategoryVC = AddCategorySheet(editCustomCategory: nil)
        addCategoryVC.title = "Add Custom Category"
        addCategoryVC.presentationModalSheetDelegate = self
        let navigationController = UINavigationController(rootViewController: addCategoryVC)
        navigationController.modalPresentationStyle = .formSheet
        navigationController.preferredContentSize = .init(width: view.frame.width, height: view.frame.height)
        present(navigationController, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? (searchedCategory.isEmpty) ? "" : "Default Category" : (searchedCustomCategory.isEmpty) ? "" : "Custom Category"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? searchedCategory.count : searchedCustomCategory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        if indexPath.section == 0 {
            let category = searchedCategory[indexPath.row].categoryName
            let attributedString = NSMutableAttributedString(string: category)
            if let range = category.range(of: searchText, options: .caseInsensitive) {
                let nsRange = NSRange(range, in: category)
                attributedString.addAttributes([.foregroundColor: UIColor.systemBlue], range: nsRange)
            }
            configuration.attributedText = attributedString
            configuration.image = UIImage(systemName: searchedCategory[indexPath.row].sfSymbolName)
            configuration.imageProperties.tintColor = UIColor(hex: searchedCategory[indexPath.row].color)
            if selectedCategory != nil {
                cell.accessoryType = (searchedCategory[indexPath.row].categoryName  == selectedCategory!.categoryName && searchedCategory[indexPath.row].sfSymbolName  == selectedCategory!.sfSymbolName) ? .checkmark: .none
            }
        }
        else if indexPath.section == 1 {
            let category = searchedCustomCategory[indexPath.row].name ?? ""
            let attributedString = NSMutableAttributedString(string: category)
            if let range = category.range(of: searchText, options: .caseInsensitive) {
                let nsRange = NSRange(range, in: category)
                attributedString.addAttributes([.foregroundColor: UIColor.systemBlue], range: nsRange)
            }
            configuration.attributedText = attributedString
            configuration.image = UIImage(systemName: searchedCustomCategory[indexPath.row].icon ?? "")
            if selectedCategory != nil {
                cell.accessoryType = (searchedCustomCategory[indexPath.row].name  == selectedCategory!.categoryName && searchedCustomCategory[indexPath.row].icon == selectedCategory!.sfSymbolName) ? .checkmark: .none
            }
            configuration.imageProperties.tintColor = UIColor(hex: searchedCustomCategory[indexPath.row].color ?? "#808080")
        }
        configuration.textProperties.color = .label
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            categoryDelegate?.selectedCategory(Category(sfSymbolName: searchedCategory[indexPath.row].sfSymbolName, categoryName: searchedCategory[indexPath.row].categoryName, color: searchedCategory[indexPath.row].color), categoryType: Helper.categoryType.default)
        }
        else {
            categoryDelegate?.selectedCategory(Category(sfSymbolName: searchedCustomCategory[indexPath.row].icon ?? "", categoryName: searchedCustomCategory[indexPath.row].name ?? "", color: searchedCustomCategory[indexPath.row].color ?? ""), categoryType: Helper.categoryType.custom)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func dismissedPresentationModalSheet(_ isDismissed: Bool) {
        if isDismissed {
            refreshTable()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        tableView.backgroundView = nil
        guard let text = searchController.searchBar.text else {
            return
        }
        searchText = text
        searchedCategory = category.filter{ category in
            return category.categoryName.localizedCaseInsensitiveContains(text) || category.sfSymbolName.localizedCaseInsensitiveContains(text)
        }
        
        searchedCustomCategory = customCategory.filter{ customCategory in
            return customCategory.name!.localizedCaseInsensitiveContains(text) || customCategory.icon!.localizedCaseInsensitiveContains(text)
        }
        if searchedCategory.count == 0 && searchedCustomCategory.count == 0 {
            tableView.backgroundView = noDataFoundView
        }
        else {
            tableView.backgroundView = nil
        }
        
        if text.isEmpty {
            refreshTable()
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        refreshTable()
    }
    
    func refreshTable() {
        searchedCategory = (type == "Income") ? Helper.incomeCategory : Helper.expenseCategory
        searchedCustomCategory = CustomCategoryDataManager.shared.getAllCustomCategory()
        customCategory = CustomCategoryDataManager.shared.getAllCustomCategory()
        tableView.backgroundView = nil
        tableView.reloadData()
    }
}


