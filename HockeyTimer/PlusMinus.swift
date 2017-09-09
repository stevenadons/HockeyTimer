//
//  PlusMinus.swift
//  HockeyTimer
//
//  Created by Steven Adons on 9/09/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PlusMinus: UIButton {

    
    // MARK: - Properties
    
    private var shape: PlusMinusLayer!
    
    
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
        shape = PlusMinusLayer()
        layer.addSublayer(shape)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        shape.frame = bounds
    }


}
