//
//  DatabaseManager.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 10/05/23.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager {
    
    private init(){}
    
    static let shared = DatabaseManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    // MARK: Record
    
    private lazy var fetchRecord: NSFetchRequest<Record>  = {
        return Record.fetchRequest()
    }()
    
    func getAllRecord() -> [Record] {
        return (try? context.fetch(fetchRecord)) ?? []
    }
    
//    func getRecord(_ predicate: (Record) -> Bool) -> Record? {
//        let records = getAllRecord()
//        for record in records {
//            if predicate(record) {
//                return record
//            }
//        }
//        return nil
//    }
    
    func getRecord(id: UUID) -> Record? {
        let records = getAllRecord()
        for record in records {
            if record.id == id {
                return record
            }
        }
        return nil
    }
    
    func createRecord(id: UUID, recordType: Int16, category: String, amount: String, icon: String, date: Date) {
        let record = Record(context: context)
        record.id = id
        record.type = recordType
        record.category = category
        record.amount = amount
        record.icon = icon
        record.date = date
        saveContext()
    }
    
    func removeRecord(_ id: UUID) {
        let records = getAllRecord()
        for record in records {
            if record.id == id {
                context.delete(record)
            }
        }
        saveContext()
    }
    
    func updateRecord(id: UUID, newType: Int16, newAmount: String, newIcon: String, newCategory: String, newDate: Date) {
        let record = getRecord(id: id)
        record?.type = newType
        record?.amount = newAmount
        record?.icon = newIcon
        record?.category = newCategory
        record?.date = newDate
        saveContext()
    }
    
    // MARK: Category
    
    private lazy var fetchCustomCategory: NSFetchRequest<CustomCategory>  = {
        return CustomCategory.fetchRequest()
    }()
    
    func getAllCustomCategory() -> [CustomCategory] {
        return (try? context.fetch(fetchCustomCategory)) ?? []
    }

    func addCustomCategory(id: UUID, name: String, iconName: String) {
        let customCategory = CustomCategory(context: context)
        customCategory.id = id
        customCategory.name = name
        customCategory.icon = iconName
        saveContext()
    }
    
    func removeCustomCategory(id : UUID) {
        let customCategory = getAllCustomCategory()
        for category in customCategory {
            if category.id == id {
                context.delete(category)
            }
        }
        saveContext()
    }
    
}

