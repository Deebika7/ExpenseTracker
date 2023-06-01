//
//  CategoriesListVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class CategoriesListVC: UITableViewController, PresentationModalSheetDelegate {
    
    weak var categoryDelegate: CategoryDelegate?
    
    private lazy var check = false
    
    private lazy var category: [Category] = {
        let category = (type == "Income") ? Helper.incomeCategory() : Helper.expenseCategory()
        return category
    }()
    
    private lazy var customCategory = CustomCategoryDataManager.shared.getAllCustomCategory()
   
    private lazy var searchController = SearchController()
    
    private var selectedCategory: Category?
    
    private lazy var type: String! = nil
    
    private lazy var edit: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(enableEditing))
    }()
    
    private lazy var add: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewCategory))
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = customCategory.isEmpty ? [add] : [add, edit]
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
    
    @objc func enableEditing() {
        tableView.isEditing  =  tableView.isEditing ? false : true
    }
    
    @objc func addNewCategory(){
        tableView.isEditing = false
        let addCategoryVC = AddCategorySheet()
        addCategoryVC.title = "Custom Category"
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
        navigationItem.rightBarButtonItems = customCategory.isEmpty ? [add] : [add, edit]
        return section == 0 ? "Default Category" : (customCategory.isEmpty) ? "" : "Custom Category"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? category.count : customCategory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        if indexPath.section == 0 {
            configuration.text = category[indexPath.row].categoryName
            configuration.image = UIImage(systemName: category[indexPath.row].sfSymbolName)
            if selectedCategory != nil {
                cell.accessoryType = (category[indexPath.row].categoryName  == selectedCategory!.categoryName) ? .checkmark: .none
            }
        }
        else if indexPath.section == 1 {
            configuration.text = customCategory[indexPath.row].name
            configuration.image = UIImage(systemName: customCategory[indexPath.row].icon!)
            if selectedCategory != nil {
                cell.accessoryType = (customCategory[indexPath.row].name  == selectedCategory!.categoryName) ? .checkmark: .none
            }
        }
        configuration.imageProperties.tintColor = .label
        configuration.textProperties.color = .label
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            categoryDelegate?.selectedCategory(Category(sfSymbolName: category[indexPath.row].sfSymbolName, categoryName: category[indexPath.row].categoryName), categoryType: Helper.categoryType.default)
        }
        else {
            categoryDelegate?.selectedCategory(Category(sfSymbolName: customCategory[indexPath.row].icon!, categoryName: customCategory[indexPath.row].name!), categoryType: Helper.categoryType.custom)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        dismiss(animated: true)
    }
    
    // MARK: Edit
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.section == 1 ? true : false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            categoryDelegate?.selectedCategory(nil, categoryType: -1)
            CustomCategoryDataManager.shared.deleteCustomCategory(id: customCategory[indexPath.row].id!)
            customCategory.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func dismissedPresentationModalSheet(_ isDismissed: Bool) {
        if isDismissed {
            customCategory = CustomCategoryDataManager.shared.getAllCustomCategory()
            tableView.reloadData()
        }
    }
    
    deinit{
        print("destroyed")
    }
    
}


