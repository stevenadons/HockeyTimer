//
//  DismissButtonLayer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 29/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DismissButtonLayer: CALayer {

    
    // MARK: - Properties
    
    private var shape: CAShapeLayer!
    
    private let designWidth: CGFloat = 44
    private let designHeight: CGFloat = 44
    
    var color: UIColor = COLOR.Negation {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    // MARK: - Initializers
    
    override init() {
        
        super.init()
        backgroundColor = COLOR.White.cgColor
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
        shape.lineWidth = 2
        shape.strokeColor = color.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func createPath() -> UIBezierPath {
        let widthScale = bounds.width / designWidth
        let heightScale = bounds.height / designHeight
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 15 * widthScale, y: 15 * heightScale))
        path.addLine(to: CGPoint(x: 29 * widthScale, y: 29 * heightScale))
        path.move(to: CGPoint(x: 29 * widthScale, y: 15 * heightScale))
        path.addLine(to: CGPoint(x: 15 * widthScale, y: 29 * heightScale))
        return path
    }

}
