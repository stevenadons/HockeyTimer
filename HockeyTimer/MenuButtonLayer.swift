//
//  MenuButtonLayer.swift
//  DotMenu
//
//  Created by Steven Adons on 14/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class MenuButtonLayer: CALayer {
    
    
    // MARK: - Properties
    
    var shapeColor: UIColor = UIColor.black {
        didSet {
            shape.strokeColor = shapeColor.cgColor
            shape.setNeedsDisplay()
        }
    }
    var bgColor: UIColor = UIColor.cyan {
        didSet {
            backgroundColor = bgColor.cgColor
            setNeedsDisplay()
        }
    }
    
    private var shape: CAShapeLayer!
    private let designWidth: CGFloat = 44
    private let designHeight: CGFloat = 44
    
    
    
    // MARK: - Initializing
    
    override init() {
        
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        setup()
    }
    
    override init(layer: Any) {
        
        super.init()
        setup()
    }
    
    private func setup() {
        
        backgroundColor = bgColor.cgColor
        shape = createShape()
        addSublayer(shape)
        bounds = CGRect(x: 0, y: 0, width: designWidth, height: designHeight)
    }
    
    
    
    // MARK: - Draw and Layout Methods
    
    override func layoutSublayers() {
        
        super.layoutSublayers()
        cornerRadius = min(bounds.width, bounds.height) / 2
        shape.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        shape.bounds = bounds
        shape.path = createPath().cgPath
    }
    
    
    
    // MARK: - Methods to create shapes
    
    private func createShape() -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        
        shape.path = createPath().cgPath
        shape.lineWidth = 3
        shape.strokeColor = shapeColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineCap = .round
        shape.allowsEdgeAntialiasing = true
        
        return shape
    }
    
    private func createPath() -> UIBezierPath {
        
        let widthScale = bounds.width / designWidth
        let heightScale = bounds.height / designHeight
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 11 * widthScale, y: 15 * heightScale))
        path.addLine(to: CGPoint(x: 33 * widthScale, y: 15 * heightScale))
        path.move(to: CGPoint(x: 11 * widthScale, y: 22 * heightScale))
        path.addLine(to: CGPoint(x: 33 * widthScale, y: 22 * heightScale))
        path.move(to: CGPoint(x: 11 * widthScale, y: 29 * heightScale))
        path.addLine(to: CGPoint(x: 33 * widthScale, y: 29 * heightScale))
        
        return path
    }

}
