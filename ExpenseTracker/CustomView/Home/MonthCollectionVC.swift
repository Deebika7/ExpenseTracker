//
//  MonthCollectionView.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 30/05/23.
//

import UIKit

class MonthCollectionVC: UIView {
    
    
    weak var monthSelectionDelegate: MonthSelectionDelegate?
    

    lazy var yearView: UIView = {
        let yearView = UIView()
        yearView.backgroundColor = .systemGroupedBackground
        yearView.translatesAutoresizingMaskIntoConstraints = false
        return yearView
    }()
    
    lazy var forwardChevron: UIButton = {
        let forwardChevron = UIButton()
        forwardChevron.tintColor = .label
        forwardChevron.translatesAutoresizingMaskIntoConstraints = false
        forwardChevron.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return forwardChevron
    }()
    
    lazy var backwardChevron: UIButton = {
        let backwardChevron = UIButton()
        backwardChevron.tintColor = .label
        backwardChevron.translatesAutoresizingMaskIntoConstraints = false
        backwardChevron.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return backwardChevron
    }()
    
    lazy var yearLabel: UILabel = {
        let yearLabel = UILabel()
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.text = "\(Helper.getDateProperties(date: Date()).year)"
        yearLabel.font = UIFont.systemFont(ofSize: 22)
        return yearLabel
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.estimatedItemSize = CGSize(width: 82, height: 40)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()
    
    func configureView() {
        yearView.addSubview(forwardChevron)
        yearView.addSubview(backwardChevron)
        yearView.addSubview(yearLabel)
        
        self.addSubview(yearView)
        self.addSubview(collectionView)
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: yearView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            collectionView.heightAnchor.constraint(equalToConstant: 200),

            yearView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            yearView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            yearView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            yearView.heightAnchor.constraint(equalToConstant: 50),
                                    
            forwardChevron.centerYAnchor.constraint(equalTo: yearView.centerYAnchor),
            forwardChevron.trailingAnchor.constraint(equalTo: yearView.trailingAnchor, constant: -25),
            
            backwardChevron.centerYAnchor.constraint(equalTo: yearView.centerYAnchor),
            backwardChevron.leadingAnchor.constraint(equalTo: yearView.leadingAnchor, constant: 25),
            
            yearLabel.centerYAnchor.constraint(equalTo: yearView.centerYAnchor),
            yearLabel.centerXAnchor.constraint(equalTo: yearView.centerXAnchor, constant: -4),
            yearLabel.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    private func getYear() -> Int {
        Int(yearLabel.text!) ?? 0
    }
}


