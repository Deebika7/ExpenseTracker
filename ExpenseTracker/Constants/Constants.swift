//
//  Constants.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 22/05/23.
//

import Foundation

class Constants {
    
    static let defaultCategory = Category(sfSymbolName: "fork.knife", categoryName: "Food")
    static let defaultType = "Income"
    static let defaultDate = Date()
    
    static func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    
}
