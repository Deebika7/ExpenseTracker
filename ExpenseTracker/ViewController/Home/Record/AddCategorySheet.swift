//
//  PopOverCalendarSheet.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 16/05/23.
//

import UIKit

class AddCategorySheet: UITableViewController, CategoryDelegate {
    
    private var selectedCategory: Category?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 10
        textField.placeholder = "Category Name"
        textField.keyboardType = .default
        return textField
    }()
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .secondarySystemBackground
        tableView.backgroundColor = .secondarySystemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addCustomCategory))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAddCategorySheet))
        tableView.register(CustomDisClosureCellWithImage.self, forCellReuseIdentifier: CustomDisClosureCellWithImage.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TextFieldCell")
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let categoryIconVC = CategoryIconVC(selectedCategory: selectedCategory)
            categoryIconVC.categoryDelegate = self
            let navigationController = UINavigationController(rootViewController: categoryIconVC)
            navigationController.preferredContentSize = .init(width: view.frame.width, height: view.frame.height)
            present(navigationController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
            cell.backgroundColor = .systemBackground
            cell.contentView.addSubview(textField)
            NSLayoutConstraint.activate([
                textField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                textField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                textField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
            ])
            return cell
        }
        else  if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomDisClosureCellWithImage.reuseIdentifier, for: indexPath) as! CustomDisClosureCellWithImage
            cell.backgroundColor = .systemBackground
            if selectedCategory != nil {
                cell.configure(with: selectedCategory!.sfSymbolName, and: selectedCategory!.categoryName)
            }
            else {
                cell.configure(with: "", and: "Select Category Icon")
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func addCustomCategory() {
        
        guard textField.text! != ""  else {
            let alert = UIAlertController(title: "", message: "Please enter category name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        guard selectedCategory != nil else {
            let alert = UIAlertController(title: "", message: "Please select a category", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        Toast(text: "Category added", delay: 0)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissAddCategorySheet() {
        dismiss(animated: true, completion: nil)
    }
    
    func selectedCategory(_ category: Category) {
        selectedCategory = category
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
    }
    
    // MARK: Toast
    
    func Toast(text: String, delay: Int) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(delay), execute: {
            alert.dismiss(animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
}
