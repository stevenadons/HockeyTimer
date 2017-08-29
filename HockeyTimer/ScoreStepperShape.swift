//
//  ScoreStepperShape.swift
//  HockeyTimer
//
//  Created by Steven Adons on 29/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class ScoreStepperShape: UIView {
    

    // MARK: - Properties
    
    var container: CALayer!
    var shape: CAShapeLayer!
    var path: UIBezierPath!
    let lineWidth: CGFloat = 2.0
    var color: UIColor = COLOR.LightYellow {
        didSet {
            shape.setNeedsLayout()
        }
    }
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        // Configure self
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        // Add containerView
        container = CALayer()
        container.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(container)
        
        // Add shape
        shape = CAShapeLayer()
        shape.strokeColor = COLOR.White.cgColor
        shape.lineWidth = lineWidth
        shape.fillColor = color.cgColor
        container.addSublayer(shape)
    }

    
    
    // MARK: - Public Methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layoutOrAnimateSublayers()
        
        shape.fillColor = COLOR.LightYellow.cgColor
    }
    
    
    func layoutOrAnimateSublayers() {
        
        CATransaction.begin()
        
        // Check whether animation is going on (bounds.size, bounds.origin or position)
        if let animation = layer.animation(forKey: "bounds.size") {
            // Self is animating
            CATransaction.setAnimationDuration(animation.duration)
            CATransaction.setAnimationTimingFunction(animation.timingFunction)
            
        } else {
            // Self is not animating
            CATransaction.disableActions()
        }
        
        if container.superlayer == layer {
            
            // Properties to change when layout occurs - will animate or not
            container.frame = bounds
            
        }
        
        if shape.superlayer == container {
            
            // Properties to change when layout occurs - will animate or not
            shape.frame = bounds
            
            //  Custom = add animations to include in CATransaction + set animated properties
            let pathAnimation = CABasicAnimation(keyPath: "path")
            shape.add(pathAnimation, forKey: "path")
            shape.path = UIBezierPath(ovalIn: container.bounds).cgPath
            shape.path = UIBezierPath(roundedRect: shape.bounds, cornerRadius: min(bounds.width, bounds.height) / 2).cgPath
        }
        
        CATransaction.commit()
    }
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        shape.setNeedsDisplay()
    }
    
    

  
}
