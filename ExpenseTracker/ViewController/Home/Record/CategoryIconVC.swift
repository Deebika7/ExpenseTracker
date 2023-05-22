//
//  CategoryIconVCTableViewController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 19/05/23.
//

import UIKit

class CategoryIconVC: UITableViewController {
    
    private var sfSymbol = [String]()
    
    private var label = [String]()
    
    weak var categoryDelegate: CategoryDelegate?
    
    lazy var selectedCategory: Category! = nil
    
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
        staticData()
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryIcon")
    }
    
    private func staticData() {
        label.append("Food")
        label.append("Gym")
        label.append("Rent")
        sfSymbol.append("fork.knife")
        sfSymbol.append("dumbbell")
        sfSymbol.append("house")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return label.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryIcon", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = label[indexPath.row]
        configuration.textProperties.color = .label
        configuration.image = UIImage(systemName: sfSymbol[indexPath.row])
        configuration.imageProperties.tintColor = .label
        if selectedCategory != nil {
            if label[indexPath.row]  == selectedCategory.categoryName {
                cell.accessoryType = .checkmark
            }
        }
        cell.backgroundColor = .systemBackground
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        categoryDelegate?.selectedCategory(Category(sfSymbolName: sfSymbol[indexPath.row], categoryName: label[indexPath.row]))
        tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissCategoryIconVC() {
        dismiss(animated: true, completion: nil)
    }
    
}
