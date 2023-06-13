//
//  NoDataFoundView.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/06/23.
//

import UIKit

class NoDataFoundView: UIView {
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.tintColor = .secondaryLabel
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var messageLabel: UILabel = {
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.font = UIFont.systemFont(ofSize: 30)
        message.textColor = UIColor.secondaryLabel
        message.textAlignment = .center
        return message
    }()
    
    init() {
        super.init(frame: .null)
    }
    
    convenience init(image: String, message: String) {
        self.init()
        imageView.image = UIImage(systemName: image)
        self.addSubview(imageView)
        messageLabel.text = message
        self.addSubview(messageLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
}
