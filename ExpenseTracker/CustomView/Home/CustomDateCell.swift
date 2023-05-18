//
//  CustomDateCell.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 15/05/23.
//

import UIKit

class CustomDateCell: UITableViewCell {

    static let reuseIdentifier = "CustomDate Cell"
    
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
            label.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -40)
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
    
    func configureCustomDateCell(_ text: String){
        label.text = String(text)
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .body)
    }
}
