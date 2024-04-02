//
//  Gauge.swift
//  MyLittleAssistant
//
//  Created by imac on 02/04/24.
//

import UIKit


class GaugeView: UIView {
    var currentValue: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var minValue: CGFloat = 0.0
    var maxValue: CGFloat = 100.0
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        label.textAlignment = .center
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) * 0.4
        
        let startAngle = CGFloat(-Double.pi / 2)
        let endAngle = startAngle + (currentValue - minValue) / (maxValue - minValue) * CGFloat(Double.pi * 2)
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addLine(to: center)
        path.close()
        
        UIColor.white.setFill()
        path.fill()
        
        label.text = "\(Int(currentValue))"
        label.center = CGPoint(x: center.x, y: center.y + radius + 20)
    }
}

