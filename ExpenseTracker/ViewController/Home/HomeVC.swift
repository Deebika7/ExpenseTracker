//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class HomeVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecord))
        navigationItem.searchController = SearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
    }
    
    
    @objc func displaySearchBar() {
        
    }
    
    @objc func addRecord() {
        let recordVC = RecordVC()
        recordVC.title = "Add Record"
        navigationController?.pushViewController(recordVC, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    
    
    
    

}

