//
//  CustomCategory+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 04/06/23.
//
//

import Foundation
import CoreData


extension CustomCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomCategory> {
        return NSFetchRequest<CustomCategory>(entityName: "CustomCategory")
    }

    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}

extension CustomCategory : Identifiable {

}
