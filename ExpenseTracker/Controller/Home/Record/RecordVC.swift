//
//  RecordVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class RecordVC: UITableViewController {
    
    
    var fields = ["Type","Amount","Date","Category"]
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: nil)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(AddRecordCell.self, forCellReuseIdentifier: AddRecordCell.reuseIdentifier)
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderFooterView.reuseIdentifier)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddRecordCell.reuseIdentifier, for: indexPath) as! AddRecordCell
        cell.backgroundColor = .systemBackground
        let indexPathValue = RecordField.allCases[indexPath.row]
        print(indexPathValue)
        switch indexPathValue {
        case .title:
            cell.configureCustomCell {  customCell in
                customCell.addSubview(textField)
                textField.backgroundColor = .black
                NSLayoutConstraint.activate([
                    textField.leadingAnchor.constraint(equalTo: customCell.leadingAnchor),
                    textField.trailingAnchor.constraint(equalTo: customCell.trailingAnchor),
                    textField.topAnchor.constraint(equalTo: customCell.topAnchor),
                    textField.bottomAnchor.constraint(equalTo: customCell.bottomAnchor)
                ])
            }
        case .amount:
            cell.configureCustomCell {  customCell in
                customCell.addSubview(textField)
                textField.backgroundColor = .black
                NSLayoutConstraint.activate([
                    textField.leadingAnchor.constraint(equalTo: customCell.leadingAnchor),
                    textField.trailingAnchor.constraint(equalTo: customCell.trailingAnchor),
                    textField.topAnchor.constraint(equalTo: customCell.topAnchor),
                    textField.bottomAnchor.constraint(equalTo: customCell.bottomAnchor)
                ])
            }
        case .date:
            cell.accessoryType = .disclosureIndicator
        case .category:
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:CustomHeaderFooterView.reuseIdentifier) as! CustomHeaderFooterView
        headerView.configureView(with: fields[section])
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
