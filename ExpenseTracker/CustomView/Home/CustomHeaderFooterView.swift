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
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headerLabel)
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
        headerLabel.text = title
        headerLabel.textColor = .label
        headerLabel.adjustsFontForContentSizeCategory = true
        headerLabel.font = .boldSystemFont(ofSize: 18)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

