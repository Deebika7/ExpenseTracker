//
//  DescriptionVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 28/05/23.
//

import UIKit

class DescriptionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private lazy var edit: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: nil)
    }()
    
    private lazy var delete: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DescriptionCell")
        navigationItem.rightBarButtonItems = [delete, edit]
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.reuseIdentifier)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath)
            var configuration = cell.defaultContentConfiguration()
            configuration.image = UIImage(systemName: "dumbbell")
            configuration.imageToTextPadding = 70
            configuration.imageProperties.tintColor = .label
            configuration.text = "Gym"
            configuration.textProperties.font = UIFont.boldSystemFont(ofSize: 20)
            cell.contentConfiguration = configuration
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.reuseIdentifier, for: indexPath) as! DescriptionCell
            cell.configureCell(title: "test", text: "test")
            cell.selectionStyle = .none
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else {
            return 44
        }
    }
    
    
}
