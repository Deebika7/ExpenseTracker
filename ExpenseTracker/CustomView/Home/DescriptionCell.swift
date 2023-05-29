//
//  DescriptionCell.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 28/05/23.
//

import UIKit

class DescriptionCell: UITableViewCell {
    
    static let reuseIdentifier = "CustomDescriptionCell"
    
    private lazy var descriptionLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private lazy var descriptiontitle: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptiontitle)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 114),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            descriptiontitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptiontitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configureCell(title: String, text: String) {
        descriptiontitle.text = "\(title) "
        descriptionLabel.text = text
        descriptiontitle.textColor = UIColor.darkGray
        descriptiontitle.font = UIFont.systemFont(ofSize: 15)
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

}
