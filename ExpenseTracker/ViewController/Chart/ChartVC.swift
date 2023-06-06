//
//  PieChartVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 28/05/23.
//

import UIKit

class ChartVC: UIViewController {
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Expense", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Income", at: 1, animated: true)
        segmentedControl.addTarget(self, action: #selector(switchSegmentedControl), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(segmentedControl)
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            segmentedControl.heightAnchor.constraint(equalToConstant: 44),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        switchSegmentedControl()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Charts"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
