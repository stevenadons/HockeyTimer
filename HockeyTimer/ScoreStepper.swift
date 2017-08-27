//
//  ScoreStepper.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class ScoreStepper: UIView {

    
    // MARK: - Properties
    
    fileprivate var minusButton: ScoreStepperButton!
    fileprivate var plusButton: ScoreStepperButton!
    fileprivate var scorelabel: UILabel!
    
    private let designHeight: CGFloat = 46

    
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
        
        backgroundColor = COLOR.LightYellow
        layer.borderWidth = 2.0
        layer.borderColor = COLOR.White.cgColor
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        minusButton = ScoreStepperButton(type: .Minus)
        addSubview(minusButton)
        plusButton = ScoreStepperButton(type: .Plus)
        addSubview(plusButton)
        scorelabel = ScoreStepperLabelFactory.standardLabel(text: "5", textColor: COLOR.White, fontStyle: .headline, textAlignment: .center, sizeToFit: false, adjustsFontSizeToFitWidth: true)
        addSubview(scorelabel)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        
        let inset = CGFloat(2.0)
        let multiplier = (designHeight - layer.borderWidth - (inset * 2)) / designHeight
        
        NSLayoutConstraint.activate([
            
            minusButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier),
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            minusButton.widthAnchor.constraint(equalTo: minusButton.heightAnchor),
            minusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: layer.borderWidth + inset),
            
            scorelabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier),
            scorelabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            scorelabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            plusButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor),
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -layer.borderWidth - inset),
            
            ])
    }
    
    // MARK: - User Methods
    
    func setScore(value: Int) {
        
        scorelabel.text = "\(value)"
        scorelabel.setNeedsDisplay()
    }



}
