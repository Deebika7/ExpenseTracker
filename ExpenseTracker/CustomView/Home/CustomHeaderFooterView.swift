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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override var intrinsicContentSize: CGSize {
        return contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    
    func configureView(with title: String) {
        textLabel?.text = title
        textLabel?.textColor = .label
        textLabel?.adjustsFontForContentSizeCategory = true
        textLabel?.font = UIFont.boldSystemFont(ofSize: textLabel!.font.pointSize)
    }
}

