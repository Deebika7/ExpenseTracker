//
//  RecordVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class RecordVC: UITableViewController {

    
    var fields = ["Type","Amount","Date","Category"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: nil)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Add Record")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Add Record", for: indexPath)
        cell.backgroundColor = .systemBackground
        //cell.configureLabelText(fields[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerView = view as! UITableViewHeaderFooterView
//        headerView.title.text =
        return fields[section]
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        headerView.textLabel?.textColor = .label
        
    }
    
    
    
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

}
