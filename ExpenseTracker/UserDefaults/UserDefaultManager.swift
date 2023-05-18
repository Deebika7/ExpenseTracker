//
//  Colors.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 11/05/23.
//

import Foundation
import UIKit

class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    
    private let defaults = UserDefaults.standard
    
    private let encoder = JSONEncoder()
    
    private let decoder = JSONDecoder()
    
    private init(){}
    
    func addUserDefaultObject<T: Encodable>(_ key: String, _ value: T) {
        let encodedData = try? encoder.encode(value)
        defaults.set(encodedData, forKey: key)
    }
    
    func getUserDefaultObject<T: Decodable>(for key: String, _ value: T) -> T? {
       if let data = defaults.object(forKey: key) as? Data {
           let decodedData = try? decoder.decode(value.self as! T.Type, from: data)
           return decodedData
        }
        return nil
    }
    
}
