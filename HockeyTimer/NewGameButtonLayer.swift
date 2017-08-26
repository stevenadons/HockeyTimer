//
//  NewGameButtonLayer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 15/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class NewGameButtonLayer: CALayer {
    
    
    // MARK: - Properties
    
    var circles: CAShapeLayer!
    var arrow1: CAShapeLayer!
    var arrow2: CAShapeLayer!
    
    
    // MARK: - Initializers
    
    override init() {
        
        super.init()
        backgroundColor = COLOR.White.cgColor
        
        circles = createShape(path: createPath())
        addSublayer(circles)
        arrow1 = createShape(path: createArrow1())
        arrow1.fillColor = COLOR.Theme.lighter(by: 30).cgColor
        addSublayer(arrow1)
        arrow2 = createShape(path: createArrow2())
        arrow2.fillColor = COLOR.Theme.lighter(by: 30).cgColor
        addSublayer(arrow2)
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
        circles.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        circles.bounds = bounds
        arrow1.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        arrow1.bounds = bounds
        arrow2.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        arrow2.bounds = bounds
    }
    
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createShape(path: UIBezierPath) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 1.5
        shape.strokeColor = COLOR.Theme.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 13, y: 22))
        path.addArc(withCenter: CGPoint(x: 22, y: 22), radius: 9, startAngle: .pi, endAngle: .pi * 3 / 2 + .pi/6, clockwise: true)
        path.move(to: CGPoint(x: 31, y: 22))
        path.addArc(withCenter: CGPoint(x: 22, y: 22), radius: 9, startAngle: 0, endAngle: .pi * 1 / 2 + .pi/6, clockwise: true)
        return path
    }
    
    private func createArrow1() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 9, y: 22))
        path.addLine(to: CGPoint(x: 17, y: 22))
        path.addLine(to: CGPoint(x: 13, y: 27))
        path.close()
        return path
    }

    private func createArrow2() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 27, y: 22))
        path.addLine(to: CGPoint(x: 35, y: 22))
        path.addLine(to: CGPoint(x: 31, y: 17))
        path.close()
        return path
    }
}
