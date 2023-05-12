//
//  RecordLabel.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 11/05/23.
//

import UIKit

class RecordLabel: UITableViewCell {

    static let  reuseIdentifier = "recordLabel"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .secondarySystemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

    
    

}
