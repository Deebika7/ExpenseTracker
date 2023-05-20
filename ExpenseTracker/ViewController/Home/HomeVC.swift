//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class HomeVC: UITableViewController {
    
    private lazy var searchController = SearchController()
    
    private lazy var blueView: UIView = {
        let blueView = UIView()
        blueView.translatesAutoresizingMaskIntoConstraints = false
        blueView.backgroundColor = UIColor(named: "blue")
        return blueView
    }()
    
    private lazy var redView: UIView = {
        let redView = UIView()
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.backgroundColor = UIColor(named: "red")
        return redView
    }()
    
    private lazy var moneyTrackerView: MoneyTrackerView = {
        let moneyTrackerView = MoneyTrackerView()
        moneyTrackerView.translatesAutoresizingMaskIntoConstraints = false
        moneyTrackerView.backgroundColor = .clear
        return moneyTrackerView
    }()
    
    private lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView()
        return tableHeaderView
    }()
    
    private lazy var expenseLabel: UILabel = {
        let expenseLabel = UILabel()
        expenseLabel.translatesAutoresizingMaskIntoConstraints = false
        expenseLabel.textColor = UIColor(named: "moneyTrackerFont")
        expenseLabel.text = "expense"
        return expenseLabel
    }()
    
    private lazy var incomeLabel: UILabel = {
        let incomeLabel = UILabel()
        incomeLabel.translatesAutoresizingMaskIntoConstraints = false
        incomeLabel.textColor = .white
        incomeLabel.text = "income"
        return incomeLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .secondarySystemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecord))
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Home"
        
        tableView.keyboardDismissMode = .onDrag
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        tableHeaderView.addSubview(redView)
        redView.addSubview(moneyTrackerView)
        moneyTrackerView.addSubview(blueView)
        tableHeaderView.addSubview(moneyTrackerView)
        blueView.addSubview(incomeLabel)
        redView.layer.cornerRadius = 13
        blueView.layer.cornerRadius = 13
        
        setupContraints()
        
        self.tableView.tableHeaderView = tableHeaderView
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            moneyTrackerView.leadingAnchor.constraint(equalTo: redView.leadingAnchor),
            moneyTrackerView.trailingAnchor.constraint(equalTo: redView.trailingAnchor),
            moneyTrackerView.topAnchor.constraint(equalTo: redView.topAnchor),
            moneyTrackerView.bottomAnchor.constraint(equalTo: redView.bottomAnchor),
            
            blueView.leadingAnchor.constraint(equalTo: moneyTrackerView.leadingAnchor),
            blueView.trailingAnchor.constraint(equalTo: moneyTrackerView.trailingAnchor),
            blueView.heightAnchor.constraint(equalToConstant: 120),
            
            redView.leadingAnchor.constraint(equalTo: tableHeaderView.leadingAnchor, constant: 18),
            redView.trailingAnchor.constraint(equalTo: tableHeaderView.trailingAnchor, constant: -18),
            redView.heightAnchor.constraint(equalToConstant: 120),
            
            incomeLabel.centerYAnchor.constraint(equalTo: blueView.centerYAnchor),
            //            expenseLabel.centerYAnchor.constraint(equalTo: redView.centerYAnchor)
        ])
    }
    
    @objc func addRecord() {
        let recordVC = RecordVC()
        recordVC.title = "Add Record"
        navigationController?.pushViewController(recordVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

