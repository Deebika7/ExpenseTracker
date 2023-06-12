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
    
    func saveContentBlurEffect(_ preference: Bool) {
        UserDefaults.standard.set(preference, forKey: "ContentBlurEffect")
    }
    
    func getContentBlurEffect() -> Bool {
        if let value = UserDefaults.standard.value(forKey: "ContentBlurEffect") as? Bool {
            return value
        }
        return false
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

    func saveSortOptions(_ sortOption: SortOption) {
        let encoder = JSONEncoder()
        if let encodedSortOption = try? encoder.encode(sortOption) {
            UserDefaults.standard.set(encodedSortOption, forKey: "SortOptionKey")
        }
    }
    
    func getSavedSortOptions() -> SortOption? {
        guard let encodedData = UserDefaults.standard.data(forKey: "SortOptionKey") else { return SortOption.date(.newestFirst) }
        if let decodedSortOption = try? decoder.decode(SortOption.self, from: encodedData) {
            return decodedSortOption
        }
        return nil
    }
    
    func saveSectionSortOptions(_ option: SectionSortOption) {
        if let encodedSortOption = try? encoder.encode(option) {
            UserDefaults.standard.set(encodedSortOption, forKey: "SectionSortOptionKey")
        }
    }
    
    func getSavedSectionSortOptions() -> SectionSortOption? {
        guard let encodedData = UserDefaults.standard.data(forKey: "SectionSortOptionKey") else { return nil }
        if let decodedSortOption = try? decoder.decode(SectionSortOption.self, from: encodedData) {
            return decodedSortOption
        }
        return nil
    }
    
    func saveRowSortOption(_ option: RowSortOption) {
        if let encodedSortOption = try? encoder.encode(option) {
            UserDefaults.standard.set(encodedSortOption, forKey: "RowSortOptionKey")
        }
    }
    
    func getSavedRowSortOption() -> RowSortOption? {
        guard let encodedData = UserDefaults.standard.data(forKey: "RowSortOptionKey") else { return nil }
        if let decodedSortOption = try? decoder.decode(RowSortOption.self, from: encodedData) {
            return decodedSortOption
        }
        return nil
    }
    
}
