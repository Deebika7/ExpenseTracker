//
//  CalendarVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 15/05/23.
//

import UIKit

class CalendarVC: UIViewController, UICalendarSelectionSingleDateDelegate {
    
    weak var selectionDelegate: SelectionDelegate?
    
    private lazy var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.calendar = gregorianCalendar
        calendarView.backgroundColor = .secondarySystemBackground
        calendarView.layer.cornerRadius = 10.0
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.contentHuggingPriority(for: .vertical)
        return calendarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(calendarView)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        configureCalendarViewConstraints()
    }
    
    func configureCalendarViewConstraints() {
        let calendarHeight: CGFloat = traitCollection.horizontalSizeClass == .compact ? 400 : 500
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: calendarHeight)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            configureCalendarViewConstraints()
            view.layoutIfNeeded()
        }
    }

    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selectionDelegate?.selectedDate((dateComponents?.date!)!)
    }
    
    
}
