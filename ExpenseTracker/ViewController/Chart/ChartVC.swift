//
//  PieChartVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 28/05/23.
//

import UIKit

class ChartVC: UIViewController, UISearchResultsUpdating, UIGestureRecognizerDelegate {
    
    private lazy var isMonthViewExpanded: Bool = true

    private lazy var selectedMonth: Int! = nil
    
    private lazy var selectedYear: Int! = nil
    
    private lazy var collectionViewDatasource: [(String, Int)] = Helper.dataSource
    
    private lazy var selectedSegmentIndex = Int()
    
    private lazy var savedYear = Int()
    
    private lazy var unAvailableMonths = [(String, Int)]()
    
    private lazy var records: [Record] = RecordDataManager.shared.getAllRecordForAMonth(month: Helper.defaultMonth, year: Helper.defaultYear)

    private lazy var chartRecords = [ChartData]()
    
    private lazy var pieChartSearchResultsController = PieChartSearchResultsController()
    
    private lazy var type = Int16()
    
    private lazy var savedMonth = Int()
    
    private lazy var overlayBlurEffect: UIView = {
        let overlayBlurEffect = UIView()
        overlayBlurEffect.translatesAutoresizingMaskIntoConstraints = false
        overlayBlurEffect.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayBlurEffect.isUserInteractionEnabled = true
        return overlayBlurEffect
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Expense", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Income", at: 1, animated: true)
        segmentedControl.addTarget(self, action: #selector(switchSegmentedControl), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: pieChartSearchResultsController)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private lazy var expenseChartVC: ExpensePieChartVC = {
        let expenseChartVC = ExpensePieChartVC()
        return expenseChartVC
    }()
    
    private lazy var incomeChartVC: IncomePieChartVC = {
        let incomeChartVC = IncomePieChartVC()
        return incomeChartVC
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
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
        monthAccessoryView.image = UIImage(systemName: "arrowtriangle.down.fill")
        monthAccessoryView.tintColor = .label
        return  monthAccessoryView
    }()
    
    private lazy var clickableView: UIView = {
       let clickableView = UIView(frame: CGRect(x: 4, y: 15, width: 150, height: 50))
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
    
    @objc func didTapMonthView() {
        if isMonthViewExpanded {
            view.addSubview(overlayBlurEffect)
            navigationItem.title = nil
            navigationController?.navigationBar.prefersLargeTitles = false
            UIView.transition(with: monthVc, duration: 0.4, options: .transitionFlipFromTop, animations: nil, completion: nil)
            view.addSubview(monthVc)
            setupContentViewConstraints()
            navigationItem.searchController = nil
            monthAccessoryView.image = UIImage(systemName: "arrowtriangle.up.fill")
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
            monthVc.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            overlayBlurEffect.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            overlayBlurEffect.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayBlurEffect.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayBlurEffect.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func closeMonthView() {
        monthAccessoryView.image = UIImage(systemName: "arrowtriangle.down.fill")
        UIView.transition(with: monthVc, duration: 0.6, options: .curveEaseInOut, animations: {
        }) { [self] _  in
            overlayBlurEffect.removeFromSuperview()
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = "Chart"
            monthVc.removeFromSuperview()
            navigationItem.searchController = searchController
            isMonthViewExpanded = true
            configureDataSource()
            switchSegmentedControl()
        }
    }
    
    func selectedMonth(_ month: (name: String, number: Int), year: Int) {
        selectedMonth = month.number
        selectedYear = year
        monthLabel.text = month.name
        UserDefaultManager.shared.addUserDefaultObject("selectedDate", SelectedDate(selectedYear: selectedYear, selectedMonth: selectedMonth))
        closeMonthView()
        switchSegmentedControl()
        configureDataSource()
    }
    
    func changedYear(_ changedYear: Int, _ month: Int) {
        UserDefaultManager.shared.addUserDefaultObject("selectedDate", SelectedDate(selectedYear: changedYear, selectedMonth: month))
        savedYear = changedYear
        monthVc.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(segmentedControl)
        view.addSubview(containerView)
        navigationItem.titleView = monthView
        navigationItem.searchController = searchController
        setupConstraints()
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
        switchSegmentedControl()
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
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.heightAnchor.constraint(equalToConstant: 44),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            monthLabel.topAnchor.constraint(equalTo: monthView.topAnchor, constant: -6),
            monthLabel.bottomAnchor.constraint(equalTo: monthView.bottomAnchor),
            monthLabel.leadingAnchor.constraint(equalTo: monthView.leadingAnchor, constant: -6),
            monthLabel.trailingAnchor.constraint(equalTo: monthView.trailingAnchor, constant: -8),
            
            monthAccessoryView.heightAnchor.constraint(equalToConstant: 12),
            monthAccessoryView.centerYAnchor.constraint(equalTo: monthView.centerYAnchor, constant: 10),
        ])
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            segmentedControl.selectedSegmentIndex = 1
        } else if gesture.direction == .right {
            segmentedControl.selectedSegmentIndex = 0
        }
        switchSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Chart"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureDataSource()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        closeMonthView()
    }
    
    @objc func switchSegmentedControl() {
        selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        
        if let currentChildViewController = children.first {
            currentChildViewController.willMove(toParent: nil)
            currentChildViewController.view.removeFromSuperview()
            currentChildViewController.removeFromParent()
        }
        
        var selectedChildViewController: UIViewController?
        
        switch selectedSegmentIndex {
        case 0:
            selectedChildViewController = expenseChartVC
        case 1:
            selectedChildViewController = incomeChartVC
        default:
            break
        }
        
        if let selectedChildViewController = selectedChildViewController {
            addChild(selectedChildViewController)
            containerView.addSubview(selectedChildViewController.view)
            selectedChildViewController.view.frame = containerView.bounds
            selectedChildViewController.didMove(toParent: self)
        }
    }
}

extension ChartVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        var isCurrentYear = false
        if savedYear == Helper.defaultYear {
            unAvailableMonths = Helper.getUnAvailableMonths(Helper.defaultMonth)
            isCurrentYear = true
        }
        if indexPath.section == 0 {
            cell.capsuleView.backgroundColor = (savedMonth == collectionViewDatasource[indexPath.row ].1) ? UIColor.systemBlue.withAlphaComponent(0.2) : .secondarySystemGroupedBackground
            cell.configure(collectionViewDatasource[indexPath.row].0)
            if isCurrentYear && (unAvailableMonths[indexPath.row].1 == collectionViewDatasource[indexPath.row ].1) {
                cell.capsuleView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
                cell.fadeLabel()
            }
        }
        else if indexPath.section == 1 {
            cell.capsuleView.backgroundColor = (savedMonth == collectionViewDatasource[indexPath.row + 4].1) ? UIColor.systemBlue.withAlphaComponent(0.2) : .secondarySystemGroupedBackground
            cell.configure(collectionViewDatasource[indexPath.row + 4].0)
            if isCurrentYear && (unAvailableMonths[indexPath.row + 4].1 == collectionViewDatasource[indexPath.row + 4].1) {
                cell.capsuleView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
                cell.fadeLabel()
            }
        }
        else {
            cell.capsuleView.backgroundColor = (savedMonth == collectionViewDatasource[indexPath.row + 8].1) ? UIColor.systemBlue.withAlphaComponent(0.2) : .secondarySystemGroupedBackground
            cell.configure(collectionViewDatasource[indexPath.row + 8].0)
            if isCurrentYear && (unAvailableMonths[indexPath.row + 8].1 == collectionViewDatasource[indexPath.row + 8].1) {
                cell.capsuleView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
                cell.fadeLabel()
            }
        }
        isCurrentYear = false
        cell.layer.shadowColor = UIColor.systemGray.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 4
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var isCurrentYear = false
        if savedYear == Helper.defaultYear {
            unAvailableMonths = Helper.getUnAvailableMonths(Helper.defaultMonth)
            isCurrentYear = true
        }
        if indexPath.section == 0 {
            if !(isCurrentYear && (unAvailableMonths[indexPath.row].1 == collectionViewDatasource[indexPath.row].1)) {
                selectedMonth((name: collectionViewDatasource[indexPath.row].0 , number: collectionViewDatasource[indexPath.row].1), year: getYear())
            }
        }
        else if indexPath.section == 1 {
            if !(isCurrentYear && (unAvailableMonths[indexPath.row + 4].1 == collectionViewDatasource[indexPath.row + 4].1)) {
                selectedMonth((name: collectionViewDatasource[indexPath.row + 4].0 , number: collectionViewDatasource[indexPath.row + 4].1), year: getYear())
            }
        }
        else if indexPath.section == 2 {
            if !(isCurrentYear && (unAvailableMonths[indexPath.row + 8].1 == collectionViewDatasource[indexPath.row + 8].1)) {
                selectedMonth((name: collectionViewDatasource[indexPath.row + 8].0 , number: collectionViewDatasource[indexPath.row + 8].1), year: getYear())
            }
        }
        monthVc.collectionView.reloadData()
    }

    @objc func backwardChevronTapped() {
        let value = Int(monthVc.yearLabel.text ?? "0") ?? 0
        monthVc.yearLabel.text = (value > 0) ? "\(value - 1)" : "0"
        changedYear(value - 1, Helper.getMonthNumberForName(monthLabel.text ?? "") ?? 1)
    }

    @objc func forwardChevronTapped() {
        let value = Int(monthVc.yearLabel.text ?? "0") ?? 0
        if !(Helper.defaultYear == value) {
            monthVc.yearLabel.text = "\(value + 1)"
            changedYear(value + 1, Helper.getMonthNumberForName(monthLabel.text ?? "") ?? 1)
        }
    }

    private func getYear() -> Int {
        Int(monthVc.yearLabel.text ?? "") ?? 0
    }
}

extension ChartVC {
    func updateSearchResults(for searchController: UISearchController) {
        configureDataSource()
        guard let text = searchController.searchBar.text else {
            return
        }
        let searchResults = chartRecords.filter{ chartData in
            let percentage = String(format: "%.2f", chartData.percentage) + "%"
            return chartData.name.localizedCaseInsensitiveContains(text) || percentage.localizedCaseInsensitiveContains(text)
        }
        pieChartSearchResultsController.updateSearchResults(searchResults: searchResults, text, type )
    }
    
    func configureDataSource() {
        if let savedYearAndMonth = UserDefaultManager.shared.getUserDefaultObject(for: "selectedDate", SelectedDate.self) {
            records = RecordDataManager.shared.getAllRecordForAMonth(month: savedYearAndMonth.selectedMonth, year: savedYearAndMonth.selectedYear)
            monthLabel.text = "\(Helper.dataSource[savedYearAndMonth.selectedMonth - 1].0)"
            savedMonth = savedYearAndMonth.selectedMonth
            savedYear = savedYearAndMonth.selectedYear
            monthVc.yearLabel.text = "\(savedYear)"
        }
        else {
            records = RecordDataManager.shared.getAllRecordForAMonth(month: Helper.defaultMonth, year: Helper.defaultYear)
        }
        type = (selectedSegmentIndex == 0) ? 1 : 0
        chartRecords = Helper.getChartData(records, type: Int16(type))
        
        chartRecords = chartRecords.sorted (by: {
            $0.percentage > $1.percentage
        })
        monthVc.collectionView.reloadData()
    }
    
}

