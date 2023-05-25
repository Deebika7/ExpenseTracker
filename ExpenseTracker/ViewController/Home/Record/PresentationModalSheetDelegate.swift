//
//  PresentationModalSheetDelegate.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 24/05/23.
//

import Foundation

protocol PresentationModalSheetDelegate: AnyObject {
    func dismissedPresentationModalSheet(_ isDismissed: Bool)
}
