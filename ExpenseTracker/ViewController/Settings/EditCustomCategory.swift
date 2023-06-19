//
//  EditCustomCategory.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 08/06/23.
//

import UIKit

class EditCustomCategory: UITableViewController, PresentationModalSheetDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    private lazy var searchedCustomCategory = CustomCategoryDataManager.shared.getAllCustomCategory()
    
    private lazy var customCategory = CustomCategoryDataManager.shared.getAllCustomCategory()
    
    private lazy var searchText = ""
    
    private lazy var add: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewCategory))
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var noDataFoundView: UIView = {
        let noDataFoundView = NoDataFoundView(image: "magnifyingglass", message: "Search results not found")
        return noDataFoundView
    }()
    
    @objc func addNewCategory(){
        tableView.isEditing = false
        view.endEditing(true)
        let addCategoryVC = AddCategorySheet(editCustomCategory: nil)
        addCategoryVC.title = "Add Custom Category"
        addCategoryVC.presentationModalSheetDelegate = self
        let navigationController = UINavigationController(rootViewController: addCategoryVC)
        navigationController.modalPresentationStyle = .formSheet
        tableView.translatesAutoresizingMaskIntoConstraints = false
        present(navigationController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomCategory")
        navigationItem.rightBarButtonItems = [add]
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteCustomCategory(indexPath, completionHandler: completionHandler)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.title = "delete"
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            self?.editCustomCategory(indexPath)
            completionHandler(true)
        }
        editAction.title = "edit"
        editAction.backgroundColor = .systemBlue
        editAction.image = UIImage(systemName: "pencil")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedCustomCategory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCategory", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        let customCategory = searchedCustomCategory[indexPath.row].name ?? ""
        let attributedString = NSMutableAttributedString(string: customCategory)
        if let range = customCategory.range(of: searchText, options: .caseInsensitive) {
            let nsRange = NSRange(range, in: customCategory)
            attributedString.addAttributes([.foregroundColor: UIColor.systemBlue], range: nsRange)
        }
        configuration.attributedText = attributedString
        configuration.image = UIImage(systemName: searchedCustomCategory[indexPath.row].icon ?? "")
        configuration.imageProperties.tintColor = .label
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCustomCategory(indexPath, completionHandler: {_ in })
        }
    }
    
    private func deleteCustomCategory(_ indexPath: IndexPath, completionHandler: @escaping (Bool) -> Void ) {
        let alert = UIAlertController(title: "Delete Custom Category", message: "Records saved in this custom category will be moved to others", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {_ in
            completionHandler(false)
        })
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [weak self]  _ in
            self?.tableView.performBatchUpdates {
                RecordDataManager.shared.updateRecordForCustomCategory(customCategory: (self?.searchedCustomCategory[indexPath.row])!, newIcon: "square.grid.3x3", newCategory: "Others")
                CustomCategoryDataManager.shared.deleteCustomCategory(id: (self?.searchedCustomCategory[indexPath.row].id ?? UUID()))
                self?.searchedCustomCategory.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            self?.refreshTable()
            completionHandler(true)
        }))
        self.present(alert, animated: true)
    }
    
    func editCustomCategory(_ indexPath: IndexPath) {
        let editCustomCategoryVC = AddCategorySheet(editCustomCategory: searchedCustomCategory[indexPath.row])
        editCustomCategoryVC.title = "Custom Category"
        editCustomCategoryVC.presentationModalSheetDelegate = self
        let navigationController = UINavigationController(rootViewController: editCustomCategoryVC)
        present(navigationController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        searchedCustomCategory.isEmpty ? "" : "Custom Category"
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil"), handler: { [weak self] _ in
            self?.editCustomCategory(indexPath)
        })
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: [.destructive], handler: { [weak self] _ in
            self?.deleteCustomCategory(indexPath, completionHandler: {_ in
                
            })
        })
        
        let menu = UIMenu(children: [editAction, deleteAction])
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, actionProvider: {_ in
            return menu
        })
    }
    
    func dismissedPresentationModalSheet(_ isDismissed: Bool) {
        if isDismissed {
            refreshTable()
        }
    }
    
    func refreshTable() {
        searchedCustomCategory = CustomCategoryDataManager.shared.getAllCustomCategory()
        customCategory = CustomCategoryDataManager.shared.getAllCustomCategory()
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        refreshTable()
        guard let text = searchController.searchBar.text else {
            return
        }
        searchText = text
        
        searchedCustomCategory = customCategory.filter{ customCategory in
            return customCategory.name!.localizedCaseInsensitiveContains(text)
        }
        
        if text.isEmpty {
            searchedCustomCategory = customCategory
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        refreshTable()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        refreshTable()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
