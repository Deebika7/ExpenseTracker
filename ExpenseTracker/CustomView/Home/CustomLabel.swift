//
//  CustomLabel.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 11/05/23.
//

import Foundation
import UIKit
class CustomLabel : UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        super.drawText(in: rect.inset(by: insets))
    }
    
}
