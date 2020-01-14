//
//  MainMenuButton.swift
//  HockeyTimer
//
//  Created by Steven Adons on 14/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class MainMenuButton: UIButton {

    
    // MARK: - Properties
    
    var shapeColor: UIColor = .black {
        didSet {
            hamburger.shapeColor = shapeColor
            hamburger.setNeedsDisplay()
        }
    }
    var bgColor: UIColor = .clear {
        didSet {
            hamburger.bgColor = bgColor
            hamburger.setNeedsDisplay()
        }
    }
    private var crossColor: UIColor = .white
    
    private var hamburger: MainMenuButtonHamburgerLayer!
    private var cross: MainMenuButtonCrossLayer!
    
    
    
    // MARK: - Initializing
    
    init(color: UIColor, crossColor: UIColor) {
        
        self.init()
        setColor(color, crossColor: crossColor)
    }
    
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
        
        hamburger = MainMenuButtonHamburgerLayer()
        layer.addSublayer(hamburger)
        
        cross = MainMenuButtonCrossLayer()
        cross.opacity = 0.0
        layer.addSublayer(cross)
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
        hamburger.frame = bounds
        cross.frame = bounds
    }
    
    
    // MARK: - User Methods
    
    func invert() {
        
        CATransaction.setDisableActions(true)
        hamburger.opacity = 0.0
        CATransaction.setDisableActions(false)
        
        let deadline = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            let animationOpacity = CABasicAnimation(keyPath: "opacity")
            animationOpacity.duration = 0.2
            animationOpacity.fromValue = 0.0
            animationOpacity.toValue = 1.0
            self.cross.add(animationOpacity, forKey: "opacity")
            self.cross.opacity = 1.0
        }
    }
    
    func reset() {
        
        CATransaction.setDisableActions(true)
        cross.opacity = 0.0
        CATransaction.setDisableActions(false)
        
        let deadline = DispatchTime.now() + 0.05
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            let animationOpacity = CABasicAnimation(keyPath: "opacity")
            animationOpacity.duration = 0.2
            animationOpacity.fromValue = 0.0
            animationOpacity.toValue = 1.0
            self.hamburger.add(animationOpacity, forKey: "opacity")
            self.hamburger.opacity = 1.0
        }
    }
    
    func setColor(_ color: UIColor, crossColor: UIColor) {
        
        self.shapeColor = color
        self.crossColor = crossColor
        hamburger.setColor(color)
        cross.setColor(crossColor)
    }

}
