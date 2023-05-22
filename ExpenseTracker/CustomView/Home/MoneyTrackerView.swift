//
//  MoneyTrackerView.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class MoneyTrackerView: UIView {
    override func draw(_ rect: CGRect) {
        
        guard let redView = subviews.first else {
            return
        }
        
        let redPath = UIBezierPath()
        redPath.move(to: CGPoint(x: 0, y: 0))
        redPath.addLine(to: CGPoint(x: 0, y: redView.bounds.width))
        redPath.addLine(to: CGPoint(x: redView.frame.size.width - (redView.frame.size.width/3) - 35 , y: 0))
        redPath.addLine(to: CGPoint(x: redView.frame.size.width , y: 0.0))
        redPath.close()
        
        let redShapeLayer = CAShapeLayer()
        redShapeLayer.path = redPath.cgPath
        redView.layer.mask = redShapeLayer
        
    }
    
}
