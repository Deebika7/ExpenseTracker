//
//  monthSelectionDelegate.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 30/05/23.
//

import Foundation

protocol MonthSelectionDelegate: AnyObject {
    func selectedMonth(_ month: (name: String, number: Int), year: Int)
}
