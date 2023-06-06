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
    
    func isCustomCategoryPresent(newCustomCategory: Category) -> Bool {
        let customCategories = getAllCustomCategory()
        for customCategory in customCategories {
            guard let name = customCategory.name else {
                break
            }
            if newCustomCategory.categoryName == name {
                return true
            }
        }
        return false
    }
    
    func deleteCustomCategory(id: UUID) {
        DatabaseManager.shared.removeCustomCategory(id: id)
    }
    
}
