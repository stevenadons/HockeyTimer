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
        
        backgroundColor = COLOR.VeryDarkBlue
        translatesAutoresizingMaskIntoConstraints = false
        
        innerCircle = UIView()
        innerCircle.isUserInteractionEnabled = false
        innerCircle.backgroundColor = COLOR.DarkBlue
        innerCircle.layer.borderWidth = 1.0
        innerCircle.layer.borderColor = UIColor.white.cgColor
        addSubview(innerCircle)
        
        shape = EditScoreButtonLayer()
        innerCircle.layer.addSublayer(shape)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
        
        innerCircle.frame = bounds.insetBy(dx: 2, dy: 2)
        innerCircle.layer.cornerRadius = innerCircle.bounds.width / 2
        
        shape.frame = innerCircle.bounds.inset(by: UIEdgeInsets(top: 7, left: 7, bottom: 9, right: 7))
    }
}
