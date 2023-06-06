////
////  GraphVC.swift
////  ExpenseTracker
////
////  Created by deebika-pt6680 on 09/05/23.
////
//
//import UIKit
//import Charts
//import SwiftUI
//
//class GraphVC: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemGroupedBackground
//        view.backgroundColor = .white
//        let controller = UIHostingController(rootView: ExpenseGraph())
//        guard let expenseGraph = controller.view else {
//            return
//        }
//        view.addSubview(expenseGraph)
//        expenseGraph.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            expenseGraph.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            expenseGraph.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            expenseGraph.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        ])
//    }
//}
