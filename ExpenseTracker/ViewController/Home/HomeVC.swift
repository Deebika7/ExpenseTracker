//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var searchController = SearchController()
    
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
    
    private lazy var sharpDecorView: UIView = {
        let sharpDecorView = UIView()
        sharpDecorView.translatesAutoresizingMaskIntoConstraints = false
        sharpDecorView.backgroundColor = .white
        sharpDecorView.transform = CGAffineTransform(rotationAngle: 180)
        return sharpDecorView
    }()
    
    private lazy var moneyTrackerView: MoneyTrackerView = {
        let moneyTrackerView = MoneyTrackerView()
        moneyTrackerView.translatesAutoresizingMaskIntoConstraints = false
        moneyTrackerView.backgroundColor = .clear
        return moneyTrackerView
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
        balanceAmount.text = "0000000"
        balanceAmount.textAlignment = .center
        return balanceAmount
    }()
    
    private lazy var expenseAmount: UILabel = {
        let expenseAmount = UILabel()
        expenseAmount.translatesAutoresizingMaskIntoConstraints = false
        expenseAmount.text = "0000000"
        expenseAmount.textColor = .white
        return expenseAmount
    }()
    
    private lazy var incomeAmount: UILabel = {
        let incomeAmount = UILabel()
        incomeAmount.translatesAutoresizingMaskIntoConstraints = false
        incomeAmount.text = "0000000"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecord))
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Home"
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        redView.addSubview(moneyTrackerView)
        moneyTrackerView.addSubview(blueView)
        blueView.addSubview(incomeLabel)
        blueView.addSubview(incomeAmount)
        redView.addSubview(moneyTrackerView)
        redView.addSubview(expenseLabel)
        redView.addSubview(expenseAmount)
        redView.addSubview(balanceView)
        balanceView.addSubview(sharpDecorView)
        balanceView.addSubview(balanceLabel)
        balanceView.addSubview(balanceAmount)
        view.addSubview(redView)
        view.addSubview(tableView)
        setupContraints()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HomeCell")
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
            
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            redView.heightAnchor.constraint(equalToConstant: 120),
            redView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
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

            sharpDecorView.leadingAnchor.constraint(equalTo: balanceView.centerXAnchor),
            sharpDecorView.centerYAnchor.constraint(equalTo: balanceView.centerYAnchor, constant: -19),
            sharpDecorView.heightAnchor.constraint(equalToConstant: 6),
            sharpDecorView.widthAnchor.constraint(equalToConstant: 6),
            
            balanceLabel.centerXAnchor.constraint(equalTo: balanceView.centerXAnchor),
            
            balanceAmount.centerYAnchor.constraint(equalTo: balanceView.centerYAnchor, constant: 10),
            balanceAmount.centerXAnchor.constraint(equalTo: balanceView.centerXAnchor),
        
            tableView.topAnchor.constraint(equalTo: redView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -4),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
}

