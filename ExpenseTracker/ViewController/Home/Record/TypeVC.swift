//
//  TitleVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 12/05/23.
//

import UIKit

class TypeVC: UITableViewController {
    
    weak var selectionDelegate: SelectionDelegate?
    
    private lazy var selectedType = String()
    
    convenience init(selectedType: String) {
        self.init(style: .insetGrouped)
        self.selectedType = selectedType
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissTypeVC))
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "type")
        tableView.estimatedSectionHeaderHeight = 10
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    @objc func dismissTypeVC() {
        dismiss(animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "type", for: indexPath)
        let indexPathValue = RecordType.allCases[indexPath.row]
        var configuration = cell.defaultContentConfiguration()
        switch indexPathValue {
        case .expense:
            configuration.text = indexPathValue.rawValue
            configuration.textProperties.color = .label
        case .income:
            configuration.text = indexPathValue.rawValue
            configuration.textProperties.color = .label
        }
        if configuration.text == selectedType {
            cell.accessoryType = .checkmark
        }
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectionDelegate?.selectedType( RecordType.allCases[indexPath.row].rawValue)
        dismissTypeVC()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
