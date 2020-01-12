//
//  OvalCountryCross.swift
//  HockeyTimer
//
//  Created by Steven Adons on 04/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit


class OvalCountryCross: CALayer {
    
    
    // MARK: - Properties
    
    var shapeColor: UIColor = UIColor(named: ColorName.OliveText)! {
        didSet {
            shape.strokeColor = shapeColor.cgColor
            shape.setNeedsDisplay()
        }
    }
    var bgColor: UIColor = .clear {
        didSet {
            backgroundColor = bgColor.cgColor
            setNeedsDisplay()
        }
    }
    
    private var shape: CAShapeLayer!
    private let designWidth: CGFloat = 44
    private let designHeight: CGFloat = 44
    
    
    // MARK: - Initializing
    
    init(color: UIColor) {
        
        super.init()
        self.shapeColor = color
        setup()
    }
    
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
    
    
    // MARK: - Public Methods

    func setColor(_ color: UIColor) {
        
        self.shapeColor = color
        shape.strokeColor = color.cgColor
    }
    
    
    
    // MARK: - Methods to create shapes
    
    private func createShape() -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        
        shape.path = createPath().cgPath
        shape.lineWidth = 2
        shape.strokeColor = shapeColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        
        return shape
    }
    
    private func createPath() -> UIBezierPath {
        
        let widthScale = bounds.width / designWidth
        let heightScale = bounds.height / designHeight
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 14 * widthScale, y: 14 * heightScale))
        path.addLine(to: CGPoint(x: 30 * widthScale, y: 30 * heightScale))
        path.move(to: CGPoint(x: 30 * widthScale, y: 14 * heightScale))
        path.addLine(to: CGPoint(x: 14 * widthScale, y: 30 * heightScale))
        
        return path
    }
    
}
