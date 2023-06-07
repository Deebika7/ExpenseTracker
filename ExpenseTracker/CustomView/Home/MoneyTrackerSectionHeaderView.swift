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
    
    private lazy var incomeAmount: UILabel = {
        let expenseAmount = UILabel()
        expenseAmount.translatesAutoresizingMaskIntoConstraints = false
        expenseAmount.textColor = UIColor(named: "blue")
        return expenseAmount
    }()
    
    private lazy var incomeSymbol: UIImageView = {
        let expenseSymbol = UIImageView()
        expenseSymbol.image = UIImage(systemName: "arrow.up.square.fill")
        expenseSymbol.tintColor = UIColor(named: "blue")
        expenseSymbol.translatesAutoresizingMaskIntoConstraints = false
        return expenseSymbol
    }()
    
    private lazy var expenseSymbol: UIImageView = {
        let incomeSymbol = UIImageView()
        incomeSymbol.image = UIImage(systemName: "arrow.down.square.fill")
        incomeSymbol.tintColor = UIColor(named: "red")
        incomeSymbol.translatesAutoresizingMaskIntoConstraints = false
        return incomeSymbol
    }()
    
    private lazy var expenseAmount: UILabel = {
        let incomeAmount = UILabel()
        incomeAmount.translatesAutoresizingMaskIntoConstraints = false
        incomeAmount.textColor = UIColor(named: "red")
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
        contentView.addSubview(expenseAmount)
        contentView.addSubview(incomeAmount)
        contentView.addSubview(dateLabel)
        contentView.addSubview(incomeSymbol)
        contentView.addSubview(expenseSymbol)
        setupContraints()
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
            expenseAmount.leadingAnchor.constraint(equalTo: expenseSymbol.trailingAnchor, constant: 3),
            expenseAmount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            expenseAmount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
            
            expenseSymbol.trailingAnchor.constraint(equalTo: expenseAmount.leadingAnchor, constant: -3),
            expenseSymbol.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
            
            incomeSymbol.trailingAnchor.constraint(equalTo: incomeAmount.leadingAnchor, constant: -3),
            incomeSymbol.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
            
            incomeAmount.trailingAnchor.constraint(equalTo: expenseSymbol.leadingAnchor, constant: -8),
            incomeAmount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
        ])
    }
    
//    func setupBothConstraints() {
//        NSLayoutConstraint.activate([
//            expenseAmount.leadingAnchor.constraint(equalTo: expenseSymbol.trailingAnchor, constant: 3),
//            expenseAmount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
//            expenseAmount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
//
//            expenseSymbol.trailingAnchor.constraint(equalTo: expenseAmount.leadingAnchor, constant: -3),
//            expenseSymbol.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
//
//            incomeSymbol.trailingAnchor.constraint(equalTo: incomeAmount.leadingAnchor, constant: -3),
//            incomeSymbol.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
//
//            incomeAmount.trailingAnchor.constraint(equalTo: expenseSymbol.leadingAnchor, constant: -8),
//            incomeAmount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
//        ])
//    }

    func configure(date: Date, incomeAmount: String, expenseAmount: String) {
        dateLabel.text = Helper.convertDateToString(date: date)
        self.expenseAmount.text = expenseAmount
        self.incomeAmount.text = incomeAmount
        
    }
    
}
