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
    
    @objc func didTapMonthView() {
        if isMonthViewExpanded {
            navigationItem.title = nil
            navigationController?.navigationBar.prefersLargeTitles = false
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
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = "Chart"
            monthVc.removeFromSuperview()
            navigationItem.searchController = searchController
            isMonthViewExpanded = true
        }
    }
    
    func selectedMonth(_ month: (name: String, number: Int), year: Int) {
        selectedMonth = month.number
        selectedYear = year
        monthLabel.text = month.name
        UserDefaultManager.shared.addUserDefaultObject("selectedDateForChart", SelectedDate(selectedYear: selectedYear, selectedMonth: selectedMonth))
        closeMonthView()
        switchSegmentedControl()
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
    }
    
    @objc func switchSegmentedControl() {
        print(selectedSegmentIndex)
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
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        if selectedSegmentIndex == 1 {
            let incomePieChartVC = IncomePieChartVC()
            incomePieChartVC.updateSearchResults(text)
        }
        else {
            let expensePieChartVC = ExpensePieChartVC()
            expensePieChartVC.updateSearchResults(text)
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
    }

    @objc func forwardChevronTapped() {
        let value = Int(monthVc.yearLabel.text ?? "0")!
        monthVc.yearLabel.text = "\(value + 1)"
    }

    private func getYear() -> Int {
        Int(monthVc.yearLabel.text!) ?? 0
    }
}

