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
    
    func updateRecord(id: UUID, type: String, amount: Double, date: String, category: Category) {
        let recordType: Int16 = (type == "Income") ? 0 : 1
        let date: Date = Helper.convertStringToDate(value: date)
        DatabaseManager.shared.updateRecord(id: id, newType: recordType, newAmount: amount, newIcon: category.sfSymbolName, newCategory: category.categoryName, newDate: date)
    }
    
    func getAllRecord(month: Int, year: Int) -> [Date:[Record]] {
        let allRecords = DatabaseManager.shared.getAllRecord()
        var records: [Date: [Record]] = [:]
        for record in allRecords {
            let recordMonth = Helper.getYearAndMonthFromDate(date: record.date!).month
            let recordYear = Helper.getYearAndMonthFromDate(date: record.date!).year
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
    
    func deleteRecord(id: UUID) {
        DatabaseManager.shared.removeRecord(id)
    }
    
    func getRecord(id: UUID) -> Record {
        DatabaseManager.shared.getRecord(id: id)!
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
