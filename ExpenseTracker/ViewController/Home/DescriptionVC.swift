//
//  DescriptionVC.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 28/05/23.
//

import UIKit

class DescriptionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, PresentationModalSheetDelegate {
    
    private var recordId: UUID?
        
    private lazy var record: Record = RecordDataManager.shared.getRecord(id: recordId ?? UUID())
    
    @objc func editRecord() {
        let recordVC = RecordVC(editRecord: record)
        recordVC.presentationModalSheetDelegate = self
        let navigationController = UINavigationController(rootViewController: recordVC)
        present(navigationController, animated: true)
    }
    
    @objc func dismissDescriptionVC() {
        dismiss(animated: true)
    }
    
    private lazy var edit: UIBarButtonItem = {
        let edit = UIBarButtonItem(image:  UIImage(systemName: "pencil"), style: .done, target: self, action: #selector(editRecord))
        return edit
    }()
    
    private lazy var delete: UIBarButtonItem = {
        let trashButton = UIBarButtonItem(image:  UIImage(systemName: "trash"), style: .done, target: self, action: #selector(deleteRecord))
        trashButton.tintColor = UIColor.systemRed
        return trashButton
    }()
    
    @objc func deleteRecord() {
        let alert = UIAlertController(title: "Delete", message: "Are you sure want to delete this record", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {_ in
            RecordDataManager.shared.deleteRecord(id: self.record.id ?? UUID())
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                self.dismiss(animated: true){ [weak self] in
                    if (self?.presentingViewController?.presentedViewController) != nil {
                        self?.dismiss(animated: true)
                    }
                    else {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }))
        self.present(alert, animated: true)
        
    }
    
    init(recordId: UUID?) {
        self.recordId = recordId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        record = RecordDataManager.shared.getRecord(id: recordId ?? UUID())
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DescriptionCell")
        navigationItem.rightBarButtonItems = [delete, edit]
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.reuseIdentifier)
        if presentingViewController != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissDescriptionVC))
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath)
            var configuration = cell.defaultContentConfiguration()
            configuration.image = UIImage(systemName: record.icon ?? "")
            configuration.imageToTextPadding = 70
            configuration.imageProperties.tintColor = .label
            configuration.text = record.category
            configuration.textProperties.font = UIFont.boldSystemFont(ofSize: 20)
            cell.contentConfiguration = configuration
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.reuseIdentifier, for: indexPath) as? DescriptionCell else {
                return UITableViewCell()
            }
            if indexPath.row == 1 {
                cell.configureCell(title: "Type", text: RecordType.allCases[Int(record.type)].rawValue)
            }
            else if indexPath.row == 2 {
                cell.configureCell(title: "Category", text: record.category ?? "")
            }
            else if indexPath.row == 3 {
                cell.configureCell(title: "Amount", text: record.amount ?? "")
            }
            else if indexPath.row == 4 {
                cell.configureCell(title: "Date", text: Helper.convertDateToString(date: record.date ?? Date()))
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else {
            return 44
        }
    }
    
    func dismissedPresentationModalSheet(_ isDismissed: Bool) {
        if isDismissed {
            record = RecordDataManager.shared.getRecord(id: recordId ?? UUID())
            tableView.reloadData()
        }
    }
    
}
