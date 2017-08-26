//
//  DismissButton.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 14/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DismissButton: UIButton {
    
    
    // MARK: - Properties
    
    private var shapeLayer: DismissButtonLayer!
    
    var color: UIColor {
        get {
            return shapeLayer.color
        }
        set {
            shapeLayer.color = newValue
            setNeedsDisplay()
        }
    }
    
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
        translatesAutoresizingMaskIntoConstraints = false
        
        shapeLayer = DismissButtonLayer()
        layer.addSublayer(shapeLayer)
        
        color = COLOR.Negation
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.borderColor = color.cgColor
        layer.borderWidth = 2
        shapeLayer.frame = bounds
    }
    
    
    // MARK: - User Methods
    
    func show() {
        
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        }
    }
    
    func hide() {
        
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.0
        }
    }

    
   
    
    
}
