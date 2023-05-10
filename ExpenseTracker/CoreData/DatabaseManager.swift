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
    
    private lazy var fetchRecord: NSFetchRequest<Record>  = {
        return Record.fetchRequest()
    }()
    
    func getAllRecord() -> [Record] {
        return (try? context.fetch(fetchRecord)) ?? []
    }
    
    func getRecord(_ predicate: (Record) -> Bool) -> Record? {
        let records = getAllRecord()
        for record in records {
            if predicate(record) {
                return record
            }
        }
        return nil
    }
    
    func createRecord(id: Int64, type: Int16, category: String, amount: Double, icon: String, date: Date ) {
        let record = Record(context: context)
        record.id = id
        record.type = type
        record.category = category
        record.amount = amount
        record.icon = icon
        record.date = date
        saveContext()
    }
    
    func removeRecord(_ id: Int64) {
        let records = getAllRecord()
        for record in records {
            if record.id == id {
                context.delete(record)
            }
        }
        saveContext()
    }
    
    
}

