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
    
    func configureView(with title: String, bold: Bool) {
        headerLabel.text = title
        headerLabel.textColor = .label
        headerLabel.font = bold ? .boldSystemFont(ofSize: 18) : .systemFont(ofSize: 16)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

