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
        return message
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    init() {
        super.init(frame: .null)
    }
    
    convenience init(image: String, message: String) {
        self.init()
        imageView.image = UIImage(systemName: image)
        containerView.addSubview(imageView)
        messageLabel.text = message
        containerView.addSubview(messageLabel)
        addSubview(containerView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
    }
    
}
