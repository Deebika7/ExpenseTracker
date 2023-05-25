//
//  PopOverCalendarSheet.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 16/05/23.
//

import UIKit

class AddCategorySheet: UITableViewController, CategoryDelegate {
    
    var selectedCategory: Category?
    
    weak var presentationModalSheetDelegate: PresentationModalSheetDelegate?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.placeholder = "Category Name"
        textField.keyboardType = .default
        textField.addTarget(self, action: #selector(handleOnEditing), for: .editingChanged)
        textField.autocorrectionType = .no
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
        tableView.backgroundColor = .systemGroupedBackground
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
            categoryIconVC.title = "Custom Category Icon"
            let navigationController = UINavigationController(rootViewController: categoryIconVC)
            navigationController.preferredContentSize = .init(width: view.frame.width, height: view.frame.height)
            present(navigationController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
            cell.contentView.addSubview(textField)
            
            NSLayoutConstraint.activate([
                textField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                textField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                textField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            ])
            return cell
        }
        else  if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomDisClosureCellWithImage.reuseIdentifier, for: indexPath) as! CustomDisClosureCellWithImage
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
        
        guard textField.text! != "" && !textField.isEmptyAfterTrimmed else {
            showAlert(text: "Please enter category name")
            return
        }
        
        guard selectedCategory != nil else {
            showAlert(text: "Please select a category")
            return
        }
        
        if CustomCategoryDataManager.shared.addCustomCategory(name: (textField.text!).trimMoreThanOneSpaces(), category: selectedCategory!) {
            let alert = UIAlertController(title: "", message: "Category added", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    self.dismiss(animated: true){ [weak self] in
                        self?.presentationModalSheetDelegate?.dismissedPresentationModalSheet(true)
                    }
                })
            }))
            self.present(alert, animated: true)
            
        }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissAddCategorySheet()
    {
        dismiss(animated: true)
    }
    
    @objc func handleOnEditing() {
        let text = textField.text ?? ""
        let limit = 30
        textField.text = String(text.prefix(limit))
    }
    
    func selectedCategory(_ category: Category) {
        selectedCategory = category
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
    }
    
    // MARK: Alert
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension UITextField {
    var isEmptyAfterTrimmed: Bool {
        return ((text!.trimmingCharacters(in: .whitespaces).isEmpty))
    }
}

extension String {
    
    func trimMoreThanOneSpaces() -> String {
        let components = self.components(separatedBy: .whitespaces)
        let filteredComponents = components.filter { !$0.isEmpty }
        return filteredComponents.joined(separator: " ")
    }
    
}

