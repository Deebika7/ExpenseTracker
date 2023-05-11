//
//  AddRecordCell.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 11/05/23.
//

import UIKit

class AddRecordCell: UITableViewCell {
    
    static let reuseIdentifier = "Add Record"
    
    private lazy var label: UILabel = {
        let label = CustomLabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15)
       // label.backgroundColor = .secondarySystemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .tertiarySystemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var lineSeparator: UIView = {
        let lineSeparator = UIView()
        lineSeparator.backgroundColor = .secondarySystemBackground
        lineSeparator.translatesAutoresizingMaskIntoConstraints = false
        return lineSeparator
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(textField)
        contentView.addSubview(lineSeparator)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            lineSeparator.heightAnchor.constraint(equalToConstant: 1),
            lineSeparator.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            lineSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabelText(_ text: String ) {
        label.text = text
    }
    
   
    

    
}
