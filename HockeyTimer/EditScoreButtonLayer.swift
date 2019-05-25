//
//  EditScoreButtonLayer.swift
//  HockeyTimer
//
//  Created by Steven Adons on 25/05/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit


class EditScoreButtonLayer: CALayer {
    
    
    // MARK: - Properties
    
    private let designWidth: CGFloat = 43
    private let designHeight: CGFloat = 43
    
    private var plus: CAShapeLayer!
    private var minus: CAShapeLayer!
    
    
    // MARK: - Initializers
    
    override init() {
        
        super.init()
        backgroundColor = UIColor.clear.cgColor
        
        plus = createShape(path: plusPath())
        addSublayer(plus)
        
        minus = createShape(path: minusPath())
        addSublayer(minus)
        
        bounds = CGRect(x: 0, y: 0, width: designWidth, height: designHeight)
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
        plus.path = plusPath().cgPath
        
        minus.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        minus.bounds = bounds
        minus.path = minusPath().cgPath
    }
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createShape(path: UIBezierPath) -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        
        shape.path = path.cgPath
        shape.lineWidth = 2.5
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        
        return shape
    }
    
    private func plusPath() -> UIBezierPath {
        
        let widthScale = bounds.width / designWidth
        let heightScale = bounds.height / designHeight
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 22 * widthScale, y: 6.5 * heightScale))
        path.addLine(to: CGPoint(x: 22 * widthScale, y: 26.5 * heightScale))
        path.move(to: CGPoint(x: 12 * widthScale, y: 16.5 * heightScale))
        path.addLine(to: CGPoint(x: 32 * widthScale, y: 16.5 * heightScale))
        
        return path
    }
    
    private func minusPath() -> UIBezierPath {
        
        let widthScale = bounds.width / designWidth
        let heightScale = bounds.height / designHeight
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 12 * widthScale, y: 33.5 * heightScale))
        path.addLine(to: CGPoint(x: 32 * widthScale, y: 33.5 * heightScale))
        path.close()
        
        return path
    }
    
}

