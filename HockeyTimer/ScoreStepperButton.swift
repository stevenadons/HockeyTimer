//
//  ScoreStepperButton.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


enum ScoreStepperButtonType {
    
    case Plus
    case Minus
}


class ScoreStepperButton: UIButton {

    
    // MARK: - Properties
    
    private var shape: ScoreStepperButtonLayer!
    private var type: ScoreStepperButtonType = .Minus
    
    var bgColor: UIColor = COLOR.LightRed {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Initializing
    
    required convenience init(type: ScoreStepperButtonType) {
        
        self.init()
        self.type = type
        setup()
    }
    
    private func setup() {
        
        switch type {
        case .Minus:
            bgColor = COLOR.LightRed
        case .Plus:
            bgColor = UIColor(named: "DarkBlue")!
        }
        backgroundColor = bgColor
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        
        shape = ScoreStepperButtonLayer(type: type)
        layer.addSublayer(shape)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        shape.frame = bounds
    }
    
    
    
}
