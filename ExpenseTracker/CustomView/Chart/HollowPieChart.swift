//
//  HollowPieChart.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 19/05/23.
//

import UIKit

class HollowPieChart: UIView {
    
    var data: [Double: UIColor] = [:] {
        didSet {
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect)  {
        super.draw(rect)
        
        guard !data.isEmpty else {
            return
        }
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) * 0.4
        let innerRadius = radius * 0.6 // Adjust the inner radius as desired
        
        let totalValue = data.keys.reduce(0, +)
        var startAngle: CGFloat = 0
        
        for (key, value) in data {
            let endAngle = startAngle + (CGFloat(key) / CGFloat(totalValue)) * 2 * .pi
            
            let path = UIBezierPath()
            path.move(to: center)
            
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            path.addArc(withCenter: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
            
            path.close()
            
            let arcColor = value
            arcColor.setFill()
            path.fill()
                        
            startAngle = endAngle
        }
        
    }
    
}

