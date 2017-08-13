//
//  TurnKnobView.swift
//  TurnKnob
//
//  Created by Daniel Hjärtström on 2017-08-12.
//  Copyright © 2017 Daniel Hjärtström. All rights reserved.
//

import UIKit

class TurnKnobView: UIView {

    var knobColor: UIColor = UIColor.black
    var knobCircleColor: UIColor = UIColor.white
    var stepsColor: UIColor = UIColor.black
    
    var π = Double.pi
    var maxValue = 100
    
    override func draw(_ rect: CGRect) {
        
        // Knob black circle
        
        let innerRadius = rect.width / 5
        let innerStartAngle = 3.0 * π / 2.0
        let innerEndAngle = innerStartAngle + (4.0 * π / 2.0)
        
        let knobPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: innerRadius, startAngle: CGFloat(innerStartAngle), endAngle: CGFloat(innerEndAngle), clockwise: true)
        
        knobColor.setFill()
        knobPath.fill()
        
        // Outer circle

        let outerRadius = rect.width / 3
        let outerStartAngle = π
        let outerEndAngle = π * 2.0
        var pattern = [CGFloat]()
        
        let valueCircle = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: outerRadius, startAngle: CGFloat(outerStartAngle), endAngle: CGFloat(outerEndAngle), clockwise: true)

        valueCircle.lineWidth = 3.0
        valueCircle.lineCapStyle = .round
        stepsColor.setStroke()
        
        let circleLength = π * Double(outerRadius * 2.0) / 2
        
        let dashSize: CGFloat = CGFloat(circleLength / Double(maxValue))
        
        for _ in (0..<100) {
        
            pattern.append(dashSize * 0.01)
            pattern.append(dashSize + dashSize * 0.4)
        }
        
        valueCircle.setLineDash(pattern, count: pattern.count, phase: 0)
        
        valueCircle.stroke()
       
        
        // Knob white circle
        
        let knobCirclePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: innerRadius - 5, startAngle: CGFloat(innerStartAngle), endAngle: CGFloat(innerEndAngle), clockwise: true)
        
        knobCirclePath.lineWidth = 3.0
        
        knobCircleColor.setStroke()
        knobCirclePath.stroke()

        
        // Knob line
 
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: self.frame.width / 2 - innerRadius + 5, y: self.frame.height / 2))
        
        linePath.addLine(to: CGPoint(x: self.frame.width / 2 - innerRadius / 3, y: self.frame.width / 2))
        
        linePath.lineWidth = 3.0
        knobCircleColor.setStroke()
        linePath.stroke()
        
    }
}
