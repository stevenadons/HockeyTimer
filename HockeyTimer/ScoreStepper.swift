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
        
        windUp()
    }
    
    private func windUp() {
        
        scorelabel.alpha = 0.0
        transform = CGAffineTransform(scaleX: 0.01, y: 1)
        alpha = 0.0
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        guard bounds.width * bounds.height != 0 else { return }
        
        let horizontalOffset: CGFloat = 12.0 // 24
        let shapeWidth = bounds.width - (2 * horizontalOffset)
        let shapeHeight = shapeWidth / 3
        let verticalOffset = (bounds.height - shapeHeight) / 2
        shape.frame = bounds.insetBy(dx: horizontalOffset, dy: verticalOffset)
        shape.setNeedsLayout()
        
        NSLayoutConstraint.activate([
            
            scorelabel.heightAnchor.constraint(equalToConstant: shapeHeight),
            scorelabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            scorelabel.widthAnchor.constraint(equalTo: scorelabel.heightAnchor),
            scorelabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            minusButton.heightAnchor.constraint(equalTo: scorelabel.heightAnchor, constant: -(shape.lineWidth + inset) * 2),
            minusButton.centerYAnchor.constraint(equalTo: scorelabel.centerYAnchor, constant: 2),
            minusButton.widthAnchor.constraint(equalTo: minusButton.heightAnchor),
            minusButton.trailingAnchor.constraint(equalTo: scorelabel.leadingAnchor, constant: -shape.lineWidth - inset),
            
            plusButton.heightAnchor.constraint(equalTo: minusButton.heightAnchor),
            plusButton.centerYAnchor.constraint(equalTo: scorelabel.centerYAnchor, constant: 2),
            plusButton.leadingAnchor.constraint(equalTo: scorelabel.trailingAnchor, constant: inset + shape.lineWidth),
            plusButton.widthAnchor.constraint(equalTo: minusButton.heightAnchor),
            
            ])
    }
    
    
    // MARK: - Private Methods
    
    @objc func minusButtonTapped(sender: ScoreStepperButton) {
        
        delegate?.minusButtonTapped(stepper: self)
        guard let score = Int(scorelabel.text!), score >= 1 else { return }
        setScore(value: score - 1)
    }
    
    @objc func plusButtonTapped(sender: ScoreStepperButton) {
        
        delegate?.plusButtonTapped(stepper: self)
        guard let score = Int(scorelabel.text!) else { return }
        setScore(value: score + 1)
    }

    
    // MARK: - User Methods
    
    func setScore(value: Int) {
        
        scorelabel.text = "\(value)"
        scorelabel.setNeedsDisplay()
    }
    
    func appear(show: Bool = true, delay: Double, value: Int = 0, completion: (() -> Void)? = nil) {
        
        setScore(value: value)
        if show {
            UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.allowUserInteraction], animations: {
                self.alpha = 1.0
                self.transform = .identity
                self.scorelabel.alpha = 1.0
            }, completion: { (finished) in
                completion?()
            })
        } else {
            UIView.animate(withDuration: 0.15, delay: delay, options: [.curveEaseIn], animations: {
                self.windUp()
            }, completion: { (finished) in
                completion?()
            })
        }
    }
 



}
