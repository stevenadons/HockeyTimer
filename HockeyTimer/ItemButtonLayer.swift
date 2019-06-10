//
//  ItemButtonLayer.swift
//  DotMenu
//
//  Created by Steven Adons on 14/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class ItemButtonLayer: CALayer {
    
    
    // MARK: - Properties
    
    var shapeColor: UIColor = UIColor.white {
        didSet {
            shape.strokeColor = shapeColor.cgColor
            shape.setNeedsDisplay()
        }
    }
    var bgColor: UIColor = UIColor.black {
        didSet {
            backgroundColor = bgColor.cgColor
            setNeedsDisplay()
        }
    }
    var path: UIBezierPath = UIBezierPath() {
        didSet {
            shape.path = path.cgPath
            shape.setNeedsDisplay()
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
    
    convenience init(path: UIBezierPath) {
        
        self.init()
        convenienceSet(path: path)
    }
    
    private func convenienceSet(path: UIBezierPath) {
        
        self.path = path
    }
    
    private func setup() {
        
        backgroundColor = bgColor.cgColor
        shape = createShape()
        addSublayer(shape)
    }
        
    
    
    // MARK: - Draw and Layout Methods
    
    override func layoutSublayers() {
        
        super.layoutSublayers()
        cornerRadius = min(bounds.width, bounds.height) / 2
        shape.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        shape.bounds = bounds
        shape.path = path.cgPath
    }
    
    
    
    // MARK: - Methods to create shapes
    
    private func createShape() -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        
        shape.path = path.cgPath
        shape.lineWidth = 2
        shape.lineJoin = CAShapeLayerLineJoin.bevel
        shape.strokeColor = shapeColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        
        return shape
    }
   
}
