//
//  PopOverCalendarSheet.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 16/05/23.
//

import UIKit

class AddCategorySheet: UITableViewController, CategoryDelegate, UITextFieldDelegate {
    
    var selectedCategory: Category?
    
    weak var presentationModalSheetDelegate: PresentationModalSheetDelegate?
    
    private lazy var editCustomCategory: CustomCategory? = nil
        
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.becomeFirstResponder()
        textField.text = String(textField.text?.prefix(12) ?? "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.placeholder = "Category Name"
        textField.keyboardType = .default
        textField.addTarget(self, action: #selector(handleOnEditing), for: .editingChanged)
        textField.autocorrectionType = .no
        return textField
    }()
    
    private lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.textColor = .placeholderText
        countLabel.text = "0/30"
        return countLabel
    }()

    convenience init(editCustomCategory: CustomCategory?) {
        self.init(style: .insetGrouped)
        self.editCustomCategory = editCustomCategory
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
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
        if editCustomCategory != nil {
            selectedCategory = Category(sfSymbolName: editCustomCategory?.icon ?? "", categoryName: Helper.getCategoryName(for: editCustomCategory?.icon ?? ""))
        }
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
            cell.contentView.addSubview(textField)
            cell.contentView.addSubview(countLabel)
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                textField.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                textField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                textField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                countLabel.heightAnchor.constraint(equalToConstant: 20),
                countLabel.widthAnchor.constraint(equalToConstant: 50),
                countLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                countLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            ])
            if let editCustomCategoryName = editCustomCategory?.name {
                textField.text = editCustomCategoryName
                if let text = textField.text {
                    countLabel.text = "\(text.count)/25"
                }
            }
            return cell
        }
        else  if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomDisClosureCellWithImage.reuseIdentifier, for: indexPath) as? CustomDisClosureCellWithImage else {
                return UITableViewCell()
            }
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
        
        guard let text = textField.text else {
            showAlert(text: "Please enter category name")
            return
        }
        
        guard  text != "" && textField.isEmptyAfterTrimmed else {
            showAlert(text: "Please enter category name")
            return
        }
        
        guard selectedCategory != nil else {
            showAlert(text: "Please select a category")
            return
        }
        
        if !CustomCategoryDataManager.shared.isCustomCategoryPresent(newCustomCategory: Category(sfSymbolName: selectedCategory?.sfSymbolName ?? "", categoryName: textField.text!)) && !Helper.isCategoryPresent(textField.text ?? "") {
            
            if editCustomCategory != nil {
                tableView.performBatchUpdates {
                    RecordDataManager.shared.updateRecordForCustomCategory(customCategory: editCustomCategory!, newIcon: selectedCategory?.sfSymbolName ?? "", newCategory: text.trimMoreThanOneSpaces())
                    CustomCategoryDataManager.shared.updateCustomCategory(oldCustomCategory: editCustomCategory!, newCustomCategory: Category(sfSymbolName: selectedCategory?.sfSymbolName ?? "" , categoryName: (textField.text ?? "").trimMoreThanOneSpaces()))
                }
                let alert = UIAlertController(title: "Category updated", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                        self.dismiss(animated: true){ [weak self] in
                            self?.presentationModalSheetDelegate?.dismissedPresentationModalSheet(true)
                        }
                    })
                }))
                self.present(alert, animated: true)
            }
            else if CustomCategoryDataManager.shared.addCustomCategory(name: text.trimMoreThanOneSpaces(), category: selectedCategory!) {
                let alert = UIAlertController(title: "Custom Category added", message: "", preferredStyle: .alert)
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
        else {
            let alert = UIAlertController(title: "Custom Category Exist Already", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissAddCategorySheet()
    {
        guard let text = textField.text else {
            return
        }
        if selectedCategory != nil || text != "" {
            
            let alert = UIAlertController(title: "Discard Changes", message: "Are you sure want to discard changes?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {_ in
                self.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
        else {
            dismiss(animated: true)
        }
    }
    
    @objc func handleOnEditing() {
        let text = textField.text ?? ""
        let limit = 30
        textField.text = String(text.prefix(limit))
        if let text = textField.text {
            countLabel.text = "\(text.count)/30"
        }
    }
    
    func selectedCategory(_ category: Category?, categoryType: Int) {
        if let category = category {
            selectedCategory = category
        }
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
        return ((text?.trimmingCharacters(in: .whitespaces).isEmpty) != nil)
    }
}

extension String {
    func trimMoreThanOneSpaces() -> String {
        let components = self.components(separatedBy: .whitespaces)
        let filteredComponents = components.filter { !$0.isEmpty }
        return filteredComponents.joined(separator: " ")
    }
}

