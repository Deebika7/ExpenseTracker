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
    
   static func convertNotationDifference(_ notation1: String, _ notation2: String) -> String {
       var numericValue1: Double = 0
       var numericValue2: Double = 0
       
       if let number1 = Double(notation1.filter { "0123456789.".contains($0) }) {
           numericValue1 = number1
       } else if notation1.hasSuffix("K"), let number1 = Double(notation1.dropLast()) {
           numericValue1 = number1 * 1_000
       } else if notation1.hasSuffix("M"), let number1 = Double(notation1.dropLast()) {
           numericValue1 = number1 * 1_000_000
       } else if notation1.hasSuffix("B"), let number1 = Double(notation1.dropLast()) {
           numericValue1 = number1 * 1_000_000_000
       } else if notation1.hasSuffix("T"), let number1 = Double(notation1.dropLast()) {
           numericValue1 = number1 * 1_000_000_000_000
       }
       
       if let number2 = Double(notation2.filter { "0123456789.".contains($0) }) {
           numericValue2 = number2
       } else if notation2.hasSuffix("K"), let number2 = Double(notation2.dropLast()) {
           numericValue2 = number2 * 1_000
       } else if notation2.hasSuffix("M"), let number2 = Double(notation2.dropLast()) {
           numericValue2 = number2 * 1_000_000
       } else if notation2.hasSuffix("B"), let number2 = Double(notation2.dropLast()) {
           numericValue2 = number2 * 1_000_000_000
       } else if notation2.hasSuffix("T"), let number2 = Double(notation2.dropLast()) {
           numericValue2 = number2 * 1_000_000_000_000
       }
       
       let difference = numericValue1 - numericValue2
       
       var notationDifference = ""
       
       if difference >= 1_000_000_000_000 {
           notationDifference = String(format: "%.1fT", difference / 1_000_000_000_000)
       } else if difference >= 1_000_000_000 {
           notationDifference = String(format: "%.1fB", difference / 1_000_000_000)
       } else if difference >= 1_000_000 {
           notationDifference = String(format: "%.1fM", difference / 1_000_000)
       } else if difference >= 1_000 {
           notationDifference = String(format: "%.1fK", difference / 1_000)
       } else {
           notationDifference = String(format: "%.1f", difference)
       }
       
       // Truncate or pad the notation difference to ensure length is 4 characters
       if notationDifference.count > 4 {
           let index = notationDifference.index(notationDifference.startIndex, offsetBy: 4)
           notationDifference = String(notationDifference[..<index])
       } else if notationDifference.count < 4 {
           let paddingCount = 4 - notationDifference.count
           notationDifference += String(repeating: " ", count: paddingCount)
       }
       
       return notationDifference
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
    
}




