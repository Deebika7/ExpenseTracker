//
//  Record+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 04/06/23.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var amount: String?
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var type: Int16

}

extension Record : Identifiable {

}
