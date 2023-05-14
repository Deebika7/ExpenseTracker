//
//  GenericTableViewController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 12/05/23.
//

import UIKit

class GenericTableViewController<T, Cell: UITableViewCell>: UITableViewController {

    var items: [T]
    var configure: (Cell, T) -> Void
    var selectionHandler: (T) -> Void
    
    init(items: [T], configure: @escaping (UITableViewCell, T) -> Void, style: UITableView, selectionHandler:
         @escaping (T) -> Void) {
        self.items = items
        self.configure = configure
        self.selectionHandler = selectionHandler
        super.init(style: .insetGrouped)
        self.tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
        self.tableView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        selectionHandler(item)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let item = items[indexPath.row]
        configure(cell, item)
        return cell
    }
    
    
    
}
