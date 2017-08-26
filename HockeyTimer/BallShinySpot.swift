//
//  BallShinySpot.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 15/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class BallShinySpot: CALayer {
    
    
    
    // MARK: - Properties
    
    private var shape: CAShapeLayer!
    
    private let designWidth: CGFloat = 40
    private let designHeight: CGFloat = 40
    
    var color: UIColor = COLOR.BallShining {
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
        //        cornerRadius = min(bounds.width, bounds.height) / 2
        shape.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        shape.bounds = bounds
        shape.strokeColor = color.cgColor
        shape.path = createPath().cgPath
    }
    
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createShape() -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = createPath().cgPath
        shape.lineWidth = 1
        shape.strokeColor = UIColor.clear.cgColor
        shape.fillColor = color.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func createPath() -> UIBezierPath {
        let widthScale = bounds.width / designWidth
        let heightScale = bounds.height / designHeight
        let ovalRect = CGRect(x: 9 * widthScale, y: 4 * heightScale, width: 23 * widthScale, height: 13 * heightScale)
        let path = UIBezierPath(ovalIn: ovalRect)
        return path
    }

}
