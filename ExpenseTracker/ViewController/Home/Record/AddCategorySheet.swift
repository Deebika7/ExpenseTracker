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
    
    private lazy var changedColor: UIColor? = nil
    
    private lazy var isTextEntered: Bool = false
    
    private lazy var pickedColor: UIColor? = nil
        
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.becomeFirstResponder()
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
        isModalInPresentation = true
        tableView.backgroundColor = .systemGroupedBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addCustomCategory))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAddCategorySheet))
        tableView.register(CustomDisClosureCellWithImage.self, forCellReuseIdentifier: CustomDisClosureCellWithImage.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "colorSelectorCell")
        tableView.keyboardDismissMode = .onDrag
        if editCustomCategory != nil {
            selectedCategory = Category(sfSymbolName: editCustomCategory?.icon ?? "", categoryName: Helper.getCategoryName(for: editCustomCategory?.icon ?? ""), color: editCustomCategory?.color ?? "#808080")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
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
        else if indexPath.section == 2 {
            let colorPickerVC = UIColorPickerViewController()
            colorPickerVC.delegate = self
            colorPickerVC.isModalInPresentation = true
            present(colorPickerVC, animated: true)
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
                if !isTextEntered {
                    textField.text = editCustomCategoryName
                    if let text = textField.text {
                        countLabel.text = "\(text.count)/25"
                    }
                    isTextEntered = true
                }
            }
            return cell
        }
        else  if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomDisClosureCellWithImage.reuseIdentifier, for: indexPath) as? CustomDisClosureCellWithImage else {
                return UITableViewCell()
            }
            if selectedCategory != nil {
                cell.configure(icon: selectedCategory?.sfSymbolName ?? "", name: selectedCategory?.categoryName ?? "", color: selectedCategory?.color ?? "")
            }
            else {
                cell.configure(icon: "", name: "Select Category Icon",color: "")
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "colorSelectorCell", for: indexPath)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "Icon Color"
            configuration.textProperties.color = .label
            configuration.image = UIImage(systemName: "square.fill")
            configuration.imageProperties.tintColor = changedColor ?? UIColor(hex: selectedCategory?.color ?? "#808080")
            cell.contentConfiguration = configuration
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
        
        guard  text.trimMoreThanOneSpaces() != "" && textField.isEmptyAfterTrimmed else {
            showAlert(text: "Please enter category name")
            return
        }
        
        guard selectedCategory != nil else {
            showAlert(text: "Please select a category")
            return
        }
        
        var color: String = ""
        if let changedColor = changedColor {
            color = changedColor.toHexString() ?? "#808080"
        }
        else {
            color = selectedCategory?.color ?? "#808080"
        }
        
        if !CustomCategoryDataManager.shared.isCustomCategoryPresent(newCustomCategory: Category(sfSymbolName: selectedCategory?.sfSymbolName ?? "", categoryName: text.trimMoreThanOneSpaces(), color: color)) && !Helper.isCategoryPresent(textField.text ?? "") {
            
            if editCustomCategory != nil {
                tableView.performBatchUpdates {
                    RecordDataManager.shared.updateRecordForCustomCategory(customCategory: editCustomCategory!, newIcon: selectedCategory?.sfSymbolName ?? "", newCategory: text.trimMoreThanOneSpaces(),newColor: color)
                    CustomCategoryDataManager.shared.updateCustomCategory(oldCustomCategory: editCustomCategory!, newCustomCategory: Category(sfSymbolName: selectedCategory?.sfSymbolName ?? "" , categoryName: (textField.text ?? "").trimMoreThanOneSpaces(), color: color))
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
            changedColor = UIColor(hex: selectedCategory?.color ?? "808080")
        }
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1), IndexPath(row: 0, section: 2)], with: .none)
    }
    
    // MARK: Alert
    func showAlert(text: String) {
        let alert = UIAlertController(title: text, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension AddCategorySheet: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        pickedColor = color
        if !CustomCategoryDataManager.shared.isColorAvailable(color: color.toHexString() ?? "") {
            changedColor = color
            selectedCategory?.color = changedColor?.toHexString() ?? "#808080"
            tableView.reloadData()
        }
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        if CustomCategoryDataManager.shared.isColorAvailable(color: self.pickedColor?.toHexString() ?? "") {
            showAlert(text: "The selected color is already in use")
        }
    }
}

