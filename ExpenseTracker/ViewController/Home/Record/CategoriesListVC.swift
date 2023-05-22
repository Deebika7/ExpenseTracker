//
//  CategoriesListVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class CategoriesListVC: UITableViewController {
    
    weak var categoryDelegate: CategoryDelegate?
    
    private var sfSymbol = [String]()
    
    private var label = [String]()
    
    private lazy var searchController = SearchController()
    
    lazy var selectedCategory: Category! = nil
    
    convenience init(selectedCategory: Category) {
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
        tableView.backgroundColor = .secondarySystemBackground
        staticData()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewCategory))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        tableView.estimatedSectionHeaderHeight = 10
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    @objc func addNewCategory(){
        let addCategoryVC = AddCategorySheet()
        let navigationController = UINavigationController(rootViewController: addCategoryVC)
        navigationController.modalPresentationStyle = .formSheet
        navigationController.preferredContentSize = .init(width: view.frame.width, height: view.frame.height)
        present(navigationController, animated: true)
    }
    
    private func staticData() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = label[indexPath.row]
        configuration.textProperties.color = .label
        configuration.image = UIImage(systemName: sfSymbol[indexPath.row])
        configuration.imageProperties.tintColor = .label
        if label[indexPath.row]  == selectedCategory.categoryName {
            cell.accessoryType = .checkmark
        }
        cell.backgroundColor = .systemBackground
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        categoryDelegate?.selectedCategory(Category(sfSymbolName: sfSymbol[indexPath.row], categoryName: label[indexPath.row]))
        tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
