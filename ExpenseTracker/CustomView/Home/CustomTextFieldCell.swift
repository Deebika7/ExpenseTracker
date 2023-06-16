//
//  CustomTextFieldCell.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 12/05/23.
//

import UIKit

class CustomTextFieldCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {
    
    static let reuseIdentifier = "Custom Text Field Cell"
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.adjustsFontForContentSizeCategory = true
        textField.textColor = .label
        textField.delegate = self
        textField.addTarget(self, action:  #selector(handleOnEditing), for: .editingChanged)
        return textField
    }()
    
    lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.textColor = .placeholderText
        countLabel.text = "0/8"
        return countLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        contentView.addSubview(countLabel)
        textField.adjustsFontForContentSizeCategory = true
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -16),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44),
            
            countLabel.heightAnchor.constraint(equalToConstant: 20),
            countLabel.widthAnchor.constraint(equalToConstant: 30),
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureNumberKeyBoard() {
        textField.keyboardType = .decimalPad
        textField.font = .preferredFont(forTextStyle: .body)
        textField.placeholder = "Enter Amount"
        if let text = textField.text {
            countLabel.text = "\(text.count)/8"
        }
        
    }
    
    func getEnteredData() -> String {
        textField.text ?? ""
    }
    
    // MARK: Textfield Delegate
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
    @objc func handleOnEditing() {
        let text = textField.text ?? ""
        let limit = 8
        textField.text = String(text.prefix(limit))
        if let text = textField.text {
            countLabel.text = "\(text.count)/8"
        }
    }
}

