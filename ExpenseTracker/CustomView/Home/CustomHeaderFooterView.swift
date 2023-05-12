//
//  CustomHeaderFooterView.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 12/05/23.
//

import Foundation
import UIKit

class CustomHeaderFooterView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "customHeaderFooterView"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureView(with title: String) {
        textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        textLabel?.text = title
        textLabel?.textColor = .label
    }
}

