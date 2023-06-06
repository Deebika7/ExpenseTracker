//
//  Constants.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 22/05/23.
//

import Foundation
import UIKit

class Helper {
   
    static let defaultMonth = getDateProperties(date: defaultDate).month
    static let defaultYear = getDateProperties(date: defaultDate).year
    static let defaultType = "Income"
    static let defaultMonthName = dataSource[defaultMonth-1].0
    static let categoryType = (default: 0, custom: 1);
    static let defaultDate = Date()
    static let calendar = Calendar.current

    static var dataSource: [(String, Int)] = [("Jan", 1), ("Feb", 2), ("Mar", 3), ("Apr", 4), ("May", 5), ("Jun", 6), ("Jul", 7), ("Aug", 8), ("Sep", 9), ("Oct", 10), ("Nov", 11), ("Dec", 12)]
    
    static var customCategory: [String:[Category]] = [
        "Food" : [
            Category(sfSymbolName: "birthday.cake", categoryName: "Cake"),
            Category(sfSymbolName: "wineglass", categoryName: "Wine" ),
            Category(sfSymbolName: "takeoutbag.and.cup.and.straw", categoryName: "Beverages"),
            Category(sfSymbolName: "carrot", categoryName: "Carrot"),
            Category(sfSymbolName: "fork.knife", categoryName: "restaurant")
        ],
        "Transportation" : [
            Category(sfSymbolName: "fuelpump", categoryName: "Fuel"),
            Category(sfSymbolName: "bicycle", categoryName: "Bicycle"),
            Category(sfSymbolName: "sailboat", categoryName: "Boat"),
            Category(sfSymbolName: "ferry", categoryName: "Ship"),
            Category(sfSymbolName: "car", categoryName: "Car"),
            Category(sfSymbolName: "bus", categoryName: "Bus"),
            Category(sfSymbolName: "box.truck", categoryName: "truck"),
            Category(sfSymbolName: "airplane", categoryName: "Airplane"),
            Category(sfSymbolName: "train", categoryName: "Train"),
            Category(sfSymbolName: "scooter", categoryName: "Scooter"),
            Category(sfSymbolName: "road.lanes", categoryName: "Road"),
        ],
        "Shopping" : [
            Category(sfSymbolName: "cart", categoryName: "Cart"),
            Category(sfSymbolName: "tshirt", categoryName: "Clothing"),
            Category(sfSymbolName: "teddybear", categoryName: "Doll"),
            Category(sfSymbolName: "beach.umbrella", categoryName: "Umbrella"),
            Category(sfSymbolName: "eyeglasses", categoryName: "Eyeglass"),
            Category(sfSymbolName: "comb", categoryName: "Comb"),
            Category(sfSymbolName: "eyebrow", categoryName: "Aesthetics"),
        ],
        "Sports" : [
            Category(sfSymbolName: "figure.pool.swim", categoryName: "Swimming"),
            Category(sfSymbolName: "cricket.ball", categoryName: "Cricket"),
            Category(sfSymbolName: "figure.baseball", categoryName: "Baseball"),
            Category(sfSymbolName: "figure.basketball", categoryName: "Basketball"),
            Category(sfSymbolName: "figure.volleyball", categoryName: "Volleyball"),
            Category(sfSymbolName: "soccerball", categoryName: "Scoccerball"),
            Category(sfSymbolName: "figure.handball", categoryName: "Handball"),
            Category(sfSymbolName: "tennisball", categoryName: "Tennisball"),
            Category(sfSymbolName: "figure.wrestling", categoryName: "Wrestling"),
            Category(sfSymbolName: "tennis.racket", categoryName: "Badminton"),
            Category(sfSymbolName: "gamecontroller", categoryName: "Video Games")
        ],
        "Fitness" : [
            Category(sfSymbolName: "dumbbell", categoryName: "Gym"),
            Category(sfSymbolName: "figure.yoga", categoryName: "Yoga"),
            Category(sfSymbolName: "figure.stairs", categoryName: "Stairs"),
            Category(sfSymbolName: "figure.run", categoryName: "Running"),
            Category(sfSymbolName: "figure.walk", categoryName: "Walking"),
        ],
        "Education" : [
            Category(sfSymbolName: "paintpalette", categoryName: "Paint"),
            Category(sfSymbolName: "book.circle.fill", categoryName: "Books"),
            Category(sfSymbolName: "music.note.house", categoryName: "Music"),
            Category(sfSymbolName: "figure.socialdance", categoryName: "Dance"),
            
        ],
        "Health" : [
            Category(sfSymbolName: "waveform.path.ecg.rectangle", categoryName: "ECG"),
            Category(sfSymbolName: "pills", categoryName: "Pills"),
            Category(sfSymbolName: "syringe", categoryName: "Syringe"),
            Category(sfSymbolName: "facemask", categoryName: "Facemask"),
            Category(sfSymbolName: "bandage", categoryName: "Bandage"),
            Category(sfSymbolName: "lungs", categoryName: "Lungs"),
            Category(sfSymbolName: "medical.thermometer", categoryName: "Thermometer"),
            Category(sfSymbolName: "cross.vial", categoryName: "Tonic"),
        ],
        "Furniture" : [
            Category(sfSymbolName: "lamp.floor", categoryName: "Lamp"),
            Category(sfSymbolName: "fan.floor", categoryName: "Fan"),
            Category(sfSymbolName: "lightbulb", categoryName: "Light Bulb"),
            Category(sfSymbolName: "toilet", categoryName: "Lavatory"),
            Category(sfSymbolName: "microwave", categoryName: "Microwave"),
            Category(sfSymbolName: "refrigerator", categoryName: "Refrigerator"),
            Category(sfSymbolName: "chair.lounge", categoryName: "Chair")
        ],
        "Electronics": [
            Category(sfSymbolName: "applewatch", categoryName: "Watch"),
            Category(sfSymbolName: "camera", categoryName: "Camera"),
            Category(sfSymbolName: "headphones", categoryName: "Headphones"),
            Category(sfSymbolName: "laptopcomputer", categoryName: "Laptop"),
            Category(sfSymbolName: "printer", categoryName: "Printer"),
            Category(sfSymbolName: "tv", categoryName: "Television"),
        ],
        "Personal" : [
            Category(sfSymbolName: "figure.2.and.child.holdinghands", categoryName: "Family"),
            Category(sfSymbolName: "figure.and.child.holdinghands", categoryName: "Child"),
            Category(sfSymbolName: "heart.text.square", categoryName: "Grants"),
            Category(sfSymbolName: "globe.europe.africa.fill", categoryName: "Travel"),
        ],
        "Income": [
            Category(sfSymbolName: "creditcard", categoryName: "Credit Card"),
            Category(sfSymbolName: "banknote", categoryName: "Current"),
        ]
    ]
    
    static func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func convertStringToDate(value: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: value)!
    }
    
    static func expenseCategory() -> [Category] {
        var category: [Category] = []
        for expense in SFSymbolForExpense.allCases {
            category.append(Category(sfSymbolName: expense.rawValue, categoryName: String(describing: expense)))
        }
        return category
    }
    
    static func incomeCategory() -> [Category] {
        var category: [Category] = []
        for income in SFSymbolForIncome.allCases {
            category.append(Category(sfSymbolName: income.rawValue, categoryName: String(describing: income)))
        }
        return category
    }
    
    static func getDateProperties(date: Date) -> (year: Int, month: Int, day: Int){
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        if let year = components.year, let month = components.month, let day = components.day {
           return (year,month,day)
        }
        return (0,0,0)
    }

   static func simplifyNumbers(_ numbers: [String], _ precision: Int) -> String {
       var sum: Double = 0.0
       
       for numberString in numbers {
           if let number = Double(numberString) {
               sum += number
           }
       }
       
       let numberFormatter = NumberFormatter()
       numberFormatter.numberStyle = .decimal
       numberFormatter.maximumFractionDigits = precision // Set the desired precision
       numberFormatter.groupingSeparator = "."
       if abs(sum) >= 100000 {
           let power = min(Int(log10(abs(sum)) / 3.0), 4) // Restrict the power value to a maximum of 4
           let suffix = ["", "K", "M", "B", "T"][power]
           
           let simplifiedNumber = sum / pow(1000.0, Double(power))
           numberFormatter.maximumFractionDigits = power > 0 ? precision : 0
           
           if let simplifiedString = numberFormatter.string(from: NSNumber(value: simplifiedNumber)) {
               let truncatedString = String(simplifiedString.prefix(5)) // Truncate the string to a maximum of 5 characters
               return truncatedString + suffix
           }
       } else {
           if let simplifiedString = numberFormatter.string(from: NSNumber(value: sum)) {
               let formattedString = simplifiedString.replacingOccurrences(of: ".", with: "") // Remove the decimal separator
               return formattedString
           }
       }
       
       return "\(sum)"
   }
    
   static func simplifyDifferenceBetweenNumbers(_ numbers1: [String], _ numbers2: [String], _ precision: Int) -> String? {
       let count = max(numbers1.count, numbers2.count) // Get the maximum count of the two arrays
       
       var differenceSum: Double = 0.0
       
       for index in 0..<count {
           let numberString1 = index < numbers1.count ? numbers1[index] : "0" // Use "0" for missing values in numbers1
           let numberString2 = index < numbers2.count ? numbers2[index] : "0" // Use "0" for missing values in numbers2
           
           guard let number1 = Double(numberString1),
                 let number2 = Double(numberString2) else {
               return nil // Return nil if any value is not a valid number
           }
           
           let difference = number2 - number1 // Subtract numbers1 from numbers2
           differenceSum += difference // Add the difference to the differenceSum
       }
       
       let numberFormatter = NumberFormatter()
       numberFormatter.numberStyle = .decimal
       numberFormatter.maximumFractionDigits = precision // Set the desired precision
       numberFormatter.groupingSeparator = "."
       
       if abs(differenceSum) >= 100000 {
           let power = min(Int(log10(abs(differenceSum)) / 3.0), 4) // Restrict the power value to a maximum of 4
           let suffix = ["", "K", "M", "B", "T"][power]
           
           let simplifiedNumber = differenceSum / pow(1000.0, Double(power))
           numberFormatter.maximumFractionDigits = power > 0 ? precision : 0
           
           if let simplifiedString = numberFormatter.string(from: NSNumber(value: simplifiedNumber)) {
               let truncatedString = String(simplifiedString.prefix(5)) // Truncate the string to a maximum of 5 characters
               return truncatedString + suffix
           }
       } else {
           if let simplifiedString = numberFormatter.string(from: NSNumber(value: differenceSum)) {
               let formattedString = simplifiedString.replacingOccurrences(of: ".", with: "") // Remove the decimal separator
               return formattedString
           }
       }
       
       return "\(differenceSum)"
   }


    static func getSimplifiedAmount(_ records: [Record], _ type: Int16) -> String {
        var amount: [String]  = []
        for record in records {
            if record.type == type {
                amount.append(record.amount!)
            }
        }
        return simplifyNumbers(amount, 3)
    }
    
    static func getRecordAmount(_ records: [Record], _ type: Int16) -> [String] {
        var amount: [String]  = []
        for record in records {
            if record.type == type {
                amount.append(record.amount!)
            }
        }
        return amount
    }
    
    
    static func generateUniqueColors(_ count: Int) -> [UIColor] {
        var colors: [UIColor] = []
        
        for _ in 0..<count {
            var color: UIColor
            
            repeat {
                let red = CGFloat.random(in: 0...1)
                let green = CGFloat.random(in: 0...1)
                let blue = CGFloat.random(in: 0...1)
                color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            } while colors.contains(where: { $0.isEqual(color) })
            
            colors.append(color)
        }
        return colors
    }
    
    static func convertToString(from notation: String) -> String? {
        let trimmedNotation = notation.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let numericValue = Double(trimmedNotation) else {
            return String(trimmedNotation)
        }
        
        if numericValue < 1000 {
            return String(numericValue)
        }
        
        var convertedValue: Double
        
        switch trimmedNotation.suffix(1).lowercased() {
        case "K":
            convertedValue = numericValue * 1_000
        case "M":
            convertedValue = numericValue * 1_000_000
        case "B":
            convertedValue = numericValue * 1_000_000_000
        case "T":
            convertedValue = numericValue * 1_000_000_000_000
        default:
            return nil
        }
        return String(convertedValue)
    }

    static func calculatePercentage(value: Double, total: Double) -> Double {
        guard total != 0 else {
            return 0
        }
        
        let percentage = (value / total) * 100
        return percentage
    }
        
    static func getChartData(_ records: [Record], type: Int16) -> [ChartData] {
        lazy var recordByCategory = [String: [Record]]()
        lazy var chartData = [ChartData]()
        lazy var totalAmount = Double()
        for record in records {
            if record.type == type {
                if let category = record.category {
                    if recordByCategory[category] != nil {
                        recordByCategory[category]?.append(record)
                    }
                    else {
                        recordByCategory[category] = []
                        recordByCategory[category]?.append(record)
                    }
                }
                if let amount = record.amount {
                    totalAmount += (Double(amount) ?? 0)
                }
            }
        }
        for (key, value) in recordByCategory {
            lazy var icon = String()
            lazy var categoryAmount = Double()
            for record in value {
                if let recordIcon = record.icon, let amount = record.amount {
                    icon =  recordIcon
                    categoryAmount += Double(amount) ?? 0
                }
            }
            chartData.append(ChartData(percentage: calculatePercentage(value: categoryAmount, total: totalAmount), sfSymbol: icon, name: key))
        }
        return chartData
    }
    
}




