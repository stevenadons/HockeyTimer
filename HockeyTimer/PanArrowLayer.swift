//
//  PanArrowLayer.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PanArrowLayer: CALayer {
    
    
    // MARK: - Properties
    
    private var shape: CAShapeLayer!
    private let designWidth: CGFloat = 44
    private let designHeight: CGFloat = 22
    
    var color: UIColor = COLOR.DarkBlue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
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
    
    override func layoutSublayers() {
        
        super.layoutSublayers()
        cornerRadius = min(bounds.width, bounds.height) / 2
        shape.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        shape.bounds = bounds
        shape.strokeColor = color.cgColor
        shape.path = createPath().cgPath
    }
    
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createShape() -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        shape.path = createPath().cgPath
        shape.lineWidth = 4
        shape.strokeColor = color.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func createPath() -> UIBezierPath {
        
        let widthScale = bounds.width / designWidth
        let heightScale = bounds.height / designHeight
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 5 * widthScale, y: 16 * heightScale))
        path.addLine(to: CGPoint(x: 22 * widthScale, y: 6 * heightScale))
        path.addLine(to: CGPoint(x: 39 * widthScale, y: 16 * heightScale))
        return path
    }

}
