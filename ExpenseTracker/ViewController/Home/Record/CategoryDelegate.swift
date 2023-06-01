//
//  CategoryDelegate.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 22/05/23.
//

import UIKit

protocol CategoryDelegate: AnyObject {
    func selectedCategory(_ category: Category?, categoryType: Int)
}
