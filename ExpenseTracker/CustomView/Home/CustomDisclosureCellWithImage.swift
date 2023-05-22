//
//  CustomDisClosureCell.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 12/05/23.
//

import UIKit

class CustomDisClosureCellWithImage: UITableViewCell {
    
    static let reuseIdentifier = "CustomDisclosure Cell with Image"
    
    private lazy var label = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.adjustsFontForContentSizeCategory = true
        return $0
    }(UILabel())
    
    private lazy var categoryIcon: UIImageView = {
        let categoryIcon = UIImageView()
        categoryIcon.translatesAutoresizingMaskIntoConstraints = false
        categoryIcon.adjustsImageSizeForAccessibilityContentSizeCategory = true
        return categoryIcon
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(categoryIcon)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            label.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            
            categoryIcon.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: -120),
            categoryIcon.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            categoryIcon.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override var intrinsicContentSize: CGSize {
        return contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    func configure(with name: String, and text: String)  {
        categoryIcon.image = UIImage(systemName: name)
        categoryIcon.tintColor = .label
        label.text = text
        label.font = .preferredFont(forTextStyle: .body)
        label.isUserInteractionEnabled = true
        label.textColor = .label
        label.adjustsFontForContentSizeCategory = true
    }
    
}
