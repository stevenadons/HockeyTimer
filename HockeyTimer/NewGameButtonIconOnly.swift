//
//  NewGameButtonIconOnly.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 15/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class NewGameButtonIconOnly: UIButton {

    
    // MARK: - Properties
    
    private var shape: NewGameButtonLayer!
    
    
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
        shape = NewGameButtonLayer()
        layer.addSublayer(shape)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        shape.frame = bounds
    }

}
