//
//  RecordVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class RecordVC: UITableViewController, SelectionDelegate, UICalendarSelectionSingleDateDelegate, CategoryDelegate {
    
    private var changedCategory: Category?
    private var currentType: String = Helper.defaultType
    private var previousType: String?
    private var changedDate: String?
    private var isRowExpanded: Bool = false
    private var isTypeChanged: Bool = false
    private var amount: Double = 0
    private var date = ""
    
    private lazy var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.calendar = gregorianCalendar
        calendarView.layer.cornerRadius = 10.0
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemGroupedBackground
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.sectionHeaderHeight = 44
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addRecord))
        navigationController?.navigationBar.prefersLargeTitles = true
        registerCustomCells()
        tableView.allowsSelection = true
    }
    
    // MARK: Validation
    
    @objc func addRecord() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CustomTextFieldCell
        amount = Double(cell.getEnteredData()) ?? 0
        
        guard amount > 0 else {

            showAlert(text: "Please enter amount")
            return
        }
        
        guard changedCategory != nil else {
            showAlert(text: "Please select a category")
            return
        }
        
        if RecordDataManager.shared.createRecord(type: currentType, amount: amount, createdDate: changedDate ?? Helper.convertDateToString(date: Helper.defaultDate), category: changedCategory!) {
            let alert = UIAlertController(title: "", message: "Record added", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
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
            
            configuration.text = currentType
            
            
            cell.contentConfiguration = configuration
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
        case .amount:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTextFieldCell.reuseIdentifier, for: indexPath) as! CustomTextFieldCell
            
            cell.configureNumberKeyBoard()
            return cell
            
        case .date:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarLabel", for: indexPath)
                var configuration  = cell.defaultContentConfiguration()
                
                if changedDate != nil && changedDate != date {
                    configuration.text = changedDate!
                }
                else {
                    configuration.text = "\(Helper.convertDateToString(date: Helper.defaultDate))"+" "+"(Today's Date)"
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
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomDisClosureCellWithImage.reuseIdentifier, for: indexPath) as! CustomDisClosureCellWithImage
            
            if changedCategory != nil {
                cell.configure(with: changedCategory!.sfSymbolName, and: changedCategory!.categoryName)
            }
            else {
                cell.configure(with: "", and: "Select a Category")
            }
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let indexPathValue = RecordField.allCases[indexPath.section]
        switch indexPathValue {
        case .type:
            let typeVC = TypeVC(selectedType: currentType )
            typeVC.title = "Type"
            typeVC.selectionDelegate = self
            isTypeChanged.toggle()
            navigationController?.pushViewController(typeVC, animated: true)
        case .amount:
            print("")
        case .category:
            let categoryListVC = CategoriesListVC(selectedCategory: changedCategory, type: currentType)
            categoryListVC.title = "Category"
            categoryListVC.categoryDelegate = self
            navigationController?.pushViewController(categoryListVC, animated: true)
        case .date:
            isRowExpanded.toggle()
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderFooterView.reuseIdentifier) as! CustomHeaderFooterView
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
        if previousType != currentType {
            tableView.reloadData()
            changedCategory = nil
        }
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    // MARK: Category Delegate
    
    func selectedCategory(_ category: Category) {
        changedCategory = category
        tableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .none)
    }
    
    // MARK: Calendar View Delegate
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        changedDate = Helper.convertDateToString(date: dateComponents!.date!)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
    }
    
    // MARK: TableView Style
    
    init() {
        super.init(style: .insetGrouped)
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
    
}
