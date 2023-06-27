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
    
    static func getUnAvailableMonths(_ month: Int) -> [(String, Int)] {
        var unAvailableMonths: [(String, Int)] = []
        for data in dataSource {
            if data.1 > month {
                unAvailableMonths.append(data)
            }
            else {
                unAvailableMonths.append(("",0))
            }
        }
        return unAvailableMonths
    }
    
    static var customCategory: [String:[Category]] = [
        "Food" : [
            Category(sfSymbolName: "birthday.cake", categoryName: "Cake", color: "#657a00"),
            Category(sfSymbolName: "wineglass", categoryName: "Wine", color: "#1400c6"),
            Category(sfSymbolName: "takeoutbag.and.cup.and.straw", categoryName: "Beverages", color: "#fceed1"),
            Category(sfSymbolName: "carrot", categoryName: "Carrot", color: "#FFD480"),
            Category(sfSymbolName: "fork.knife", categoryName: "restaurant", color: "#f2d53c")
        ],
        "Transportation" : [
            Category(sfSymbolName: "fuelpump", categoryName: "Fuel", color: "#c80e13"),
            Category(sfSymbolName: "bicycle", categoryName: "Bicycle", color: "#8bf0ba"),
            Category(sfSymbolName: "sailboat", categoryName: "Boat", color: "#0e0fed"),
            Category(sfSymbolName: "ferry", categoryName: "Ship", color: "#94f0f1"),
            Category(sfSymbolName: "car", categoryName: "Car", color: "#f2b1d8"),
            Category(sfSymbolName: "bus", categoryName: "Bus", color: "#ffdc6a"),
            Category(sfSymbolName: "box.truck", categoryName: "truck", color: "#AADEA7"),
            Category(sfSymbolName: "airplane", categoryName: "Airplane",color: "#E6F69D"),
            Category(sfSymbolName: "train.side.front.car", categoryName: "Train",color: "#FF2E7E"),
            Category(sfSymbolName: "scooter", categoryName: "Scooter",color: "#57167E"),
            Category(sfSymbolName: "road.lanes", categoryName: "Road",color: "#FFEC00"),
        ],
        "Shopping" : [
            Category(sfSymbolName: "cart", categoryName: "Cart",color: "#8F6A7D"),
            Category(sfSymbolName: "tshirt", categoryName: "Clothing",color: "#6A8E6F"),
            Category(sfSymbolName: "teddybear", categoryName: "Doll",color: "#B36D8A"),
            Category(sfSymbolName: "beach.umbrella", categoryName: "Umbrella",color: ""),
            Category(sfSymbolName: "eyeglasses", categoryName: "Eyeglass",color: "#86795D"),
            Category(sfSymbolName: "comb", categoryName: "Comb",color: "#5C8C9A"),
            Category(sfSymbolName: "eyebrow", categoryName: "Aesthetics",color: "#A9734D"),
        ],
        "Sports" : [
            Category(sfSymbolName: "figure.pool.swim", categoryName: "Swimming",color: "#A85E4C"),
            Category(sfSymbolName: "cricket.ball", categoryName: "Cricket",color: "#637F6A"),
            Category(sfSymbolName: "figure.baseball", categoryName: "Baseball",color: "#9C546D"),
            Category(sfSymbolName: "figure.basketball", categoryName: "Basketball",color: "#4D8F86"),
            Category(sfSymbolName: "figure.volleyball", categoryName: "Volleyball",color: "#9E6C57"),
            Category(sfSymbolName: "soccerball", categoryName: "Scoccerball",color: "#5E7E99"),
            Category(sfSymbolName: "figure.handball", categoryName: "Handball",color: "#C85D67"),
            Category(sfSymbolName: "tennisball", categoryName: "Tennisball",color: "#6F945A"),
            Category(sfSymbolName: "figure.wrestling", categoryName: "Wrestling",color: "#A75C7B"),
            Category(sfSymbolName: "tennis.racket", categoryName: "Badminton",color: "#53638C"),
            Category(sfSymbolName: "gamecontroller", categoryName: "Video Games",color: "#9A8F5D")
        ],

        "Fitness" : [
            Category(sfSymbolName: "dumbbell", categoryName: "Gym", color: "#AC4F67"),
            Category(sfSymbolName: "figure.yoga", categoryName: "Yoga", color: "#5E95A1"),
            Category(sfSymbolName: "figure.stairs", categoryName: "Stairs", color: "#8B6F4E"),
            Category(sfSymbolName: "figure.run", categoryName: "Running", color: "#C35D85"),
            Category(sfSymbolName: "figure.walk", categoryName: "Walking", color: "#7E5A81"),
        ],
        "Education" : [
            Category(sfSymbolName: "paintpalette", categoryName: "Paint", color: "#596BA5"),
            Category(sfSymbolName: "book.circle.fill", categoryName: "Books", color: "#8F816C"),
            Category(sfSymbolName: "music.note.house", categoryName: "Music", color: "#D0656E"),
            Category(sfSymbolName: "figure.socialdance", categoryName: "Dance", color: "#7D8A55"),
            
        ],
        "Health" : [
            Category(sfSymbolName: "waveform.path.ecg.rectangle", categoryName: "ECG", color: "#A54F7C"),
            Category(sfSymbolName: "pills", categoryName: "Pills", color: "#648E8A"),
            Category(sfSymbolName: "syringe", categoryName: "Syringe", color: "#9C564A"),
            Category(sfSymbolName: "facemask", categoryName: "Facemask", color: "#507C96"),
            Category(sfSymbolName: "bandage", categoryName: "Bandage", color: "#BB8A65"),
            Category(sfSymbolName: "lungs", categoryName: "Lungs", color: "#6E9D8C"),
            Category(sfSymbolName: "medical.thermometer", categoryName: "Thermometer", color: "#976F6B"),
            Category(sfSymbolName: "cross.vial", categoryName: "Tonic", color: "#B26D54"),
        ],
        "Furniture" : [
            Category(sfSymbolName: "lamp.floor", categoryName: "Lamp", color: "#7A5A82"),
            Category(sfSymbolName: "fan.floor", categoryName: "Fan", color: "#AB7B3B"),
            Category(sfSymbolName: "lightbulb", categoryName: "Light Bulb", color: "#5E8DA0"),
            Category(sfSymbolName: "toilet", categoryName: "Lavatory", color: "#857D4C"),
            Category(sfSymbolName: "microwave", categoryName: "Microwave", color: "#D04F49"),
            Category(sfSymbolName: "refrigerator", categoryName: "Refrigerator", color: "#57928F"),
            Category(sfSymbolName: "chair.lounge", categoryName: "Chair", color: "#806B3A")
        ],
        "Electronics": [
            Category(sfSymbolName: "applewatch", categoryName: "Watch", color: "#B9507E"),
            Category(sfSymbolName: "camera", categoryName: "Camera", color: "#496D7F"),
            Category(sfSymbolName: "headphones", categoryName: "Headphones", color: "#A73E4A"),
            Category(sfSymbolName: "laptopcomputer", categoryName: "Laptop", color: " #50897C"),
            Category(sfSymbolName: "printer", categoryName: "Printer", color: "#9062A9"),
            Category(sfSymbolName: "tv", categoryName: "Television", color: "#638D9D"),
        ],
        "Personal" : [
            Category(sfSymbolName: "figure.2.and.child.holdinghands", categoryName: "Family", color: "#9C534C"),
            Category(sfSymbolName: "figure.and.child.holdinghands", categoryName: "Child", color: "#437E80"),
            Category(sfSymbolName: "heart.text.square", categoryName: "Grants", color: "#A56884"),
            Category(sfSymbolName: "globe.europe.africa.fill", categoryName: "Travel", color: "#5B80A4"),
        ],
        "Income": [
            Category(sfSymbolName: "creditcard", categoryName: "Card", color: "#964E50"),
            Category(sfSymbolName: "banknote", categoryName: "Currency", color: "#7DCEA0"),
        ],
        "Others": [
            Category(sfSymbolName: "square.grid.3x3", categoryName: "Others", color: "#63b863"),
        ]
    ]
    
    static var expenseCategory: [Category] = [
        Category(sfSymbolName: "fork.knife", categoryName: "Food", color: "#5e43f3"),
        Category(sfSymbolName: "dumbbell", categoryName: "Gym", color: "#ff6d3b"),
        Category(sfSymbolName: "house", categoryName: "Rent", color: "#EE82EE"),
        Category(sfSymbolName: "figure.and.child.holdinghands", categoryName: "Child", color: "#87CEEB"),
        Category(sfSymbolName: "doc.plaintext", categoryName: "Bills", color: "#beef00"),
        Category(sfSymbolName: "bus.fill", categoryName: "Transportation", color: "#ff0028"),
        Category(sfSymbolName: "carrot", categoryName: "Vegetables", color: "#FFB347"),
        Category(sfSymbolName: "cross.case", categoryName: "Health", color: "#5cbdb9"),
        Category(sfSymbolName: "phone", categoryName: "Telephone", color: "#D8B2D1"),
        Category(sfSymbolName: "film.stack", categoryName: "Entertainment", color: "#0049B7"),
        Category(sfSymbolName: "cart", categoryName: "Shopping", color: "#00DDFF"),
        Category(sfSymbolName: "sportscourt", categoryName: "Sports", color: "#fff685"),
        Category(sfSymbolName: "pawprint", categoryName: "Pet", color: "#f75990"),
        Category(sfSymbolName: "popcorn", categoryName: "Snacks", color: "#ff1d58"),
        Category(sfSymbolName: "graduationcap", categoryName: "Education", color: "#BDFCC9"),
        Category(sfSymbolName: "tshirt", categoryName: "Clothes", color: "#FFD1A3"),
        Category(sfSymbolName: "checkmark.shield", categoryName: "Insurance", color: "#FFD8C0"),
        Category(sfSymbolName: "square.grid.3x3", categoryName: "Others", color: "#63b863"),
    ]
    
    static var incomeCategory: [Category] = [
        Category(sfSymbolName: "dollarsign.square" , categoryName: "Salary", color: "#006400"),
        Category(sfSymbolName: "house.lodge", categoryName: "Rental", color: "#800000"),
        Category(sfSymbolName: "trophy", categoryName: "Awards", color: "#ffc83b"),
        Category(sfSymbolName: "repeat", categoryName: "Refunds", color: "#4ab2f5"),
        Category(sfSymbolName: "gift", categoryName: "Grants", color: "#a945b9"),
        Category(sfSymbolName: "tag", categoryName: "Sale", color: "#ef4873"),
        Category(sfSymbolName: "ticket", categoryName: "Lottery", color: "#f95e4a"),
        Category(sfSymbolName: "chart.xyaxis.line", categoryName: "Dividends", color: "#47c4d9"),
        Category(sfSymbolName: "briefcase", categoryName: "Investments", color: "#FFDAB9"),
        Category(sfSymbolName: "square.grid.3x3", categoryName: "Others", color: "#63b863"),
    ]
    
    static func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func convertStringToDate(value: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: value) ?? Date()
    }
    
    static func getDateProperties(date: Date) -> (year: Int, month: Int, day: Int){
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        if let year = components.year, let month = components.month, let day = components.day {
            return (year,month,day)
        }
        return (0,0,0)
    }
    
    static func isCategoryPresent(_ text: String) -> Bool {
        let incomeCategories = Helper.incomeCategory
        let expenseCategories = Helper.expenseCategory
        for category in incomeCategories {
            if category.categoryName.caseInsensitiveCompare(text)  == .orderedSame {
                return true
            }
        }
        for category in expenseCategories {
            if category.categoryName.caseInsensitiveCompare(text)  == .orderedSame {
                return true
            }
        }
        return false
    }
     static func simplifyNumbers(_ arr: [String]) -> String {
        var sum: NSDecimalNumber = NSDecimalNumber.zero
        for str in arr {
            let number = NSDecimalNumber(string: str)
                sum = sum.adding(number)
        }
        
        var suffix = ""
        var formattedSum = sum
        if sum.doubleValue >= 1_000_000_000_000 {
            formattedSum = sum.dividing(by: NSDecimalNumber(value: 1_000_000_000_000))
            suffix = "T"
        } else if sum.doubleValue >= 1_000_000_000 {
            formattedSum = sum.dividing(by: NSDecimalNumber(value: 1_000_000_000))
            suffix = "B"
        } else if sum.doubleValue >= 1_000_000 {
            formattedSum = sum.dividing(by: NSDecimalNumber(value: 1_000_000))
            suffix = "M"
        } else if sum.doubleValue >= 1_000 {
            formattedSum = sum.dividing(by: NSDecimalNumber(value: 1_000))
            suffix = "K"
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        guard let formattedString = numberFormatter.string(from: formattedSum as NSNumber) else {
            return ""
        }
        return formattedString + suffix
    }

    
    static func simplifyDifferenceBetweenNumbers(_ numbers1: [String], _ numbers2: [String], _ precision: Int) -> String? {
        let count = max(numbers1.count, numbers2.count)
        
        var differenceSum: Double = 0.0
        
        for index in 0..<count {
            let numberString1 = index < numbers1.count ? numbers1[index] : "0"
            let numberString2 = index < numbers2.count ? numbers2[index] : "0"
            
            guard let number1 = Double(numberString1),
                  let number2 = Double(numberString2) else {
                return nil
            }
            
            let difference = number2 - number1
            differenceSum += difference
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = precision
        numberFormatter.groupingSeparator = "."
        
        if abs(differenceSum) >= 1000 {
            let power = min(Int(log10(abs(differenceSum)) / 3.0), 4)
            let suffix = ["", "K", "M", "B", "T"][power]
            
            let simplifiedNumber = differenceSum / pow(1000.0, Double(power))
            numberFormatter.maximumFractionDigits = power > 0 ? precision : 0
            
            if let simplifiedString = numberFormatter.string(from: NSNumber(value: simplifiedNumber)) {
                let truncatedString = String(simplifiedString.prefix(5))
                return truncatedString + suffix
            }
        } else {
            if let simplifiedString = numberFormatter.string(from: NSNumber(value: differenceSum)) {
                let formattedString = simplifiedString.replacingOccurrences(of: ".", with: "")
                return formattedString
            }
        }
        
        return "\(differenceSum)"
    }
    
    
    static func getSimplifiedAmount(_ records: [Record], _ type: Int16) -> String {
        var amount: [String]  = []
        for record in records {
            if record.type == type {
                amount.append(record.amount ?? "0")
            }
        }
        return simplifyNumbers(amount)
    }
    
    static func trimLeadingZeroes(inputStr: String) -> String {
      var resultStr = inputStr
        
      while resultStr.hasPrefix("0") && resultStr.count > 1 {
       resultStr.removeFirst()
      }
      return resultStr
    }

    
    static func convertToValueName(_ sum: NSDecimalNumber) -> String {
        var suffix = ""
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = .decimal
        decimalFormatter.maximumFractionDigits = 2
        
        let billion = NSDecimalNumber(string: "1000000000")
        let million = NSDecimalNumber(string: "1000000")
        let thousand = NSDecimalNumber(string: "1000")
        
        var mutableSum = sum
        
        if mutableSum.compare(billion) == .orderedDescending {
            mutableSum = mutableSum.dividing(by: billion)
            suffix = "B"
        } else if mutableSum.compare(million) == .orderedDescending {
            mutableSum = mutableSum.dividing(by: million)
            suffix = "M"
        } else if mutableSum.compare(thousand) == .orderedDescending {
            mutableSum = mutableSum.dividing(by: thousand)
            suffix = "K"
        }
        
        let formattedSum = decimalFormatter.string(from: mutableSum as NSNumber) ?? ""
        return formattedSum + suffix
    }
    
    static func sumStringArray(_ arr: [String]) -> NSDecimalNumber {
        var sum = NSDecimalNumber.zero
        for str in arr {
            let number = NSDecimalNumber(string: str)
            sum = sum.adding(number)
        }
        return sum
    }
    
    
    static func getRecordAmount(_ records: [Record], _ type: Int16) -> [String] {
        var amount: [String]  = []
        for record in records {
            if record.type == type {
                amount.append(record.amount ?? "0")
            }
        }
        return amount
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
    
    static func getGraphData(_ records: [Record], type: Int16, category: String) -> [GraphData] {
        lazy var graphData = [GraphData]()
        lazy var totalAmount = Double()
        for record in records {
            if record.type == type {
                if category == record.category ?? "" , let amount = record.amount {
                    totalAmount += (Double(amount) ?? 0)
                }
            }
        }
        for record in records {
            if record.type == type {
                if category == record.category {
                    graphData.append(GraphData(percentage: calculatePercentage(value: Double(record.amount ?? "") ?? 0, total: totalAmount), name: record.category ?? "", date: record.date ?? Date(), icon: record.icon ?? "" , amount: record.amount ?? "0", color: record.color ?? "#808080"))
                }
            }
        }
        return graphData
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
        for (_, (key, value)) in recordByCategory.enumerated() {
            lazy var icon = String()
            lazy var categoryAmount = Double()
            lazy var categoryColor = UIColor()
            for record in value {
                if let recordIcon = record.icon, let amount = record.amount, let color = record.color  {
                    icon =  recordIcon
                    categoryAmount += Double(amount) ?? 0
                    categoryColor = UIColor(hex: color) ?? .label
                }
            }
            chartData.append(ChartData(percentage: calculatePercentage(value: categoryAmount, total: totalAmount), sfSymbol: icon, name: key, color: categoryColor))
        }
        return chartData
    }
    
    static func generateDateForgraph(_ date: Date) -> [String] {
        var availableDates = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let inputYear = calendar.component(.year, from: date)
        let inputMonth = calendar.component(.month, from: date)
        var components = DateComponents()
        components.year = inputYear
        components.month = inputMonth
        components.day = 1
        if let firstDayOfMonth = calendar.date(from: components) {
            if let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) {
                for day in range {
                    components.day = day
                    if let date = calendar.date(from: components) {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        let formattedDate = dateFormatter.string(from: date)
                        availableDates.append(formattedDate)
                    }
                }
            }
        }
        return availableDates
    }
    
    static func getCategoryName(for icon: String) -> String {
        let customCategoryList = customCategory
        for (_, value) in customCategoryList {
            for category in value {
                if category.sfSymbolName == icon{
                    return category.categoryName
                }
            }
        }
        return ""
    }
    
    static func formatNumber(input: String) -> String {
        if let number = Double(input) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.groupingSeparator = ","
            
            if let formattedString = numberFormatter.string(from: NSNumber(value: number)) {
                return String(formattedString)
            }
        }
        return "0"
    }
    
    static func generateThemeColors(count: Int) -> [UIColor] {
        var colors: [UIColor] = []
        
        let hueRange: ClosedRange<CGFloat> = 0...1
        
        let brightness: CGFloat = 0.8
        let saturation: CGFloat = 0.8
        
        let hueIncrement = (hueRange.upperBound - hueRange.lowerBound) / CGFloat(count)
        
        for i in 0..<count {
            let hue = hueRange.lowerBound + CGFloat(i) * hueIncrement
            let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
            colors.append(color)
        }
        return colors
    }
    
    static func getMonthNumberForName(_ name: String) -> Int? {
        switch name {
        case "Jan":
            return 1
        case "Feb":
            return 2
        case "Mar":
            return 3
        case "Apr":
            return 4
        case "May":
            return 5
        case "Jun":
            return 6
        case "Jul":
            return 7
        case "Aug":
            return 8
        case "Sep":
            return 9
        case "Oct":
            return 10
        case "Nov":
            return 11
        case "Dec":
            return 12
        default:
            return 1
        }
        
    }
    
    
    static func getMonthName(_ number: Int) -> String? {
        switch number {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return ""
        }
    }
}




