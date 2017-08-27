//
//  PanArrow.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PanArrow: UIView {

    
    // MARK: - Properties
    
    private var shape: PanArrowLayer!
    
    var color: UIColor {
        get {
            return shape.color
        }
        set {
            shape.color = newValue
            shape.setNeedsDisplay()
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
        isUserInteractionEnabled = false
        shape = PanArrowLayer()
        layer.addSublayer(shape)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        shape.frame = bounds
    }

}
