//
//  MenuButton.swift
//  DotMenu
//
//  Created by Steven Adons on 14/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class MenuButton: UIButton {

    
    // MARK: - Properties
    
    var shapeColor: UIColor = UIColor.black {
        didSet {
            buttonLayer.shapeColor = shapeColor
            buttonLayer.setNeedsDisplay()
        }
    }
    var bgColor: UIColor = UIColor.cyan {
        didSet {
            buttonLayer.bgColor = bgColor
            buttonLayer.setNeedsDisplay()
        }
    }
    
    private var buttonLayer: MenuButtonLayer!
    private var buttonLayerCross: MenuButtonLayerCross!
    
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = true
        
        buttonLayer = MenuButtonLayer()
        layer.addSublayer(buttonLayer)
        
        buttonLayerCross = MenuButtonLayerCross()
        buttonLayerCross.opacity = 0.0
        layer.addSublayer(buttonLayerCross)
    }
    
    convenience init(shapeColor: UIColor, bgColor: UIColor) {
        
        self.init()
        convenienceSet(shapeColor: shapeColor, bgColor: bgColor)
    }
    
    private func convenienceSet(shapeColor: UIColor, bgColor: UIColor) {
        
        self.shapeColor = shapeColor
        self.bgColor = bgColor
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        buttonLayer.frame = bounds
        buttonLayerCross.frame = bounds
    }
    
    
    // MARK: - User Methods
    
    func invert() {
        
        CATransaction.setDisableActions(true)
        buttonLayer.opacity = 0.0
        CATransaction.setDisableActions(false)
        
        let deadline = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            let animationOpacity = CABasicAnimation(keyPath: "opacity")
            animationOpacity.duration = 0.2
            animationOpacity.fromValue = 0.0
            animationOpacity.toValue = 1.0
            self.buttonLayerCross.add(animationOpacity, forKey: "opacity")
            self.buttonLayerCross.opacity = 1.0
        }
    }
    
    func reset() {
        
        CATransaction.setDisableActions(true)
        buttonLayerCross.opacity = 0.0
        CATransaction.setDisableActions(false)
        
        let deadline = DispatchTime.now() + 0.05
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            let animationOpacity = CABasicAnimation(keyPath: "opacity")
            animationOpacity.duration = 0.2
            animationOpacity.fromValue = 0.0
            animationOpacity.toValue = 1.0
            self.buttonLayer.add(animationOpacity, forKey: "opacity")
            self.buttonLayer.opacity = 1.0
        }
    }

}
