//
//  PopOverCalendarSheet.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 16/05/23.
//

import UIKit

class AddCategorySheet: UITableViewController {
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
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
            let categoryIconVC = CategoryIconVC()
            let navigationController = UINavigationController(rootViewController: categoryIconVC)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
            cell.backgroundColor = .systemBackground
            cell.contentView.addSubview(textField)
            NSLayoutConstraint.activate([
                textField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                textField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 3),
                textField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
            ])
            return cell
        }
        else  if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomDisClosureCellWithImage.reuseIdentifier, for: indexPath) as! CustomDisClosureCellWithImage
            cell.backgroundColor = .systemBackground
            cell.configure(with: "", and: "Select Category Icon")
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissAddCategorySheet() {
        dismiss(animated: true, completion: nil)
    }
    
}
