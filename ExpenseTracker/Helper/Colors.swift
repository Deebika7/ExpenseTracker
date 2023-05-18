//
//  Colors.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 11/05/23.
//

import Foundation
import UIKit

class Colors {
    static let shared = Colors()
    private init(){}
   

    func colorWithHexString(hexString: String) -> UIColor {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    

    
}
