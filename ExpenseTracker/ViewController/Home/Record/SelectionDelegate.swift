//
//  SelectionDelegate.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 12/05/23.
//

import Foundation

protocol SelectionDelegate: AnyObject {
    func selectedType(_ text: String)
    func selectedCategory(_ category: Category)
    func selectedDate(_ date: Date)
}

