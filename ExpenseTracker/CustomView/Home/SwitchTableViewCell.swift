//
//  SwitchTableViewCell.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 01/06/23.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "reusableSwitchTableViewCell"
    
    private lazy var blurEffectSwitch: UISwitch = {
        let blurEffectSwitch = UISwitch()
        blurEffectSwitch.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectSwitch
    }()
    
    private lazy var blurEffectLabel: UILabel = {
        let blurEffectLabel = UILabel()
        blurEffectLabel.translatesAutoresizingMaskIntoConstraints = false
        blurEffectLabel.text = "Blur Foreground Content"
        return blurEffectLabel
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(blurEffectSwitch)
        contentView.addSubview(blurEffectLabel)
        blurEffectSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        setupCellLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func switchValueChanged() {
        if blurEffectSwitch.isOn {
            UserDefaultManager.shared.saveContentBlurEffect(true)
        }
        else {
            UserDefaultManager.shared.saveContentBlurEffect(false)
        }
    }
    
    private func setupCellLayout() {
        NSLayoutConstraint.activate([
            blurEffectSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            blurEffectSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            blurEffectSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            blurEffectLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            blurEffectLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
        ])
    }

}
