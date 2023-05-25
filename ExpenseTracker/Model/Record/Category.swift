//
//  Category.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 14/05/23.
//

import Foundation

struct Category {

    var sfSymbolName: String
    var categoryName: String
    
    init(sfSymbolName: String, categoryName: String) {
        self.sfSymbolName = sfSymbolName
        self.categoryName = categoryName
    }
}
