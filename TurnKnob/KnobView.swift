//
//  KnobView.swift
//  TurnKnob
//
//  Created by Daniel Hjärtström on 2017-08-12.
//  Copyright © 2017 Daniel Hjärtström. All rights reserved.
//

import UIKit

protocol UpdateValueProtocol {
    func updateKnobValue(value: Int)
}

class KnobView: UIView {

    var delegate: UpdateValueProtocol?
    
    var knobBgColor: CGColor = UIColor.black.cgColor
    var knobDetailsColor: CGColor = UIColor.white.cgColor
    var measurePathColor: CGColor = UIColor.black.cgColor
    var strokeValueColor: CGColor = UIColor.red.cgColor
    var clearColor: CGColor = UIColor.clear.cgColor
    
    var knobLayer: CAShapeLayer!
    var measurePathLayer: CAShapeLayer!
    var strokeValuePathLayer: CAShapeLayer!
    var gradient: CAGradientLayer!
    
    var π = Double.pi
    var currentStroke: CGFloat = 0.0
    var minAngle: CGFloat = CGFloat(Double.pi)
    var maxAngle: CGFloat = CGFloat(2 * Double.pi)
    var maxValue: CGFloat = 0.0
    
    var rotationReducerValue: CGFloat = 1.9
    
    var label: UILabel!

    convenience init(rect: CGRect, maxValue: CGFloat) {
        self.init(frame: rect)
    
        self.maxValue = maxValue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        drawStrokeValuePath()
        drawValuePath()
        drawKnobPath()
        addValueLabel()
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(sender:)))
        self.addGestureRecognizer(rotationGesture)
        
    }
    
    func didRotate(sender: UIRotationGestureRecognizer) {
        strokePath(strokeEnd: sender.rotation / maxValue * rotationReducerValue + currentStroke)
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    
    func drawKnobPath() {

        let radius = self.frame.width / 5
        let startAngle = 3.0 * π / 2.0
        let endAngle = startAngle + (4.0 * π / 2.0)
        
        let knobPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        
        knobLayer = CAShapeLayer()
        knobLayer.frame = bounds
        knobLayer.path = knobPath.cgPath
        knobLayer.fillColor = knobBgColor
        knobLayer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        knobLayer.shadowOpacity = 0.7
        knobLayer.shadowRadius = 5
        knobLayer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
       
        // Inner circle
        
        let innerCircle = CAShapeLayer()
        let innerCirclePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: radius - 5, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        innerCirclePath.move(to: CGPoint(x: self.frame.width / 2 - radius + 5, y: self.frame.height / 2))
        innerCirclePath.addLine(to: CGPoint(x: self.frame.width / 2 - radius / 2, y: self.frame.width / 2))
        
        innerCircle.path = innerCirclePath.cgPath
        innerCircle.fillColor = clearColor
        innerCircle.strokeColor = knobDetailsColor
        innerCirclePath.lineWidth = 4.0
        
        knobLayer.addSublayer(innerCircle)
        self.layer.addSublayer(knobLayer)
    }
    
    func drawValuePath() {
        
        let radius = self.frame.width / 3
        let startAngle = minAngle
        let endAngle = maxAngle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)

        measurePathLayer = CAShapeLayer()
        measurePathLayer.frame = bounds
        measurePathLayer.path = circlePath.cgPath
        measurePathLayer.lineWidth = 2.0
        measurePathLayer.strokeColor = UIColor.red.cgColor
        measurePathLayer.fillColor = UIColor.clear.cgColor
        measurePathLayer.lineJoin = kCALineJoinRound
        measurePathLayer.lineDashPattern = [NSNumber(value:Float(2)), NSNumber(value: Float(3))]

        self.layer.addSublayer(measurePathLayer)
    }
    
    func drawStrokeValuePath() {
        
        let radius = self.frame.width / 4
        let startAngle = minAngle
        let endAngle = maxAngle
        let strokeValuePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        
       /* strokeValuePathLayer.path = strokeValuePath.cgPath
        strokeValuePathLayer.lineWidth = 10.0
        strokeValuePathLayer.strokeColor = UIColor.red.cgColor
        strokeValuePathLayer.fillColor = UIColor.clear.cgColor
        strokeValuePathLayer.borderWidth = 1.0
        strokeValuePathLayer.strokeStart = 0.0
        strokeValuePathLayer.strokeEnd = 0.0
        strokeValuePathLayer.lineCap = kCALineCapRound
        
        self.layer.addSublayer(strokeValuePathLayer)*/
        
        let gradient = CAGradientLayer()
        gradient.frame =  self.bounds
        gradient.colors = [UIColor.yellow.cgColor, UIColor.red.cgColor]
        gradient.locations = [0.0, 0.8]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        strokeValuePathLayer = CAShapeLayer()
        strokeValuePathLayer.frame = bounds
        strokeValuePathLayer.lineWidth = 10.0
        strokeValuePathLayer.path = strokeValuePath.cgPath
        strokeValuePathLayer.strokeColor = UIColor.black.cgColor
        strokeValuePathLayer.fillColor = UIColor.clear.cgColor
        strokeValuePathLayer.strokeStart = 0.0
        strokeValuePathLayer.strokeEnd = 0.0
        strokeValuePathLayer.lineCap = kCALineCapRound
        gradient.mask =  strokeValuePathLayer
        
        self.layer.addSublayer(gradient)
        
    }
    
    func addValueLabel() {
        
        label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width / 5, height: self.frame.width / 5)
        label.center = self.center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Helvetica", size: 17.0)
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.text = "0"
        self.addSubview(label)
    }

    func strokePath(strokeEnd: CGFloat) {
    
        strokeValuePathLayer.strokeEnd = strokeEnd
        
        currentStroke = strokeEnd
        
        if strokeEnd > 1.0 { currentStroke = 1.0}
        if strokeEnd < 0.0 { currentStroke = 0.0}
        
        if currentStroke < 1.0 || currentStroke > 0.0 {

            knobLayer.setValue(currentStroke * CGFloat(π), forKeyPath: "transform.rotation.z")
            label.text = "\(Int(currentStroke * maxValue))"
           // self.delegate?.updateKnobValue(value: Int(currentStroke * maxValue))
            // knobLayer.transform = CATransform3DRotate(knobLayer.transform, (maxAngle * CGFloat(π) / 180.0) * currentStroke / 2.15, 0.0, 0.0, 1.0);
        }
    }
}
