//
//  MoneyTrackerSectionHeaderView.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 26/05/23.
//

import UIKit

class MoneyTrackerSectionHeaderView: UITableViewHeaderFooterView {

    static let reuseIdentifier = "moneyTrackerHeaderView"
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .secondaryLabel
        return dateLabel
    }()
    
    private lazy var expenseAmount: UILabel = {
        let expenseAmount = UILabel()
        expenseAmount.translatesAutoresizingMaskIntoConstraints = false
        expenseAmount.textColor = UIColor(named: "red")
        return expenseAmount
    }()
    
    private lazy var expenseSymbol: UIImageView = {
        let expenseSymbol = UIImageView()
        expenseSymbol.image = UIImage(systemName: "arrow.down.app.fill")
        expenseSymbol.tintColor = UIColor(named: "red")
        expenseSymbol.translatesAutoresizingMaskIntoConstraints = false
        return expenseSymbol
    }()
    
    private lazy var incomeSymbol: UIImageView = {
        let incomeSymbol = UIImageView()
        incomeSymbol.image = UIImage(systemName: "arrow.up.square.fill")
        incomeSymbol.tintColor = UIColor(named: "blue")
        incomeSymbol.translatesAutoresizingMaskIntoConstraints = false
        return incomeSymbol
    }()
    
    private lazy var incomeAmount: UILabel = {
        let incomeAmount = UILabel()
        incomeAmount.translatesAutoresizingMaskIntoConstraints = false
        incomeAmount.textColor = UIColor(named: "blue")
        return incomeAmount
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(incomeAmount)
        contentView.addSubview(expenseAmount)
        contentView.addSubview(dateLabel)
        contentView.addSubview(expenseSymbol)
        contentView.addSubview(incomeSymbol)
        setupContraints()
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
            
            incomeAmount.leadingAnchor.constraint(equalTo: incomeSymbol.trailingAnchor, constant: 3),
            incomeAmount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            incomeAmount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
            incomeSymbol.trailingAnchor.constraint(equalTo: incomeAmount.leadingAnchor, constant: -3),
            incomeSymbol.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
            
            expenseSymbol.trailingAnchor.constraint(equalTo: expenseAmount.leadingAnchor, constant: -3),
            expenseSymbol.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
            expenseAmount.trailingAnchor.constraint(equalTo: incomeSymbol.leadingAnchor, constant: -8),
            expenseAmount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
        ])
    }
    
    func configure(date: Date, incomeAmount: Double, expenseAmount: Double) {
        dateLabel.text = Helper.convertDateToString(date: date)
        self.incomeAmount.text = String(incomeAmount)
        self.expenseAmount.text = String(expenseAmount)
    }
    
}
