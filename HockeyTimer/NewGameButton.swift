//
//  NewGameButton.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 15/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class NewGameButton: UIButton {

    
    // MARK: - Properties
    
    private var shapeLayer: NewGameButtonLayer!
    
    
    
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
        
        shapeLayer = NewGameButtonLayer()
        layer.addSublayer(shapeLayer)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
        shapeLayer.frame = bounds
        
    }

}
