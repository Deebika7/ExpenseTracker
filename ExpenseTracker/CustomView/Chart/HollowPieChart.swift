//
//  HollowPieChart.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 19/05/23.
//

import UIKit

class HollowPieChart: UIView {
    
    var data: [Double] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var colorByCategory: [String: UIColor] = [:]
    
    override func draw(_ rect: CGRect)  {
        super.draw(rect)
        
        guard !data.isEmpty else {
            return
        }
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) * 0.4
        let innerRadius = radius * 0.6 // Adjust the inner radius as desired
        
        let totalValue = data.reduce(0, +)
        var startAngle: CGFloat = 0
        
        for value in data {
            let endAngle = startAngle + (CGFloat(value) / CGFloat(totalValue)) * 2 * .pi
            
            let path = UIBezierPath()
            path.move(to: center)
            
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            path.addArc(withCenter: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
            
            path.close()
            
            let arcColor = UIColor.random()
            arcColor.setFill()
            path.fill()
            
//            colorByCategory[category] = arcColor
            
            startAngle = endAngle
        }
        
    }
    
}

extension UIColor {
    static func random() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
