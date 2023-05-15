//
//  RecordVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class RecordVC: UITableViewController, SelectionDelegate {
    
    var changedCategory: Category?
    var type: String?
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: nil)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(CustomTextFieldCell.self, forCellReuseIdentifier: CustomTextFieldCell.reuseIdentifier)
        tableView.register(CustomDisClosureCell.self, forCellReuseIdentifier: CustomDisClosureCell.reuseIdentifier)
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderFooterView.reuseIdentifier)
        tableView.register(CustomDisClosureCellWithImage.self, forCellReuseIdentifier: CustomDisClosureCellWithImage.reuseIdentifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    

        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexPathValue = RecordField.allCases[indexPath.section]
        switch indexPathValue {
        case .type:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomDisClosureCell.reuseIdentifier, for: indexPath) as! CustomDisClosureCell
            if type != nil {
                cell.configureCustomdisclosureCell(type!)
            }
            else {
                cell.configureCustomdisclosureCell("Income")
            }
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .systemBackground
            return cell
        case .amount:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTextFieldCell.reuseIdentifier, for: indexPath) as! CustomTextFieldCell
            cell.configureNumberKeyBoard()
            cell.backgroundColor = .systemBackground
            return cell
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTextFieldCell.reuseIdentifier, for: indexPath) as! CustomTextFieldCell
            cell.configureNumberKeyBoard()
            cell.backgroundColor = .systemBackground
            return cell
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomDisClosureCellWithImage.reuseIdentifier, for: indexPath) as! CustomDisClosureCellWithImage
            if changedCategory != nil {
                cell.configure(with: changedCategory!.sfSymbolName, and: changedCategory!.categoryName)
            }
            else {
                cell.configure(with: "fork.knife", and: "foofkufyuljfdjrfdytfjtdkuyigliggio;oigckfutgydtkud")
            }
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .systemBackground
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let indexPathValue = RecordField.allCases[indexPath.section]
        switch indexPathValue {
        case .type:
            let typeVC = TypeVC()
            typeVC.selectionDelegate = self
            navigationController?.pushViewController(typeVC, animated: true)
        case .date:
            print("")
        case .category:
            let categoryListVC = CategoriesListVC()
            categoryListVC.selectionDelegate = self
            navigationController?.pushViewController(categoryListVC, animated: true)
        default:
            print("")
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:CustomHeaderFooterView.reuseIdentifier) as! CustomHeaderFooterView
        headerView.configureView(with: RecordField.allCases[section].rawValue)
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return RecordField.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func selectedType(_ text: String) {
        type = text
        tableView.reloadData()
    }
    
    func selectedCategory(_ category: Category) {
        changedCategory = category
        tableView.reloadData()
    }
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
