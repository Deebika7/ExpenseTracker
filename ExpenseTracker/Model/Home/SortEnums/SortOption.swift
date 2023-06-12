//
//  SortOption.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 12/06/23.
//

import Foundation

enum SortOption: Codable {
    
    case date(DateSortByOption)
    case income(RowSortByOption), expense(RowSortByOption)
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .date(let dateSortBy):
            try container.encode(dateSortBy, forKey: .date)
        case .income(let amountSortBy):
            try container.encode(amountSortBy, forKey: .income)
        case .expense(let amountSortBy):
            try container.encode(amountSortBy, forKey: .expense)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let dateSortBy = try container.decodeIfPresent(DateSortByOption.self, forKey: .date) {
            self = .date(dateSortBy)
        } else if let amountSortBy = try container.decodeIfPresent(RowSortByOption.self, forKey: .income) {
            self = .income(amountSortBy)
        } else if let amountSortBy = try container.decodeIfPresent(RowSortByOption.self, forKey: .expense) {
            self = .expense(amountSortBy)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .sortOption, in: container, debugDescription: "Invalid sort option")
        }
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case sortOption
        case date
        case income
        case expense
    }
}

enum DateSortByOption: String, Codable {
    case newestFirst, oldestFirst
}




enum SectionSortOption: Codable {
    case newestFirst, oldestFirst
}

enum RowSortOption: Codable {
    case income(RowSortByOption)
    case expense(RowSortByOption)
}

enum RowSortByOption: String, Codable {
    case amountHighToLow, amountLowToHigh
}
