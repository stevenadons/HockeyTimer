//
//  ScoreStepperButtonLayer.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit



class ScoreStepperButtonLayer: CALayer {
    
    
    // MARK: - Properties
    
    private var shape: CAShapeLayer!
    private let designWidth: CGFloat = 38
    private let designHeight: CGFloat = 38
    private var type: ScoreStepperButtonType = .Minus
    
    
    // MARK: - Initializers
    
    override init() {
        
        super.init()
        backgroundColor = UIColor.clear.cgColor
        shape = createShape()
        addSublayer(shape)
        bounds = CGRect(x: 0, y: 0, width: designWidth, height: designHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init(layer: Any) {
        super.init()
    }
    
    convenience init(type: ScoreStepperButtonType) {
        
        self.init()
        self.type = type
    }
    
    override func layoutSublayers() {
        
        super.layoutSublayers()
        shape.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        shape.bounds = bounds
        shape.path = createPath().cgPath
    }
    
    
    
    // MARK: - Methods to create shapes
    
    private func createShape() -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        shape.path = createPath().cgPath
        shape.lineWidth = 2
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func createPath() -> UIBezierPath {
        
        let widthScale = bounds.width / designWidth
        let heightScale = bounds.height / designHeight
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 12 * widthScale, y: 19 * heightScale))
        path.addLine(to: CGPoint(x: 26 * widthScale, y: 19 * heightScale))
        if type == .Plus {
            path.move(to: CGPoint(x: 19 * widthScale, y: 12 * heightScale))
            path.addLine(to: CGPoint(x: 19 * widthScale, y: 26 * heightScale))
        }
        return path
    }

}
