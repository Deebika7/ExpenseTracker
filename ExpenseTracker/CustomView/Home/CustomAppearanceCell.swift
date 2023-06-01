//
//  CustomAppearanceCell.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 29/05/23.
//

import UIKit

class CustomAppearanceCell: UITableViewCell {
    
    static let reuseIdentifier = "CustomAppearanceCell"

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "System", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Light", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Dark", at: 2, animated: true)
        segmentedControl.addTarget(self, action: #selector(switchSegmentedControl), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var themeLabel: UILabel = {
        let themeLabel = UILabel()
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        themeLabel.text = "Appearance"
        return themeLabel
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(themeLabel)
        contentView.addSubview(segmentedControl)
        setupConstraints()
        if let selectedAppearance = UserDefaultManager.shared.getSelectedAppearance() {
            segmentedControl.selectedSegmentIndex = selectedAppearance.rawValue
        }
        else {
            segmentedControl.selectedSegmentIndex = 0
        }
        switchSegmentedControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            themeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            themeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            segmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @objc func switchSegmentedControl() {
        if let selectedAppearance = UIUserInterfaceStyle(rawValue: segmentedControl.selectedSegmentIndex) {
            UserDefaultManager.shared.saveSelectedAppearance(selectedAppearance)
            segmentedControl.selectedSegmentIndex = selectedAppearance.rawValue
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    window.overrideUserInterfaceStyle = selectedAppearance
                }
            }
        }
    }
}
