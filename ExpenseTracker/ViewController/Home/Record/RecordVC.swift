//
//  RecordVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class RecordVC: UITableViewController, SelectionDelegate, UICalendarSelectionSingleDateDelegate {
    
    private var changedCategory: Category?
    private var changedType: String?
    private var changedDate: String?
    private var isRowExpanded: Bool = false
    private var amount: Double = 0
    private var date = ""
    private var categoryName = ""
    
    private lazy var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.calendar = gregorianCalendar
        calendarView.backgroundColor = .systemBackground
        calendarView.layer.cornerRadius = 10.0
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .secondarySystemBackground
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.sectionHeaderHeight = 44
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addRecord))
        navigationController?.navigationBar.prefersLargeTitles = true
        registerCustomCells()
        tableView.allowsSelection = true

    }
    
    // MARK: Validation
    @objc func addRecord() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
         print("amount \(amount)")
    }
    
    // MARK: TableView Cells
    private func registerCustomCells() {
        tableView.register(CustomTextFieldCell.self, forCellReuseIdentifier: CustomTextFieldCell.reuseIdentifier)
        tableView.register(CustomDisClosureCell.self, forCellReuseIdentifier: CustomDisClosureCell.reuseIdentifier)
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderFooterView.reuseIdentifier)
        tableView.register(CustomDisClosureCellWithImage.self, forCellReuseIdentifier: CustomDisClosureCellWithImage.reuseIdentifier)
        tableView.register(CustomDateCell.self, forCellReuseIdentifier: CustomDateCell.reuseIdentifier )
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CalendarView")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let indexPathValue = RecordField.allCases[indexPath.section]
        switch indexPathValue {
        case .type:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomDisClosureCell.reuseIdentifier, for: indexPath) as! CustomDisClosureCell
            if changedType != nil {
                cell.configureCustomdisclosureCell(changedType!)
            }
            else {
                cell.configureCustomdisclosureCell("Income")
            }
            
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .systemBackground
            
            return cell
            
        case .amount:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTextFieldCell.reuseIdentifier, for: indexPath) as! CustomTextFieldCell
            
            amount = cell.configureNumberKeyBoard() ?? 0
            cell.backgroundColor = .systemBackground
            
            return cell
            
        case .date:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CustomDateCell.reuseIdentifier, for: indexPath) as! CustomDateCell
                cell.backgroundColor = .systemBackground
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                date = dateFormatter.string(from: Date())
                
                if changedDate != nil && changedDate != date {
                    cell.configureCustomDateCell(changedDate!)
                }
                else {
                    cell.configureCustomDateCell("\(date)"+" "+"(Today's Date)")
                }
                
                if !isRowExpanded {
                    let calendarImage = UIImage(systemName: "calendar.badge.plus")
                    cell.accessoryView = UIImageView(image: calendarImage)
                    cell.accessoryView?.tintColor = .label
                }
                else {
                    let calendarImage = UIImage(systemName: "calendar.badge.minus")
                    cell.accessoryView = UIImageView(image: calendarImage)
                    cell.accessoryView?.tintColor = .label
                }
                
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
                
                cell.backgroundColor = .systemBackground
                
                return cell
            }
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomDisClosureCellWithImage.reuseIdentifier, for: indexPath) as! CustomDisClosureCellWithImage
            
            if changedCategory != nil {
               categoryName = cell.configure(with: changedCategory!.sfSymbolName, and: changedCategory!.categoryName)
            }
            else {
               categoryName = cell.configure(with: "fork.knife", and: "food")
            }
            
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .systemBackground
            
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
            let typeVC = TypeVC()
            typeVC.title = "Type"
            typeVC.selectionDelegate = self
            navigationController?.pushViewController(typeVC, animated: true)
        case .category:
            let categoryListVC = CategoriesListVC(selectedCategory: changedCategory ?? Category(sfSymbolName: "fork.knife", categoryName: "food"))
            categoryListVC.title = "Category"
            categoryListVC.selectionDelegate = self
            navigationController?.pushViewController(categoryListVC, animated: true)
        case .date:
            isRowExpanded = !isRowExpanded
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
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
        if isRowExpanded  && section == 2 {
            return 2
        }
        return  1
    }
    
    // MARK: Selection Delegate
    
    func selectedType(_ text: String) {
        changedType = text
        tableView.reloadData()
    }
    
    func selectedCategory(_ category: Category) {
        changedCategory = category
        tableView.reloadData()
    }
    
    // MARK: Calendar View Delegate
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        changedDate = dateFormatter.string(from: dateComponents!.date!)
        tableView.reloadData()
    }
    
    // MARK: TableView Style
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
