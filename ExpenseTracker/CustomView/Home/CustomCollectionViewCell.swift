//
//  CustomCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 30/05/23.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(capsuleView)
        contentView.addSubview(textLabel)
        setupCellLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private lazy var capsuleView: UIView = {
        let capsuleView = UIView()
        capsuleView.layer.cornerRadius = 20
        capsuleView.backgroundColor = .secondarySystemGroupedBackground
        capsuleView.translatesAutoresizingMaskIntoConstraints = false
        return capsuleView
    }()
    
    private func setupCellLayout() {
        NSLayoutConstraint.activate([
            capsuleView.heightAnchor.constraint(equalToConstant: 40),
            capsuleView.widthAnchor.constraint(equalToConstant: 82),
            textLabel.centerXAnchor.constraint(equalTo: capsuleView.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: capsuleView.centerYAnchor)
        ])
    }
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    func configure(_ text : String) {
        textLabel.text = text
    }
}
