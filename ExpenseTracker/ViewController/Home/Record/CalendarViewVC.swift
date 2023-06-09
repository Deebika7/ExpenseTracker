//
//  CalendarTableTableViewController.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 16/05/23.
//

import UIKit

class CalendarViewVC: UITableViewController, UICalendarSelectionSingleDateDelegate {

    weak var selectionDelegate: SelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Calendar View" )
        tableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(popCalendarViewVC))
    }

    private lazy var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.calendar = gregorianCalendar
        calendarView.backgroundColor = .secondarySystemBackground
        calendarView.layer.cornerRadius = 10.0
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()

    @objc func popCalendarViewVC() {
        navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Calendar View", for: indexPath)
        cell.contentView.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.bottomAnchor),
            calendarView.topAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.topAnchor)
        ])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
   
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        selectionDelegate?.selectedDate(dateFormatter.string(from: dateComponents!.date!))
        
    }
    
}
