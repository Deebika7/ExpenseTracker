//
//  Record+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
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

}

extension Record : Identifiable {

}
