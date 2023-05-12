//
//  GenericTableViewController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 12/05/23.
//

import UIKit

class GenericTableViewController<T, Cell: UITableViewCell>: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

   
}
