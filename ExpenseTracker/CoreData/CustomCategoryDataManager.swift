//
//  CategoryDataManager.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 23/05/23.
//

import Foundation

class CustomCategoryDataManager {
    
    private init() {}
    
    static let shared = CustomCategoryDataManager()
    
    func addCustomCategory(name: String, category: Category) -> Bool {
        DatabaseManager.shared.addCustomCategory(id: UUID(), name: name, iconName: category.sfSymbolName)
        return true
    }
    
    func getAllCustomCategory() -> [CustomCategory] {
        DatabaseManager.shared.getAllCustomCategory()
    }
    
    
    
}
