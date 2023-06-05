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
    
    func createRecord(type: String, amount: String, createdDate: String, category: Category) -> Bool {
        let recordType: Int16 = (type == "Income") ? 0 : 1
        let date: Date = Helper.convertStringToDate(value: createdDate)
        DatabaseManager.shared.createRecord(id: UUID(), recordType: recordType, category: category.categoryName, amount: amount, icon: category.sfSymbolName, date: date)
        return true
    }
    
    func updateRecord(id: UUID, type: String, amount: String, date: String, category: Category) {
        let recordType: Int16 = (type == "Income") ? 0 : 1
        let date: Date = Helper.convertStringToDate(value: date)
        DatabaseManager.shared.updateRecord(id: id, newType: recordType, newAmount: amount, newIcon: category.sfSymbolName, newCategory: category.categoryName, newDate: date)
    }
    
    func updateRecordForCustomCategory(customCategoryName: String) {
        let allRecords = DatabaseManager.shared.getAllRecord()
        for record in allRecords {
            if record.category! == customCategoryName {
                DatabaseManager.shared.updateRecord(id: record.id!, newType: record.type, newAmount: record.amount!, newIcon: "square.grid.3x3", newCategory: "Others", newDate: record.date!)
            }
        }
    }

    
    func getAllRecordByMonth(month: Int, year: Int) -> [Date:[Record]] {
        let allRecords = DatabaseManager.shared.getAllRecord()
        var records: [Date: [Record]] = [:]
        for record in allRecords {
            let recordMonth = Helper.getDateProperties(date: record.date!).month
            let recordYear = Helper.getDateProperties(date: record.date!).year
            if recordYear == year && recordMonth == month {
                if records[record.date!] != nil {
                    records[record.date!]?.append(record)
                }
                else {
                    records[record.date!] = []
                    records[record.date!]?.append(record)
                }
            }
        }
        return records
    }
    
    func getAllRecordForAMonth(month: Int, year: Int) -> [Record] {
        let allRecords = DatabaseManager.shared.getAllRecord()
        var records: [Record] = []
        for record in allRecords {
            let recordMonth = Helper.getDateProperties(date: record.date!).month
            let recordYear = Helper.getDateProperties(date: record.date!).year
            if recordYear == year && recordMonth == month {
                records.append(record)
            }
        }
        return records
    }
    
    func deleteRecord(id: UUID) {
        DatabaseManager.shared.removeRecord(id)
    }
    
    func getRecord(id: UUID) -> Record {
        DatabaseManager.shared.getRecord(id: id)!
    }
    
    func getAllRecord() -> [Record] {
        DatabaseManager.shared.getAllRecord()
    }
    
}
