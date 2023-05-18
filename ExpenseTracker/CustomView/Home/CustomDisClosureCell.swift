//
//  CustomDisClosureCell.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 12/05/23.
//

import UIKit

class CustomDisClosureCell: UITableViewCell {

    static let reuseIdentifier = "CustomDisclosure Cell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
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
    
    
    func configureCustomdisclosureCell(_ text: String){
        label.text = text
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        layoutIfNeeded()
    }
    
}
