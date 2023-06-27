//
//  GraphCell.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/06/23.
//

import UIKit

class GraphCell: UITableViewCell {
    
    static let reuseIdentifier = "GraphCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private lazy var percentageLabel: UILabel = {
        let percentageLabel = UILabel()
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.font = UIFont.systemFont(ofSize: 16)
        return percentageLabel
    }()
    
    private lazy var categoryLabel: UILabel = {
       let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
       return dateLabel
    }()
    
    private lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints =  false
        return icon
    }()
    
    private lazy var amountLabel: UILabel = {
       let amountLabel = UILabel()
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.font = UIFont.systemFont(ofSize: 14)
        amountLabel.textColor = .label
       return amountLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(percentageLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(icon)
        contentView.addSubview(categoryLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            percentageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            percentageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: 35),
            icon.widthAnchor.constraint(equalToConstant: 35),
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            icon.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: 40),
            
            amountLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 16),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            amountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            categoryLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        ])
    }
    
    func configure( percentage: String, amount: String, category: Category, searchText: String) {
        let percentageAttributedString = NSMutableAttributedString(string: percentage + "%")
        if let range = percentage.range(of: searchText, options: .caseInsensitive) {
            let nsRange = NSRange(range, in: percentage)
            percentageAttributedString.addAttributes([.foregroundColor: UIColor.systemBlue], range: nsRange)
        }
        percentageLabel.attributedText = percentageAttributedString
        let categoryAttributedString = NSMutableAttributedString(string: category.categoryName)
        if let range = category.categoryName.range(of: searchText, options: .caseInsensitive) {
            let nsRange = NSRange(range, in: category.categoryName)
            categoryAttributedString.addAttributes([.foregroundColor: UIColor.systemBlue], range: nsRange)
        }
        categoryLabel.attributedText = categoryAttributedString
        let amountAttributedString = NSMutableAttributedString(string: amount)
        if let range = amount.range(of: searchText, options: .caseInsensitive) {
            let nsRange = NSRange(range, in: amount)
            amountAttributedString.addAttributes([.foregroundColor: UIColor.systemBlue], range: nsRange)
        }
        amountLabel.attributedText = amountAttributedString
        
        icon.image = UIImage(systemName: category.sfSymbolName)
        icon.tintColor = UIColor(hex: category.color)
    }

}
