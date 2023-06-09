//
//  RecordVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class RecordVC: UITableViewController, SelectionDelegate, UICalendarSelectionSingleDateDelegate, CategoryDelegate {
    
    private lazy var changedCategory: Category? = nil
    private lazy var currentType: String = Helper.defaultType
    private lazy var previousType: String? = nil
    private lazy var changedDate: String? = nil
    private lazy var isRowExpanded: Bool = false
    private lazy var isTypeChanged: Bool = false
    private lazy var amount: String = ""
    private lazy var date = Helper.convertDateToString(date: Helper.defaultDate)
    private weak var editRecord: Record?
    private lazy var editRecordId: UUID? = nil
    private lazy var isEditingEnabled: Bool = false
    private lazy var categoryType: Int = 0
    weak var presentationModalSheetDelegate : PresentationModalSheetDelegate?
    
    private lazy var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.availableDateRange = DateInterval(start: .distantPast, end: Date())
        calendarView.calendar = gregorianCalendar
        calendarView.layer.cornerRadius = 10.0
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemGroupedBackground
        tableView.keyboardDismissMode = .onDrag
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addRecord))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAddRecord))
        navigationController?.navigationBar.prefersLargeTitles = true
        registerCustomCells()
        tableView.allowsSelection = true
        if let editRecord = editRecord {
            isEditingEnabled = true
            editRecordId = editRecord.id
        }
    }
    
    // MARK: Validation
    
    @objc func addRecord() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CustomTextFieldCell
        amount = (cell.getEnteredData())
        
        guard !amount.isEmpty else {
            showAlert(text: "Please enter amount")
            return
        }
        
        guard Double(amount) != nil else {
            showAlert(text: "Enter Valid amount")
            return
        }
        
        guard Double(amount) ?? 0 > 0 else {
            showAlert(text: "Amount should be greater than 0")
            return
        }
        
        guard changedCategory != nil else {
            showAlert(text: "Please select a category")
            return
        }
        if isEditingEnabled {
            RecordDataManager.shared.updateRecord(id: editRecordId!, type: currentType, amount: amount, date: changedDate!, category: changedCategory!)
            view.endEditing(true)
            isEditingEnabled.toggle()
            let alert = UIAlertController(title: "Record updated", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    self.presentationModalSheetDelegate?.dismissedPresentationModalSheet(true)
                    self.dismiss(animated: true){ [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
            }))
            self.present(alert, animated: true)
        }
        else if RecordDataManager.shared.createRecord(type: currentType, amount: amount, createdDate: changedDate ?? Helper.convertDateToString(date: Helper.defaultDate), category: changedCategory!) {
            view.endEditing(true)
            let alert = UIAlertController(title: "Record added", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    self.presentationModalSheetDelegate?.dismissedPresentationModalSheet(true)
                    self.dismiss(animated: true){ [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
            }))
            self.present(alert, animated: true)
        }
        
    }
    
    func didEndEditing() {
        changedCategory = nil
        currentType = Helper.defaultType
        changedDate = nil
    }
    
    @objc func dismissAddRecord() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CustomTextFieldCell
        amount = (cell.getEnteredData())
        print(amount)
        if changedCategory != nil || amount != "" {
            let alert = UIAlertController(title: "Discard Changes", message: "Are you sure want to discard changes?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {_ in
                self.tableView.endEditing(true)
                self.dismiss(animated: true)
                self.presentationModalSheetDelegate?.dismissedPresentationModalSheet(true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
        else {
            tableView.endEditing(true)
            self.dismiss(animated: true)
            self.presentationModalSheetDelegate?.dismissedPresentationModalSheet(true)
        }
    }
    
    // MARK: TableView Cells
    private func registerCustomCells() {
        tableView.register(CustomTextFieldCell.self, forCellReuseIdentifier: CustomTextFieldCell.reuseIdentifier)
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderFooterView.reuseIdentifier)
        tableView.register(CustomDisClosureCellWithImage.self, forCellReuseIdentifier: CustomDisClosureCellWithImage.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CalendarView")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TypeCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CalendarLabel")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexPathValue = RecordField.allCases[indexPath.section]
        switch indexPathValue {
        case .type:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell" , for: indexPath)
            var configuration = cell.defaultContentConfiguration()
            
            if let editRecord = editRecord {
                configuration.text = RecordType.allCases[Int(editRecord.type)].rawValue
                currentType = RecordType.allCases[Int(editRecord.type)].rawValue
            }
            else {
                configuration.text = currentType
            }
            cell.contentConfiguration = configuration
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case .amount:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTextFieldCell.reuseIdentifier, for: indexPath) as! CustomTextFieldCell
            if let editRecord = editRecord {
                cell.textField.text = editRecord.amount ?? "0"
            }
            cell.configureNumberKeyBoard()
            return cell
            
        case .date:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarLabel", for: indexPath)
                var configuration  = cell.defaultContentConfiguration()
                
                if let editRecord = editRecord {
                    configuration.text = Helper.convertDateToString(date: editRecord.date ?? Date())
                    changedDate = Helper.convertDateToString(date: editRecord.date ?? Date())
                }
                else if changedDate != nil && changedDate != date {
                    configuration.text = changedDate!
                }
                else {
                    configuration.text = "\(Helper.convertDateToString(date: Helper.defaultDate))"+" "+"(Today)"
                }
                let systemName = isRowExpanded ? "calendar.badge.minus" : "calendar.badge.plus"
                cell.accessoryView = UIImageView(image: UIImage(systemName: systemName))
                cell.accessoryView?.tintColor = .label
                
                cell.contentConfiguration = configuration
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarView", for: indexPath)
                cell.contentView.addSubview(calendarView)
                
                NSLayoutConstraint.activate([
                    calendarView.leadingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.leadingAnchor),
                    calendarView.trailingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.trailingAnchor),
                    calendarView.bottomAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.bottomAnchor),
                    calendarView.topAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.topAnchor)
                ])
                return cell
            }
        case .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomDisClosureCellWithImage.reuseIdentifier, for: indexPath) as? CustomDisClosureCellWithImage else {
                return UITableViewCell()
            }
            if let editRecord = editRecord {
                cell.configure(with: editRecord.icon ?? "", and: editRecord.category ?? "")
                changedCategory = Category(sfSymbolName: editRecord.icon ?? "", categoryName: editRecord.category ?? "")
            }
            else if changedCategory != nil {
                cell.configure(with: changedCategory!.sfSymbolName, and: changedCategory!.categoryName)
            }
            else {
                cell.configure(with: "", and: "Select a Category")
            }
            
            cell.accessoryType = .disclosureIndicator
            editRecord = nil
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        let indexPathValue = RecordField.allCases[indexPath.section]
        switch indexPathValue {
        case .type:
            let typeVC = TypeVC(selectedType: currentType)
            typeVC.title = "Type"
            typeVC.selectionDelegate = self
            isTypeChanged.toggle()
            let navigationController = UINavigationController(rootViewController: typeVC)
            present(navigationController, animated: true)
        case .category:
            let categoryListVC = CategoriesListVC(selectedCategory: changedCategory, type: currentType)
            categoryListVC.title = "Category"
            categoryListVC.categoryDelegate = self
            let navigationController = UINavigationController(rootViewController: categoryListVC)
            present(navigationController, animated: true)
        case .date:
            isRowExpanded.toggle()
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        default:
            ()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderFooterView.reuseIdentifier) as? CustomHeaderFooterView else {
            return UITableViewCell()
        }
        headerView.configureView(with: RecordField.allCases[section].rawValue)
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return RecordField.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRowExpanded  && section == 2 {
            return 2
        }
        return  1
    }
    
    // MARK: Selection Delegate
    
    func selectedType(_ text: String) {
        previousType = currentType
        currentType = text
        print(Helper.categoryType.default)
        if previousType != currentType && categoryType == Helper.categoryType.default {
            print(categoryType)
                tableView.reloadData()
                changedCategory = nil
        } 
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    // MARK: Category Delegate
    
    func selectedCategory(_ category: Category?, categoryType: Int) {
        if let category = category {
            changedCategory = category
        }
        else {
            changedCategory = nil
        }
        self.categoryType = categoryType
        tableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .none)
        
    }
    
    // MARK: Calendar View Delegate
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        changedDate = Helper.convertDateToString(date: dateComponents!.date ?? Date())
        tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
    }
    
    // MARK: TableView Style
    
    convenience init(editRecord: Record?) {
        self.init(style: .insetGrouped)
        self.editRecord = editRecord
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Alert
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if editRecord != nil {
            navigationItem.title = "Edit Record"
        }
        else {
            navigationItem.title = "Add Record"
        }
    }
    
}

