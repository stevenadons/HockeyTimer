//
//  PlusMinusLayer.swift
//  HockeyTimer
//
//  Created by Steven Adons on 9/09/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PlusMinusLayer: CALayer {
    
    // MARK: - Properties
    
    var plus: CAShapeLayer!
    var minus: CAShapeLayer!
    
    
    // MARK: - Initializers
    
    override init() {
        
        super.init()
        backgroundColor = UIColor.clear.cgColor
        
        plus = createShape(path: plusPath())
        addSublayer(plus)
        minus = createShape(path: minusPath())
        addSublayer(minus)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init(layer: Any) {
        super.init()
    }
    
    override func layoutSublayers() {
        
        super.layoutSublayers()
        
        plus.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        plus.bounds = bounds
        minus.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        minus.bounds = bounds
    }
    
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createShape(path: UIBezierPath) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 2.5
        shape.strokeColor = COLOR.DarkBlue.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func plusPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 22, y: 6.5))
        path.addLine(to: CGPoint(x: 22, y: 26.5))
        path.move(to: CGPoint(x: 12, y: 16.5))
        path.addLine(to: CGPoint(x: 32, y: 16.5))
        return path
    }
    
    private func minusPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 12, y: 33.5))
        path.addLine(to: CGPoint(x: 32, y: 33.5))
        path.close()
        return path
    }
    
}
