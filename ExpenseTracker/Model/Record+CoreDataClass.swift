//
//  Record+CoreDataClass.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 04/06/23.
//
//

import Foundation
import CoreData

@objc(Record)
public class Record: NSManagedObject {

    var recordType: RecordType { return type == 0 ? .income : .expense }
    
}
