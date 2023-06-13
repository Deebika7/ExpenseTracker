//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, PresentationModalSheetDelegate, UISearchResultsUpdating, UIGestureRecognizerDelegate {
    
    private lazy var recordSearchResultsController = RecordSearchResultsController()
    
    struct SectionData {
        let date: Date
        var rows: [Record]
    }
    
    var datasource = [SectionData]()
    
    private lazy var collectionViewDatasource: [(String, Int)] = Helper.dataSource
    
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
    
    private lazy var clickableView: UIView = {
       let clickableView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        clickableView.addGestureRecognizer(monthViewTapGestureRecognizer)
        clickableView.backgroundColor = .clear
        return clickableView
    }()

    private lazy var monthView: UIView = {
        let monthView = UIView()
        monthView.translatesAutoresizingMaskIntoConstraints = false
        monthView.addSubview(clickableView)
        clickableView.center = monthView.center
        monthView.addSubview(monthLabel)
        monthView.addSubview(monthAccessoryView)
        monthView.bringSubviewToFront(clickableView)
        return monthView
    }()

    private lazy var monthViewTapGestureRecognizer: UITapGestureRecognizer = {
        let monthViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMonthView))
        return monthViewTapGestureRecognizer
    }()

    private lazy var monthVc: MonthCollectionVC = {
        let monthVc = MonthCollectionVC.init()
        monthVc.translatesAutoresizingMaskIntoConstraints = false
        monthVc.configureView()
        monthVc.collectionView.dataSource = self
        monthVc.collectionView.delegate = self
        monthVc.forwardChevron.addTarget(self, action: #selector(forwardChevronTapped), for: .touchUpInside)
        monthVc.backwardChevron.addTarget(self, action: #selector(backwardChevronTapped), for: .touchUpInside)
        return monthVc
    }()
    
    private lazy var add: UIBarButtonItem = {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecord))
        return add
    }()
    
    private lazy var sort: UIBarButtonItem = {
        let sort = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: setupMenu() )
        return sort
    }()
    
    func getSectionSortOption() -> SectionSortOption {
        return UserDefaultManager.shared.getSavedSectionSortOptions() ?? .newestFirst
    }
    
    func getRowSortOption() -> RowSortOption {
        return UserDefaultManager.shared.getSavedRowSortOption() ?? .income(.amountHighToLow)
    }
    
    func sectionSortOptionChanged(to option: SectionSortOption) {
        UserDefaultManager.shared.saveSectionSortOptions(option)
        refreshTable()
    }
    
    func rowSortOptionChanged(to option: RowSortOption) {
        UserDefaultManager.shared.saveRowSortOption(option)
        refreshTable()
    }
    
    func setupMenu() -> UIMenu {
        
        let groupOptionMenuElement = UIDeferredMenuElement.uncached { completion in
            let sortByDate = self.getSectionSortOption()

            let newestFirst = UIAction(title: "Newest First", state: sortByDate == .newestFirst ? .on : .off, handler: {
                _ in
                self.sectionSortOptionChanged(to: .newestFirst)
            })
            
            let oldestFirst = UIAction(title: "Oldest First", state: sortByDate == .oldestFirst ? .on : .off, handler: {
                _ in
                self.sectionSortOptionChanged(to: .oldestFirst)
            })
            
            DispatchQueue.main.async {
                completion([newestFirst, oldestFirst])
            }
        }
        
        let sortOptionMenuElement = UIDeferredMenuElement.uncached { completion in
            var incomeState: UIMenuElement.State = .off
            var expenseState: UIMenuElement.State = .off
            let sortOption = self.getRowSortOption()

            switch sortOption {
            case .income(_):
                incomeState = .on
            case .expense(_):
                expenseState = .on
            }
            
            let income = UIAction(title: "Income", state: incomeState,  handler: { _ in
                self.rowSortOptionChanged(to: .income(.amountHighToLow))
            })
            
            let expense = UIAction(title: "Expense", state: expenseState, handler: { _ in
                self.rowSortOptionChanged(to: .expense(.amountHighToLow))
            })
            
            var children = [UIMenuElement]()
            
            let currentSortSettings = self.getRowSortOption()
            
            switch currentSortSettings {
            case .expense(let sortByAmount), .income(let sortByAmount):
                let amountLowToHigh = UIAction(title: "Amount Low To High",state: sortByAmount == .amountLowToHigh ? .on : .off, handler: { _ in
                    if case RowSortOption.expense(_) = currentSortSettings {
                        self.rowSortOptionChanged(to: .expense(.amountLowToHigh))
                    } else {
                        self.rowSortOptionChanged(to: .income(.amountLowToHigh))
                    }
                })
                
                let amountHighToLow = UIAction(title: "Amount High To Low",state: sortByAmount == .amountHighToLow ? .on : .off, handler: { _ in
                    if case RowSortOption.expense(_) = currentSortSettings {
                        self.rowSortOptionChanged(to: .expense(.amountHighToLow))
                    } else {
                        self.rowSortOptionChanged(to: .income(.amountHighToLow))
                    }
                })
                
                children.append(contentsOf: [amountLowToHigh, amountHighToLow])
            }
            
            let rowSortMenu = UIMenu(options: [.displayInline], children: [income, expense])
            let rowSortByMenu = UIMenu(options: [.displayInline], children:children)
            
            let sortMenu = UIMenu(title: "Sort By", subtitle: incomeState == .on ? "Income" : "Expense", image: UIImage(systemName: "arrow.up.arrow.down"), children: [rowSortMenu, rowSortByMenu])
            
            DispatchQueue.main.async {
                completion([sortMenu])
            }
        }

        let sortBy = UIMenu(title: "Group By Date", children: [groupOptionMenuElement, sortOptionMenuElement])
        return sortBy
    }
    
    private lazy var sortMenu: UIMenu = {
        let sortMenu = UIMenu(title: "Sort By", image: UIImage(systemName: "arrow.up.arrow.down"), children: [])
        return sortMenu
    }()
    
    func configureDatasource(with month: Int = Helper.defaultYear, and year: Int = Helper.defaultMonth) {
        let records = RecordDataManager.shared.getAllRecordByMonth(month: month, year: year)
        datasource = records.map({ SectionData(date: $0.key, rows: $0.value) })
        sortDatasource()
    }
    
    @objc func didTapMonthView() {
        if isMonthViewExpanded {
            UIView.transition(with: monthVc, duration: 0.4, options: .transitionCrossDissolve, animations: nil, completion: nil)
            view.addSubview(monthVc)
            setupContentViewConstraints()
            navigationItem.searchController = nil
            monthAccessoryView.image = UIImage(systemName: "arrowtriangle.down.fill")
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
            monthVc.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -5),
            monthVc.heightAnchor.constraint(equalToConstant: 300),
            monthVc.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monthVc.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func closeMonthView() {
        monthAccessoryView.image = UIImage(systemName: "arrowtriangle.up.fill")
        UIView.transition(with: monthVc, duration: 0.6, options: .transitionCrossDissolve, animations: {
        }) { [self] _  in
            monthVc.removeFromSuperview()
            navigationItem.searchController = searchController
            isMonthViewExpanded = true
        }
    }
    
    func selectedMonth(_ month: (name: String, number: Int), year: Int) {
        selectedMonth = month.number
        selectedYear = year
        monthLabel.text = month.name
        UserDefaultManager.shared.addUserDefaultObject("selectedDateForRecord", SelectedDate(selectedYear: selectedYear, selectedMonth: selectedMonth))
        refreshTable()
        closeMonthView()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.rightBarButtonItems = [sort, add]
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
        configureDatasource()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HomeCell")
        tableView.register(MoneyTrackerSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MoneyTrackerSectionHeaderView.reuseIdentifier)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissChildVC))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchLocation = touch.location(in: self.view)
        if monthVc.bounds.contains(touchLocation) {
            return false
        }
        return true
    }
    
    func sortDatasource() {
        let sectionSortOption = UserDefaultManager.shared.getSavedSectionSortOptions() ?? .newestFirst
        let rowSortOption = UserDefaultManager.shared.getSavedRowSortOption() ?? .income(.amountHighToLow)
        
        if sectionSortOption == .newestFirst {
            datasource = datasource.sorted(by: { $0.date > $1.date })
        } else {
            datasource = datasource.sorted(by: { $0.date < $1.date })
        }
        
        switch rowSortOption {
        case .expense(let sortByAmount):
            if case .amountHighToLow = sortByAmount {
                for i in 0..<datasource.count {
                    let splitDict = Dictionary(grouping: datasource[i].rows, by: { $0.recordType })
                    let expenseArr = splitDict[.expense]?.sorted(by: { Double($0.amount!)! > Double($1.amount!)! }) ?? []
                    let incomeArr = splitDict[.income]?.sorted(by: { Double($0.amount!)! > Double($1.amount!)! }) ?? []
                    datasource[i].rows = expenseArr + incomeArr
                }
            }
            else {
                for i in 0..<datasource.count {
                    let splitDict = Dictionary(grouping: datasource[i].rows, by: { $0.recordType })
                    let expenseArr = splitDict[.expense]?.sorted(by: { Double($0.amount!)! < Double($1.amount!)! }) ?? []
                    let incomeArr = splitDict[.income]?.sorted(by: { Double($0.amount!)! < Double($1.amount!)! }) ?? []
                    datasource[i].rows = expenseArr + incomeArr
                }
            }
        case.income(let sortByAmount):
            if case .amountHighToLow = sortByAmount {
                for i in 0..<datasource.count {
                    let splitDict = Dictionary(grouping: datasource[i].rows, by: { $0.recordType })
                    let expenseArr = splitDict[.expense]?.sorted(by: { Double($0.amount!)! > Double($1.amount!)! }) ?? []
                    let incomeArr = splitDict[.income]?.sorted(by: { Double($0.amount!)! > Double($1.amount!)! }) ?? []
                    datasource[i].rows = incomeArr + expenseArr
                }
            }
            else {
                for i in 0..<datasource.count {
                    let splitDict = Dictionary(grouping: datasource[i].rows, by: { $0.recordType })
                    let expenseArr = splitDict[.expense]?.sorted(by: { Double($0.amount!)! < Double($1.amount!)! }) ?? []
                    let incomeArr = splitDict[.income]?.sorted(by: { Double($0.amount!)! < Double($1.amount!)! }) ?? []
                    datasource[i].rows = incomeArr + expenseArr
                }
            }
        }
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
        datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: MoneyTrackerSectionHeaderView.reuseIdentifier) as! MoneyTrackerSectionHeaderView
        let sectionData = datasource[section]
        let incomeAmount = Helper.getSimplifiedAmount(sectionData.rows, 0)
        let expenseAmount = Helper.getSimplifiedAmount(sectionData.rows, 1)
        cell.configure(date: sectionData.date, incomeAmount: incomeAmount , expenseAmount: expenseAmount)
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
        if let savedYearAndMonth = UserDefaultManager.shared.getUserDefaultObject(for: "selectedDateForRecord", SelectedDate.self) {
            configureDatasource(with: savedYearAndMonth.selectedMonth, and: savedYearAndMonth.selectedYear)
            monthLabel.text = "\(Helper.dataSource[savedYearAndMonth.selectedMonth - 1].0)"
        }
        else {
            configureDatasource()
        }
        let recordForAMonth = datasource.flatMap({ $0.rows })
        let incomeAmountValue = Helper.getSimplifiedAmount(recordForAMonth, 0)
        let expenseAmountValue = Helper.getSimplifiedAmount(recordForAMonth, 1)
        incomeAmount.text = incomeAmountValue
        expenseAmount.text = expenseAmountValue
        balanceAmount.text = Helper.simplifyDifferenceBetweenNumbers(Helper.getRecordAmount(recordForAMonth, 1), Helper.getRecordAmount(recordForAMonth, 0), 3)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        let record = datasource[indexPath.section].rows[indexPath.row]
        var configuration = UIListContentConfiguration.valueCell()
        configuration.text = record.category
        let simplifiedAmount = Helper.simplifyNumbers([record.amount!], 3)
        configuration.secondaryText = (record.type != 0) ? "-\(simplifiedAmount)" : "\(simplifiedAmount)"
        configuration.image = UIImage(systemName: record.icon!)
        configuration.imageProperties.tintColor = .label
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let record = datasource[indexPath.section].rows[indexPath.row]
        let decriptionVc = DescriptionVC(recordId: record.id!)
        decriptionVc.title = "Details"
        decriptionVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(decriptionVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].rows.count
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

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        if indexPath.section == 0 {
            cell.configure(collectionViewDatasource[indexPath.row].0)
        }
        else if indexPath.section == 1 {
            cell.configure(collectionViewDatasource[indexPath.row + 4].0)
        }
        else{
            cell.configure(collectionViewDatasource[indexPath.row + 8].0)
        }
        cell.layer.shadowColor = UIColor.systemGray.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 4
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 {
            selectedMonth((name: collectionViewDatasource[indexPath.row].0 , number: collectionViewDatasource[indexPath.row].1), year: getYear())
        }
        else if indexPath.section == 1 {
            selectedMonth((name: collectionViewDatasource[indexPath.row + 4].0 , number: collectionViewDatasource[indexPath.row + 4].1), year: getYear())
        }
        else if indexPath.section == 2 {
            selectedMonth((name: collectionViewDatasource[indexPath.row + 8].0 , number: collectionViewDatasource[indexPath.row + 8].1), year: getYear())
        }
    }

    @objc func backwardChevronTapped() {
        let value = Int(monthVc.yearLabel.text ?? "0")!
        monthVc.yearLabel.text = (value > 0) ? "\(value - 1)" : "0"
        refreshTable()
    }

    @objc func forwardChevronTapped() {
        let value = Int(monthVc.yearLabel.text ?? "0")!
        monthVc.yearLabel.text = "\(value + 1)"
        refreshTable()
    }

    private func getYear() -> Int {
        Int(monthVc.yearLabel.text!) ?? 0
    }
}
