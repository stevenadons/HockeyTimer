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
    
    let outOfScreen: CGFloat = 0
    let edgeWidth: CGFloat = 18
    
    
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
        center = createCenter(path: centerPath(), color: UIColor(named: ColorName.VeryDarkBlue)!)
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
    
    func setColor(_ color: UIColor) {
        
        center.fillColor = color.cgColor
    }
    
    
    // MARK: - Methods to create shapes (Class Methods)
    
    private func createEdge(path: UIBezierPath) -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        
        shape.path = path.cgPath
        shape.strokeColor = UIColor.clear.cgColor
        shape.lineWidth = 6.0
        shape.fillColor = UIColor(named: ColorName.DarkBlue)!.cgColor
        shape.allowsEdgeAntialiasing = true
        
        return shape
    }
    
    private func edgePath() -> UIBezierPath {
        
        let rect = CGRect(x: -outOfScreen, y: 0, width: bounds.width + 2 * outOfScreen, height: bounds.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 18) // 36
        
        return path
    }
    
    private func createCenter(path: UIBezierPath, color: UIColor) -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        
        shape.path = path.cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 2
        shape.fillColor = color.cgColor
        shape.allowsEdgeAntialiasing = true
        
        return shape
    }
    
    private func centerPath() -> UIBezierPath {
        
        let rect = CGRect(x: -outOfScreen + edgeWidth, y: edgeWidth, width: bounds.width + 2 * outOfScreen - 2 * edgeWidth, height: bounds.height - (edgeWidth * 2))
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 10) // 20
        
        return path
    }
    
    private func createStriping(path: UIBezierPath) -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        
        shape.path = path.cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 2
        shape.allowsEdgeAntialiasing = true
        
        return shape
    }

    private func stripingPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: bounds.width / 2, y: edgeWidth))
        path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height - edgeWidth))
        
        return path
    }
}
