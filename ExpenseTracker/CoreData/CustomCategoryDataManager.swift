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
            guard let name = customCategory.name, let icon = customCategory.icon else {
                break
            }
            if newCustomCategory.categoryName.caseInsensitiveCompare(name) == .orderedSame && newCustomCategory.sfSymbolName.caseInsensitiveCompare(icon) == .orderedSame  {
                return true
            }
        }
        return false
    }
    
    func updateCustomCategory(oldCustomCategory: CustomCategory, newCustomCategory: Category) {
            DatabaseManager.shared.updateCustomCategory(oldCustomCategory: oldCustomCategory, newCustomCategory: newCustomCategory)
        
    }
    
    func deleteCustomCategory(id: UUID) {
        DatabaseManager.shared.removeCustomCategory(id: id)
    }
    
}
