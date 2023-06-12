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
        percentageLabel.font = UIFont.systemFont(ofSize: 12)
        return percentageLabel
    }()
    
    private lazy var dateLabel: UILabel = {
       let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
       return dateLabel
    }()
    
    private lazy var amountLabel: UILabel = {
       let amountLabel = UILabel()
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.font = UIFont.systemFont(ofSize: 12)
//        amountLabel.textColor = .
       return amountLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(percentageLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            percentageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            percentageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 60),
            
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configure(percentage: String, date: String, amount: String) {
        percentageLabel.text = percentage + "%"
        dateLabel.text = date
        amountLabel.text = amount
    }

}
