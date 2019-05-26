//
//  EditScoreButton.swift
//  HockeyTimer
//
//  Created by Steven Adons on 25/05/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit


class EditScoreButton: UIButton {
    
    
    // MARK: - Properties
    
    private var innerCircle: UIView!
    private var shape: EditScoreButtonLayer!
    
    
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
        
        backgroundColor = COLOR.DarkBlue
        translatesAutoresizingMaskIntoConstraints = false
        
        shape = EditScoreButtonLayer()
        layer.addSublayer(shape)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
        shape.frame = bounds.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 10, right: 9))
    }
}
