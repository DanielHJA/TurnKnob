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

class KnobView: UIView, UIGestureRecognizerDelegate {

    var delegate: UpdateValueProtocol?
    
    private var gradientYellowColor: CGColor = UIColor.yellow.cgColor
    private var gradientRedColor: CGColor = UIColor.red.cgColor
    
    private var knobBgColor: CGColor = UIColor.black.cgColor
    private var knobDetailsColor: CGColor = UIColor.white.cgColor
    private var measurePathColor: CGColor = UIColor.black.cgColor
    private var strokeValueColor: CGColor = UIColor.red.cgColor
    private var clearColor: CGColor = UIColor.clear.cgColor
    
    private var knobLayer: CAShapeLayer!
    private var measurePathLayer: CAShapeLayer!
    private var strokeValuePathLayer: CAShapeLayer!
    private var gradient: CAGradientLayer!
    
    private var π = Double.pi
    private var currentStroke: CGFloat = 0.0
    private var minAngle: CGFloat = CGFloat(Double.pi)
    private var maxAngle: CGFloat = CGFloat(2 * Double.pi)
    private var maxValue: CGFloat = 0.0
    private var rotationReducerValue: CGFloat = 1.9

    private var label: UILabel!

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
        
        self.isMultipleTouchEnabled = true
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(sender:)))
        rotationGesture.delegate = self
        self.addGestureRecognizer(rotationGesture)

        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didPress(sender:)))
        pressGesture.minimumPressDuration = 0.05
        pressGesture.numberOfTouchesRequired = 2
        pressGesture.delegate = self
        
        self.addGestureRecognizer(pressGesture)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer is UIRotationGestureRecognizer || gestureRecognizer is UILongPressGestureRecognizer {
            return true
        } else {
            return false
        }
    }
    
    func didPress(sender: UILongPressGestureRecognizer) {
    
        if sender.state == .began {
        
            knobLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            knobLayer.setValue(0.95, forKeyPath: "transform.scale.x")
            knobLayer.setValue(0.95, forKeyPath: "transform.scale.y")
            
        }
        
        if sender.state == .ended {
        
            knobLayer.shadowOffset = CGSize(width: 5.0, height: 5.0)
            knobLayer.setValue(1.0, forKeyPath: "transform.scale.x")
            knobLayer.setValue(1.0, forKeyPath: "transform.scale.y")
            
        }
    }
    
    func didRotate(sender: UIRotationGestureRecognizer) {
       
        let strokeEnd = sender.rotation / maxValue * rotationReducerValue + currentStroke
        
        strokeValuePathLayer.strokeEnd = strokeEnd
        currentStroke = strokeEnd
        
        if strokeEnd > 1.0 { currentStroke = 1.0}
        if strokeEnd < 0.0 { currentStroke = 0.0}
        
        if currentStroke < 1.0 || currentStroke > 0.0 {
            
            knobLayer.setValue(currentStroke * CGFloat(π), forKeyPath: "transform.rotation.z")
            label.text = "\(Int(currentStroke * maxValue))"
            
        }
    }
    
    func drawKnobPath() {

        let radius = self.frame.width / 5
        let startAngle: CGFloat = CGFloat(3.0 * π / 2.0)
        let endAngle: CGFloat = CGFloat(startAngle + CGFloat(4.0 * π / 2.0))
        
        let knobPath = UIBezierPath(arcCenter: self.center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
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
        let innerCirclePath = UIBezierPath(arcCenter: self.center, radius: radius - 5, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
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
        let startAngle: CGFloat = minAngle
        let endAngle: CGFloat = maxAngle
        let circlePath = UIBezierPath(arcCenter: self.center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

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
        let startAngle: CGFloat = minAngle
        let endAngle: CGFloat = maxAngle
        let strokeValuePath = UIBezierPath(arcCenter: self.center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let gradient = CAGradientLayer()
        gradient.frame =  self.bounds
        gradient.colors = [gradientYellowColor, gradientRedColor]
        gradient.locations = [0.0, 0.8]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        strokeValuePathLayer = CAShapeLayer()
        strokeValuePathLayer.frame = bounds
        strokeValuePathLayer.lineWidth = self.frame.width / 32
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
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Helvetica", size: 17.0)
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.text = "0"
        self.addSubview(label)
    }
}
