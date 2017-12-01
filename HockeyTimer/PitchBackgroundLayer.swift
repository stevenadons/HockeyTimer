//
//  PitchBackgroundLayer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 30/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PitchBackgroundLayer: CALayer {
    
    
    // MARK: - Properties
    
    // Shapes (passive or animating)
    private var edge: CAShapeLayer!
    private var center: CAShapeLayer!
    private var striping: CAShapeLayer!
    
    let outOfScreen: CGFloat = 0 // 5
    let edgeWidth: CGFloat = 23
    
    
    // MARK: - Initializers
    
    override init() {
        
        // Super init
        super.init()
        
        // Configure self
        allowsEdgeAntialiasing = true
        needsDisplayOnBoundsChange = true
        masksToBounds = true
        
        // Set up sublayers
        edge = createEdge(path: edgePath())
        center = createCenter(path: centerPath(), color: COLOR.VeryDarkBlue)
        striping = createStriping(path: stripingPath())
        
        // Add sublayers
        addSublayer(edge)
        addSublayer(center)
        addSublayer(striping)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
    }
    
    override init(layer: Any) {
        
        super.init()
    }
    
    // Optional: set shape position relating to embedding view's bounds
    override func layoutSublayers() {
        
        super.layoutSublayers()
        edge.bounds = bounds
        edge.position = position
        edge.path = edgePath().cgPath
        center.bounds = bounds
        center.position = position
        center.path = centerPath().cgPath
        striping.bounds = bounds
        striping.position = position
        striping.path = stripingPath().cgPath
    }
    
    
    // MARK: - Public methods
    
    func hideEdge() {
        
        edge.opacity = 0.0
        edge.setNeedsDisplay()
    }
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createEdge(path: UIBezierPath) -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.clear.cgColor //COLOR.LightYellow.cgColor
        shape.lineWidth = 6.0
        shape.fillColor = COLOR.DarkBlue.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func edgePath() -> UIBezierPath {
        
        let path = UIBezierPath(rect: CGRect(x: -outOfScreen, y: 0, width: bounds.width + 2 * outOfScreen, height: bounds.height))
        return path
    }
    
    private func createCenter(path: UIBezierPath, color: UIColor) -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = COLOR.White.cgColor
        shape.lineWidth = 1.0
        shape.fillColor = color.cgColor
        shape.allowsEdgeAntialiasing = true
        return shape
    }
    
    private func centerPath() -> UIBezierPath {
        
        let path = UIBezierPath(rect: CGRect(x: -outOfScreen + edgeWidth, y: edgeWidth, width: bounds.width + 2 * outOfScreen - 2 * edgeWidth, height: bounds.height - (edgeWidth * 2)))
        return path
    }
    
    private func createStriping(path: UIBezierPath) -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = COLOR.White.cgColor
        shape.lineWidth = 1.0
        shape.allowsEdgeAntialiasing = true
        return shape
    }

    private func stripingPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.width / 2, y: 23))
        path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height - 23))
        return path
    }
}
