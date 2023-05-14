//
//  Record+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 10/05/23.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var amount: Double
    @NSManaged public var type: Int16
    @NSManaged public var icon: String?
    @NSManaged public var id: Int64

}

extension Record : Identifiable {

    
    
    
}
