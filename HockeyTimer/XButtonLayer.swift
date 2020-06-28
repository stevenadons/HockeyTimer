//
//  XButtonLayer.swift
//  CryptoWatchdog
//
//  Created by Steven Adons on 07/01/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class XButtonLayer: CALayer {
    
    
    // MARK: - Properties
    
    private var cross1: CAShapeLayer!
    private var cross2: CAShapeLayer!
    
    private var lineColor: UIColor!
    private var lineWidth: CGFloat!
    
    private let shapeDesignHeight: CGFloat = 67
    private let shapeDesignWidth: CGFloat = 67
    
    private var scaleFactor: CGFloat {
        return min(bounds.width / shapeDesignWidth, bounds.height / shapeDesignHeight) * 0.65
    }
    
    
    // MARK: - Initializing
    
    convenience init(lineColor: UIColor, lineWidth: CGFloat) {
        
        self.init()
        
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        
        setup()
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear.cgColor
        allowsEdgeAntialiasing = true
        needsDisplayOnBoundsChange = true
        
        backgroundColor = UIColor.clear.cgColor
        
        cross1 = createShape(path: createCross1())
        addSublayer(cross1)
        
        cross2 = createShape(path: createCross2())
        addSublayer(cross2)
    }
    
    override func layoutSublayers() {
        
        super.layoutSublayers()
        
        cross1.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        cross2.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        cross1.path = createCross1().cgPath
        cross2.path = createCross2().cgPath
    }
    
    
    // MARK: - Public methods
    
    
    
    // MARK: - Animations
    
    
    
    // MARK: - Private methods
    
    private func createShape(path: UIBezierPath) -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        
        shape.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shape.path = path.cgPath
        shape.lineWidth = lineWidth
        shape.strokeColor = lineColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        
        return shape
    }
    
    private func createCross1() -> UIBezierPath {
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: -17, y: -17))
        path.addLine(to: CGPoint(x: 17, y: 17))
        
        path.apply(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        
        return path
    }
    
    private func createCross2() -> UIBezierPath {
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: -17, y: 17))
        path.addLine(to: CGPoint(x: 17, y: -17))
        
        path.apply(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        
        return path
    }
}

