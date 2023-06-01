//
//  Constants.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 22/05/23.
//

import Foundation

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
    
}




