//
//  CustomSectionView.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 10/05/23.
//

import UIKit

class CustomSectionView: UITableViewHeaderFooterView {

    static let reuseIdentifier = "tableSection"
    
    lazy var incomeSymbol = UIImageView()
    lazy var expenseSymbol =  UIImageView()
    
    override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
        
    }
        
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    
    

}
