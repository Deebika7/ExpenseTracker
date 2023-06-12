//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MonthSelectionDelegate, PresentationModalSheetDelegate, UISearchResultsUpdating, UIGestureRecognizerDelegate {
    
    private lazy var recordSearchResultsController = RecordSearchResultsController()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: recordSearchResultsController)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private lazy var selectedMonth: Int! = nil
    
    private lazy var selectedYear: Int! = nil
    
    private lazy var records = RecordDataManager.shared.getAllRecordByMonth(month: Helper.defaultYear, year: Helper.defaultMonth)
    
    private lazy var recordForAMonth = RecordDataManager.shared.getAllRecordForAMonth(month: Helper.defaultYear, year: Helper.defaultMonth)
    
    private lazy var isMonthViewExpanded: Bool = true
    
    private lazy var blueView: UIView = {
        let blueView = UIView()
        blueView.translatesAutoresizingMaskIntoConstraints = false
        blueView.backgroundColor = UIColor(named: "blue")
        blueView.layer.cornerRadius = 13
        return blueView
    }()
    
    private lazy var balanceView: UIView = {
        let balanceView = UIView()
        balanceView.backgroundColor = .white
        balanceView.translatesAutoresizingMaskIntoConstraints = false
        balanceView.layer.cornerRadius = 5
        return balanceView
    }()
    
    private lazy var redView: UIView = {
        let redView = UIView()
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.backgroundColor = UIColor(named: "red")
        redView.layer.cornerRadius = 13
        return redView
    }()
    
    private lazy var toolTipView: UIView = {
        let toolTipView = UIView()
        toolTipView.translatesAutoresizingMaskIntoConstraints = false
        toolTipView.backgroundColor = .white
        toolTipView.transform = CGAffineTransform(rotationAngle: 180)
        return toolTipView
    }()
    
    private lazy var mediocreExpenseView: MediocreExpenseView = {
        let mediocreExpenseView = MediocreExpenseView()
        mediocreExpenseView.translatesAutoresizingMaskIntoConstraints = false
        mediocreExpenseView.backgroundColor = .clear
        return mediocreExpenseView
    }()
    
    
    
    private lazy var expenseLabel: UILabel = {
        let expenseLabel = UILabel()
        expenseLabel.translatesAutoresizingMaskIntoConstraints = false
        expenseLabel.textColor = .white
        expenseLabel.text = "Expenses"
        return expenseLabel
    }()
    
    private lazy var incomeLabel: UILabel = {
        let incomeLabel = UILabel()
        incomeLabel.translatesAutoresizingMaskIntoConstraints = false
        incomeLabel.textColor = .white
        incomeLabel.text = "Income"
        return incomeLabel
    }()
    
    private lazy var balanceLabel: UILabel = {
        let balanceLabel = UILabel()
        balanceLabel.text = "Balance"
        balanceLabel.textColor = .gray
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        return balanceLabel
    }()
    
    private lazy var balanceAmount: UILabel = {
        let balanceAmount = UILabel()
        balanceAmount.translatesAutoresizingMaskIntoConstraints = false
        balanceAmount.textColor = .darkGray
        balanceAmount.textAlignment = .center
        return balanceAmount
    }()
    
    private lazy var expenseAmount: UILabel = {
        let expenseAmount = UILabel()
        expenseAmount.translatesAutoresizingMaskIntoConstraints = false
        expenseAmount.textColor = .white
        return expenseAmount
    }()
    
    private lazy var incomeAmount: UILabel = {
        let incomeAmount = UILabel()
        incomeAmount.translatesAutoresizingMaskIntoConstraints = false
        incomeAmount.textColor = .white
        return incomeAmount
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var monthLabel: UILabel = {
        let monthLabel = UILabel()
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.text = Helper.defaultMonthName
        return monthLabel
    }()
    
    private lazy var monthAccessoryView: UIImageView = {
        let monthAccessoryView = UIImageView()
        monthAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        monthAccessoryView.image = UIImage(systemName: "arrowtriangle.up.fill")
        monthAccessoryView.tintColor = .label
        return  monthAccessoryView
    }()

    private lazy var monthView: UIView = {
        let monthView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 60))
        monthView.translatesAutoresizingMaskIntoConstraints = false
        monthView.addSubview(monthLabel)
        monthView.addSubview(monthAccessoryView)
        monthView.addGestureRecognizer(monthViewTapGestureRecognizer)
        return monthView
    }()

    private lazy var monthViewTapGestureRecognizer: UITapGestureRecognizer = {
        let monthViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMonthView))
        return monthViewTapGestureRecognizer
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private lazy var monthVc: UIViewController = {
        let monthVc = MonthCollectionVC()
        monthVc.monthSelectionDelegate = self
        return monthVc
    }()
    
    private lazy var add: UIBarButtonItem = {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecord))
        return add
    }()
    
    private lazy var edit: UIBarButtonItem = {
        let edit = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecord))
        return edit
    }()
    
    @objc func didTapMonthView() {
        if isMonthViewExpanded {
            UIView.transition(with: containerView, duration: 0.4, options: .transitionFlipFromBottom, animations: nil, completion: nil)
            view.addSubview(containerView)
            setupContentViewConstraints()
            navigationItem.searchController = nil
            monthAccessoryView.image = UIImage(systemName: "arrowtriangle.down.fill")
            addChild(monthVc)
            containerView.addSubview(monthVc.view)
            monthVc.view.frame = containerView.bounds
            monthVc.didMove(toParent: self)
            isMonthViewExpanded = false
        }
        else {
            closeMonthView()
        }
    }
    
    @objc func dismissChildVC() {
        closeMonthView()
    }
    
    func setupContentViewConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            containerView.heightAnchor.constraint(equalToConstant: 250),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func closeMonthView() {
        monthAccessoryView.image = UIImage(systemName: "arrowtriangle.up.fill")
        UIView.transition(with: containerView, duration: 0.6, options: .autoreverse, animations: {
        }) { [self] _  in
            if let childViewController = children.first {
                childViewController.view.removeFromSuperview()
                childViewController.removeFromParent()
            }
            navigationItem.searchController = searchController
            isMonthViewExpanded = true
        }
    }
    
    func selectedMonth(_ month: (name: String, number: Int), year: Int) {
        selectedMonth = month.number
        selectedYear = year
        monthLabel.text = month.name
        UserDefaultManager.shared.addUserDefaultObject("selectedDate", SelectedDate(selectedYear: selectedYear, selectedMonth: selectedMonth))
        records = RecordDataManager.shared.getAllRecordByMonth(month: selectedMonth, year: selectedYear)
        refreshTable()
        closeMonthView()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.rightBarButtonItem =
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.titleView = monthView
    
        redView.addSubview(mediocreExpenseView)
        mediocreExpenseView.addSubview(blueView)
        blueView.addSubview(incomeLabel)
        blueView.addSubview(incomeAmount)
        redView.addSubview(mediocreExpenseView)
        redView.addSubview(expenseLabel)
        redView.addSubview(expenseAmount)
        redView.addSubview(balanceView)
        balanceView.addSubview(toolTipView)
        balanceView.addSubview(balanceLabel)
        balanceView.addSubview(balanceAmount)
        view.addSubview(redView)
        view.addSubview(tableView)
        setupContraints()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HomeCell")
        tableView.register(MoneyTrackerSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MoneyTrackerSectionHeaderView.reuseIdentifier)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissChildVC))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchLocation = touch.location(in: self.view)
        if containerView.bounds.contains(touchLocation) {
            return false
        }
        if monthVc.view.bounds.contains(touchLocation) {
            return false
        }
        return true
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            mediocreExpenseView.leadingAnchor.constraint(equalTo: redView.leadingAnchor),
            mediocreExpenseView.trailingAnchor.constraint(equalTo: redView.trailingAnchor),
            mediocreExpenseView.topAnchor.constraint(equalTo: redView.topAnchor),
            mediocreExpenseView.bottomAnchor.constraint(equalTo: redView.bottomAnchor),
            
            blueView.leadingAnchor.constraint(equalTo: mediocreExpenseView.leadingAnchor),
            blueView.trailingAnchor.constraint(equalTo: mediocreExpenseView.trailingAnchor),
            blueView.heightAnchor.constraint(equalToConstant: 120),
            
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            redView.heightAnchor.constraint(equalToConstant: 120),
            redView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            incomeLabel.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: 20),
            incomeLabel.centerYAnchor.constraint(equalTo: blueView.centerYAnchor, constant: -20),
            
            incomeAmount.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: 20),
            incomeAmount.centerYAnchor.constraint(equalTo: blueView.centerYAnchor, constant: 20),
            
            expenseLabel.centerYAnchor.constraint(equalTo: redView.centerYAnchor, constant: -20),
            expenseLabel.trailingAnchor.constraint(equalTo: redView.trailingAnchor, constant: -20),
            
            expenseAmount.centerYAnchor.constraint(equalTo: redView.centerYAnchor, constant: 20),
            expenseAmount.trailingAnchor.constraint(equalTo: redView.trailingAnchor, constant: -20),
            
            balanceView.heightAnchor.constraint(equalToConstant: 40),
            balanceView.leadingAnchor.constraint(equalTo: redView.leadingAnchor, constant: 135),
            balanceView.trailingAnchor.constraint(equalTo: redView.trailingAnchor, constant: -135),
            balanceView.centerXAnchor.constraint(equalTo: redView.centerXAnchor),
            balanceView.centerYAnchor.constraint(equalTo: redView.centerYAnchor,constant: 10),

            toolTipView.leadingAnchor.constraint(equalTo: balanceView.centerXAnchor, constant: -5),
            toolTipView.centerYAnchor.constraint(equalTo: balanceView.centerYAnchor, constant: -19),
            toolTipView.heightAnchor.constraint(equalToConstant: 6),
            toolTipView.widthAnchor.constraint(equalToConstant: 6),
            
            balanceLabel.centerXAnchor.constraint(equalTo: balanceView.centerXAnchor),
            
            balanceAmount.centerYAnchor.constraint(equalTo: balanceView.centerYAnchor, constant: 10),
            balanceAmount.centerXAnchor.constraint(equalTo: balanceView.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: redView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -4),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2),
            
            monthLabel.topAnchor.constraint(equalTo: monthView.topAnchor, constant: -6),
            monthLabel.bottomAnchor.constraint(equalTo: monthView.bottomAnchor),
            monthLabel.leadingAnchor.constraint(equalTo: monthView.leadingAnchor, constant: -6),
            monthLabel.trailingAnchor.constraint(equalTo: monthView.trailingAnchor, constant: -8),
            
            monthAccessoryView.heightAnchor.constraint(equalToConstant: 12),
            monthAccessoryView.centerYAnchor.constraint(equalTo: monthView.centerYAnchor, constant: 10),
        ])
    }
    
    @objc func addRecord() {
        closeMonthView()
        let recordVC = RecordVC(editRecord: nil)
        recordVC.presentationModalSheetDelegate = self
        let navigationController = UINavigationController(rootViewController: recordVC)
        navigationController.title = "Add Record"
        present(navigationController, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        records.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: MoneyTrackerSectionHeaderView.reuseIdentifier) as! MoneyTrackerSectionHeaderView
        let record = Array(records.keys)[section]
        if let record = records[record] {
            let incomeAmount = Helper.getSimplifiedAmount(record, 0)
            let expenseAmount = Helper.getSimplifiedAmount(record, 1)
            cell.configure(date: Array(records.keys)[section], incomeAmount: incomeAmount , expenseAmount: expenseAmount)
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                if let savedAppearance = UserDefaultManager.shared.getSelectedAppearance() {
                    window.overrideUserInterfaceStyle = savedAppearance
                }
                else {
                    window.overrideUserInterfaceStyle = UIUserInterfaceStyle.unspecified
                }
            }
        }
        refreshTable()
    }
    
    func dismissedPresentationModalSheet(_ isDismissed: Bool) {
        if isDismissed {
            refreshTable()
        }
    }
    
    func refreshTable() {
        if let savedYearAndMonth = UserDefaultManager.shared.getUserDefaultObject(for: "selectedDate", SelectedDate.self) {
            records = RecordDataManager.shared.getAllRecordByMonth(month: savedYearAndMonth.selectedMonth, year: savedYearAndMonth.selectedYear)
            recordForAMonth = RecordDataManager.shared.getAllRecordForAMonth(month: savedYearAndMonth.selectedMonth, year: savedYearAndMonth.selectedYear)
            monthLabel.text = "\(Helper.dataSource[savedYearAndMonth.selectedMonth - 1].0)"
        }
        else {
            records = RecordDataManager.shared.getAllRecordByMonth(month: Helper.defaultMonth, year: Helper.defaultYear)
            recordForAMonth = RecordDataManager.shared.getAllRecordForAMonth(month: Helper.defaultMonth, year: Helper.defaultYear)
        }
        let incomeAmountValue = Helper.getSimplifiedAmount(recordForAMonth, 0)
        let expenseAmountValue = Helper.getSimplifiedAmount(recordForAMonth, 1)
        incomeAmount.text = incomeAmountValue
        expenseAmount.text = expenseAmountValue
        balanceAmount.text = Helper.simplifyDifferenceBetweenNumbers(Helper.getRecordAmount(recordForAMonth, 1), Helper.getRecordAmount(recordForAMonth, 0), 3)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        let record = Array(records.keys)[indexPath.section]
        var configuration = cell.defaultContentConfiguration()
        if let recordItems = records[record] {
            configuration.text = recordItems[indexPath.row].category
            let simplifiedAmount = Helper.simplifyNumbers([recordItems[indexPath.row].amount!], 3)
            configuration.secondaryText = (recordItems[indexPath.row].type != 0) ? "-\(simplifiedAmount)" : "\(simplifiedAmount)"
            configuration.prefersSideBySideTextAndSecondaryText = true
            configuration.image = UIImage(systemName: recordItems[indexPath.row].icon!)
        }
        configuration.imageProperties.tintColor = .label
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recordItem = Array(records.keys)[indexPath.section]
        if let recordItems = records[recordItem]{
            let decriptionVc = DescriptionVC(recordId: recordItems[indexPath.row].id!)
            decriptionVc.title = "Details"
            decriptionVc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(decriptionVc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let recordItem = Array(records.keys)[section]
        return records[recordItem]?.count ?? 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        closeMonthView()
    }
    
    // MARK: search
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        let allRecords = RecordDataManager.shared.getAllRecord()
        let filteredRecord = allRecords.filter { record in
            let datePropeties = Helper.getDateProperties(date: record.date!)
            return record.category!.localizedCaseInsensitiveContains(text) || String(datePropeties.day).localizedCaseInsensitiveContains(text) || String(datePropeties.month).localizedCaseInsensitiveContains(text) || String(datePropeties.year).localizedCaseInsensitiveContains(text)
        }
        var recordByDate: [Date: [Record]] = [:]
        for record in filteredRecord {
            if recordByDate[record.date!] != nil {
                recordByDate[record.date!]?.append(record)
            }
            else {
                recordByDate[record.date!] = []
                recordByDate[record.date!]?.append(record)
            }
        }
        recordSearchResultsController.updateSearchResults(recordByDate, searchText: text)
    }
    
}


