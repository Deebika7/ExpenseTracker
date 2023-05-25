//
//  ExpenseTrackerDataManager.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 22/05/23.
//

import Foundation

class RecordDataManager {
    
    private init(){}
    
    static let shared = RecordDataManager()
    
    func createRecord(type: String, amount: Double, createdDate: String, category: Category) -> Bool {
        let recordType: Int16 = (type == "Income") ? 0 : 1
        let date: Date = Helper.convertStringToDate(value: createdDate)
        DatabaseManager.shared.createRecord(id: UUID(), recordType: recordType, category: category.categoryName, amount: amount, icon: category.sfSymbolName, date: date)
        return true
    }
    
    func deleteCustomCategory(id: UUID) {
        DatabaseManager.shared.removeCustomCategory(id: id)
    }
    
//    func getCategoryList(for createdDate: String, and type: String) -> [Category] {
//        let records = DatabaseManager.shared.getAllRecord()
//        let type: Int16 = (type == "Income") ? 0 : 1
//        var category: [Category] = []
//        for record in records {
//            if type == record.type {
//                category.append(Category(sfSymbolName: record.category!, categoryName: record.icon!))
//            }
//        }
//        return category
//    }
    
}
