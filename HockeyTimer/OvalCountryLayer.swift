//
//  OvalCountryLayer.swift
//  HockeyTimer
//
//  Created by Steven Adons on 04/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class OvalCountryLayer: CALayer {
    
    
    // MARK: - Properties
    
    private var shape: CAShapeLayer!
    private let designWidth: CGFloat = 44
    private let designHeight: CGFloat = 44
    private var color: UIColor = .white
    
    
    // MARK: - Initializing
    
    init(color: UIColor) {
        
        super.init()
        self.color = color
        setup()
    }
    
    override init(layer: Any) {
        
        super.init(layer: layer)
        setup()
    }
    
    override init() {
        
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear.cgColor
        shape = createShape()
        addSublayer(shape)
        bounds = CGRect(x: 0, y: 0, width: designWidth, height: designHeight)
    }
    
    
    
    // MARK: - Draw and Layout Methods
    
    override func layoutSublayers() {
        
        super.layoutSublayers()
        
        shape.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        shape.bounds = bounds
        shape.path = createPath().cgPath
    }
    
    
    // MARK: - Public Methods
    
    func setColor(_ color: UIColor) {
        
        self.color = color
        shape.strokeColor = color.cgColor
    }
        
    
    // MARK: - Methods to create shapes
    
    private func createShape() -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        
        shape.path = createPath().cgPath
        shape.lineWidth = 1
        shape.strokeColor = color.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.allowsEdgeAntialiasing = true
        
        return shape
    }
    
    private func createPath() -> UIBezierPath {
        
        let widthScale = bounds.width / designWidth
        let heightScale = bounds.height / designHeight
        
        let ovalRect = CGRect(x: 2 * widthScale,
                              y: 9 * heightScale,
                              width: 40 * widthScale,
                              height: 26 * heightScale)
        
        return UIBezierPath(ovalIn: ovalRect)
    }

}
