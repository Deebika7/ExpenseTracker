//
//  CategoryCell.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 14/05/23.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    static let resuseIdentifier = "CategoryCell"
    
    private lazy var categoryIcon: UIImageView = {
        let categoryIcon = UIImageView()
        categoryIcon.translatesAutoresizingMaskIntoConstraints = false
        categoryIcon.adjustsImageSizeForAccessibilityContentSizeCategory = true
        return categoryIcon
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(categoryIcon)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            categoryIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            categoryIcon.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -300),
            categoryIcon.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: categoryIcon.trailingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }
    

    func configure(with name: String, and text: String) {
        categoryIcon.image = UIImage(systemName: name)
        categoryIcon.tintColor = .label
        label.text = text
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
    }
    
}
