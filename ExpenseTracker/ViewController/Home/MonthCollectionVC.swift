//
//  MonthCollectionView.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 30/05/23.
//

import UIKit

class MonthCollectionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private lazy var dataSource: [(String, Int)] = Helper.dataSource
    
    weak var monthSelectionDelegate: MonthSelectionDelegate?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    private lazy var yearView: UIView = {
        let yearView = UIView()
        yearView.backgroundColor = .systemGroupedBackground
        yearView.translatesAutoresizingMaskIntoConstraints = false
        return yearView
    }()
    
    private lazy var forwardChevron: UIImageView = {
        let forwardChevron = UIImageView()
        forwardChevron.image = UIImage(systemName: "chevron.forward")
        forwardChevron.tintColor = .label
        forwardChevron.isUserInteractionEnabled = true
        forwardChevron.translatesAutoresizingMaskIntoConstraints = false
        return forwardChevron
    }()
    
    private lazy var backwardChevron: UIImageView = {
        let backwardChevron = UIImageView()
        backwardChevron.image = UIImage(systemName: "chevron.backward")
        backwardChevron.isUserInteractionEnabled = true
        backwardChevron.tintColor = .label
        backwardChevron.translatesAutoresizingMaskIntoConstraints = false
        return backwardChevron
    }()
    
    private lazy var yearLabel: UILabel = {
        let yearLabel = UILabel()
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.font = UIFont.systemFont(ofSize: 22)
        yearLabel.text = "\(Helper.getDateProperties(date: Date()).year)"
        return yearLabel
    }()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        if indexPath.section == 0 {
            cell.configure(dataSource[indexPath.row].0)
        }
        else if indexPath.section == 1 {
            cell.configure(dataSource[indexPath.row + 4].0)
        }
        else{
            cell.configure(dataSource[indexPath.row + 8].0)
        }
        cell.layer.shadowColor = UIColor.systemGray.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 4
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 {
            print(dataSource[indexPath.row])
            monthSelectionDelegate?.selectedMonth((name:dataSource[indexPath.row].0 , number:dataSource[indexPath.row].1), year: getYear())
        }
        else if indexPath.section == 1 {
            print(dataSource[indexPath.row + 4])
            monthSelectionDelegate?.selectedMonth((name:dataSource[indexPath.row+4].0 , number:dataSource[indexPath.row+4].1), year: getYear())
        }
        else if indexPath.section == 2 {
            print(dataSource[indexPath.row + 8])
            monthSelectionDelegate?.selectedMonth((name:dataSource[indexPath.row+8].0 , number:dataSource[indexPath.row+8].1), year: getYear())
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 32, bottom: 8, right: -16)
        flowLayout.minimumInteritemSpacing = 36
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(yearView)
        yearView.addSubview(forwardChevron)
        yearView.addSubview(backwardChevron)
        view.addSubview(yearLabel)
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        NSLayoutConstraint.activate([
            yearView.topAnchor.constraint(equalTo: view.topAnchor),
            yearView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            yearView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                    
                                    
            collectionView.topAnchor.constraint(equalTo: yearView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 210),
            
            forwardChevron.topAnchor.constraint(equalTo: yearView.topAnchor, constant: 30),
            forwardChevron.trailingAnchor.constraint(equalTo: yearView.trailingAnchor,constant: -54),
            
            
            backwardChevron.topAnchor.constraint(equalTo: yearView.topAnchor, constant: 30),
            backwardChevron.leadingAnchor.constraint(equalTo: yearView.leadingAnchor,constant: 40),
            
            yearLabel.centerYAnchor.constraint(equalTo: yearView.centerYAnchor),
            yearLabel.centerXAnchor.constraint(equalTo: yearView.centerXAnchor, constant: -4),
            yearLabel.topAnchor.constraint(equalTo: yearView.topAnchor, constant: 10),
            yearLabel.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        let backwardChevronTapGesture = UITapGestureRecognizer(target: self, action: #selector(backwardChevronTapped))
        backwardChevron.addGestureRecognizer(backwardChevronTapGesture)
        
        let forwardChevronTapGesture = UITapGestureRecognizer(target: self, action: #selector(forwardChevronTapped))
        forwardChevron.addGestureRecognizer(forwardChevronTapGesture)
    }
    
    @objc func backwardChevronTapped() {
        let value = Int(yearLabel.text ?? "0")!
        yearLabel.text = (value > 0) ? "\(value - 1)" : "0"
    }
    
    @objc func forwardChevronTapped() {
        let value = Int(yearLabel.text ?? "0")!
        yearLabel.text = "\(value + 1)"
    }
    
    private func getYear() -> Int {
        Int(yearLabel.text!) ?? 0
    }
}


