//
//  ScoreStepper.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


enum ScoreStepperType {
    
    case Home
    case Away
}


class ScoreStepper: UIView {

    // MARK: - Properties
    
    fileprivate var shape: ScoreStepperShape!
    fileprivate var minusButton: ScoreStepperButton!
    fileprivate var plusButton: ScoreStepperButton!
    fileprivate var scorelabel: UILabel!
    fileprivate var delegate: ScoreStepperDelegate?
    fileprivate(set) var type: ScoreStepperType = .Home
    
    private let designHeight: CGFloat = 46
    private let inset: CGFloat = 1.0

    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(delegate: ScoreStepperDelegate, type: ScoreStepperType) {
        
        self.init()
        self.delegate = delegate
        self.type = type
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        shape = ScoreStepperShape()
        addSubview(shape)
        
        minusButton = ScoreStepperButton(type: .Minus)
        minusButton.addTarget(self, action: #selector(minusButtonTapped(sender:)), for: [.touchUpInside])
        addSubview(minusButton)
        plusButton = ScoreStepperButton(type: .Plus)
        plusButton.addTarget(self, action: #selector(plusButtonTapped(sender:)), for: [.touchUpInside])
        addSubview(plusButton)
        scorelabel = ScoreStepperLabelFactory.standardLabel(text: "5", textColor: COLOR.White, fontStyle: .headline, textAlignment: .center, sizeToFit: false, adjustsFontSizeToFitWidth: true)
        addSubview(scorelabel)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let horizontalOffset: CGFloat = 24.0
        let shapeWidth = bounds.width - (2 * horizontalOffset)
        let shapeHeight = shapeWidth / 3
        let verticalOffset = (bounds.height - shapeHeight) / 2
        shape.frame = bounds.insetBy(dx: horizontalOffset, dy: verticalOffset)
        shape.setNeedsLayout()
        
        NSLayoutConstraint.activate([
            
            scorelabel.heightAnchor.constraint(equalToConstant: shapeHeight),
            scorelabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            scorelabel.widthAnchor.constraint(equalTo: scorelabel.heightAnchor),
            scorelabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            minusButton.heightAnchor.constraint(equalTo: scorelabel.heightAnchor, constant: -(shape.lineWidth + inset) * 2),
            minusButton.centerYAnchor.constraint(equalTo: scorelabel.centerYAnchor),
            minusButton.widthAnchor.constraint(equalTo: minusButton.heightAnchor),
            minusButton.trailingAnchor.constraint(equalTo: scorelabel.leadingAnchor, constant: -shape.lineWidth - inset),
            
            plusButton.heightAnchor.constraint(equalTo: minusButton.heightAnchor),
            plusButton.centerYAnchor.constraint(equalTo: scorelabel.centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: scorelabel.trailingAnchor, constant: inset + shape.lineWidth),
            plusButton.widthAnchor.constraint(equalTo: minusButton.heightAnchor),
            
            ])
    }
    
    
    
    
    // MARK: - Private Methods
    
    func minusButtonTapped(sender: ScoreStepperButton) {
        
        delegate?.minusButtonTapped(stepper: self)
    }
    
    func plusButtonTapped(sender: ScoreStepperButton) {
        
        delegate?.plusButtonTapped(stepper: self)
    }

    
    // MARK: - User Methods
    
    func setScore(value: Int) {
        
        scorelabel.text = "\(value)"
        scorelabel.setNeedsDisplay()
    }
    
    func toggleButtons(hide: Bool) {
        
        shape.alpha = hide ? 0.0 : 1.0
        minusButton.alpha = hide ? 0.0 : 1.0
        plusButton.alpha = hide ? 0.0 : 1.0
    }
 



}
