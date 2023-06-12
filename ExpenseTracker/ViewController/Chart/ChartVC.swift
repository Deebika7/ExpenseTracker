//
//  PieChartVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 28/05/23.
//

import UIKit

class ChartVC: UIViewController, UISearchResultsUpdating, UIGestureRecognizerDelegate, MonthSelectionDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    private lazy var isMonthViewExpanded: Bool = true

    private lazy var selectedMonth: Int! = nil
    
    private lazy var selectedYear: Int! = nil
    
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
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private lazy var expenseChartVC: UIViewController = {
        let expenseChartVC = ExpensePieChartVC()
        return expenseChartVC
    }()
    
    private lazy var incomeChartVC: UIViewController = {
        let incomeChartVC = IncomePieChartVC()
        return incomeChartVC
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var monthContainerView: UIView = {
        let monthContainerView = UIView()
        monthContainerView.translatesAutoresizingMaskIntoConstraints = false
        return monthContainerView
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
    
    private lazy var monthVc: UIViewController = {
        let monthVc = MonthCollectionVC()
        monthVc.monthSelectionDelegate = self
        return monthVc
    }()
    
    @objc func didTapMonthView() {
        if isMonthViewExpanded {
            UIView.transition(with: containerView, duration: 0.4, options: .transitionFlipFromBottom, animations: nil, completion: nil)
            view.addSubview(monthContainerView)
            setupContentViewConstraints()
            navigationItem.searchController = nil
            navigationItem.title = nil
            monthAccessoryView.image = UIImage(systemName: "arrowtriangle.down.fill")
            addChild(monthVc)
            containerView.addSubview(monthVc.view)
            monthVc.view.frame = monthContainerView.bounds
            monthVc.didMove(toParent: self)
            isMonthViewExpanded = false
        }
        else {
            closeMonthView()
        }
    }
    
    func setupContentViewConstraints() {
        NSLayoutConstraint.activate([
            monthContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            monthContainerView.heightAnchor.constraint(equalToConstant: 300),
            monthContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monthContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc func dismissChildVC() {
        closeMonthView()
    }
    
    func closeMonthView() {
        monthAccessoryView.image = UIImage(systemName: "arrowtriangle.up.fill")
        UIView.transition(with: monthContainerView, duration: 0.3, options: .autoreverse, animations: {
        }) { [self] _  in
            if let childViewController = children.first(where: {
                $0 is MonthCollectionVC
            }) {
                childViewController.view.removeFromSuperview()
                childViewController.removeFromParent()
            }
            navigationItem.title = "Chart"
            navigationItem.searchController = searchController
            isMonthViewExpanded = true
        }
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
        view.addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchLocation = touch.location(in: self.view)
        if monthContainerView.bounds.contains(touchLocation) {
            return false
        }
        if monthVc.view.bounds.contains(touchLocation) {
            return false
        }
        return true
    }
    
    func selectedMonth(_ month: (name: String, number: Int), year: Int) {
        selectedMonth = month.number
        selectedYear = year
        monthLabel.text = month.name
        UserDefaultManager.shared.addUserDefaultObject("selectedDate", SelectedDate(selectedYear: selectedYear, selectedMonth: selectedMonth))
//        records = RecordDataManager.shared.getAllRecordByMonth(month: selectedMonth, year: selectedYear)
//        refreshTable()
        closeMonthView()
//        tableView.reloadData()
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
    }
    
    @objc func switchSegmentedControl() {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        
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
