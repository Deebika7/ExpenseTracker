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
    
    func getUserDefaultObject<T: Decodable>(for key: String, _ value: T.Type) -> T? {
       if let data = defaults.object(forKey: key) as? Data {
           let decodedData = try? decoder.decode(value, from: data)
           return decodedData
        }
        return nil
    }
    
    func saveSelectedAppearance(_ appearance: UIUserInterfaceStyle) {
        UserDefaults.standard.set(appearance.rawValue, forKey: "SelectedAppearance")
    }

    func getSelectedAppearance() -> UIUserInterfaceStyle? {
        if let rawValue = UserDefaults.standard.value(forKey: "SelectedAppearance") as? Int {
            return UIUserInterfaceStyle(rawValue: rawValue)
        }
        return nil
    }

    
}
