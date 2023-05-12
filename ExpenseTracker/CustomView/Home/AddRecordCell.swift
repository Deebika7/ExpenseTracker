//
//  AddRecordCell.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 11/05/23.
//

import UIKit

class AddRecordCell: UITableViewCell {
    
    static let reuseIdentifier = "Add Record"
    
    lazy var customView: UIView = {
        let customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
         
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for subView in customView.subviews {
            subView.removeFromSuperview()
        }
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomCell(customCell :(UIView) -> Void) {
        customCell(customView)
    }
    
    func configureLabel(_ text: String){
        label.text = text
    }

}
