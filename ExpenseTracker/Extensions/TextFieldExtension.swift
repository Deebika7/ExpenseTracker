//
//  TextFieldExtension.swift
//  ExpenseTrackerFinal
//
//  Created by deebika-pt6680 on 20/06/23.
//

import Foundation
import UIKit

extension UITextField {
    var isEmptyAfterTrimmed: Bool {
        return ((text?.trimmingCharacters(in: .whitespaces).isEmpty) != nil)
    }
}
