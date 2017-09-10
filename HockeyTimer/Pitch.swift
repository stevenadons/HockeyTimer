//
//  Pitch.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 30/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

let distanceMoveUp: CGFloat = 110

protocol BallDelegate: class {
    
    func homeScored()
    func awayScored()
}

protocol ScoreStepperDelegate {
    
    func minusButtonTapped(stepper: ScoreStepper)
    func plusButtonTapped(stepper: ScoreStepper)
}


class Pitch: UIView {

    
    // MARK: - Properties
    
    private var background: PitchBackgroundLayer!
    private var ball: Ball!
    fileprivate var homeScoreLabel: UILabel!
    fileprivate var awayScoreLabel: UILabel!
    
    fileprivate var homeScoreStepper: ScoreStepper!
    fileprivate var awayScoreStepper: ScoreStepper!

    fileprivate var delegate: PitchDelegate?
    fileprivate var homeScore: Int = 0
    fileprivate var awayScore: Int = 0
    
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(delegate: PitchDelegate) {
        
        self.init()
        self.delegate = delegate
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        background = PitchBackgroundLayer()
        background.frame = bounds
        layer.addSublayer(background)
        
        homeScoreLabel = scoreLabel()
        addSubview(homeScoreLabel)
        awayScoreLabel = scoreLabel()
        addSubview(awayScoreLabel)
        
        homeScoreStepper = ScoreStepper(delegate: self, type: .Home)
        addSubview(homeScoreStepper)
        awayScoreStepper = ScoreStepper(delegate: self, type: .Away)
        addSubview(awayScoreStepper)
        
        ball = Ball(delegate: self)
        addSubview(ball)
    }
    
    private func scoreLabel() -> UILabel {
        
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 64)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = COLOR.White
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        background.frame = bounds
        background.layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            
            homeScoreLabel.heightAnchor.constraint(equalToConstant: 75),
            homeScoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            homeScoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 47 * bounds.width / 375),
            homeScoreLabel.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 133 * bounds.width / 375),

            awayScoreLabel.heightAnchor.constraint(equalTo: homeScoreLabel.heightAnchor),
            awayScoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            awayScoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width - 133 * bounds.width / 375),
            awayScoreLabel.trailingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width - 47 * bounds.width / 375),
            
            homeScoreStepper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            homeScoreStepper.trailingAnchor.constraint(equalTo: centerXAnchor),
            homeScoreStepper.topAnchor.constraint(equalTo: topAnchor, constant: background.edgeWidth),
            homeScoreStepper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -background.edgeWidth),
            
            awayScoreStepper.leadingAnchor.constraint(equalTo: centerXAnchor),
            awayScoreStepper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            awayScoreStepper.topAnchor.constraint(equalTo: topAnchor, constant: background.edgeWidth),
            awayScoreStepper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -background.edgeWidth),
            
            ball.centerXAnchor.constraint(equalTo: centerXAnchor),
            ball.centerYAnchor.constraint(equalTo: centerYAnchor),
            ball.heightAnchor.constraint(equalToConstant: 40),
            ball.widthAnchor.constraint(equalToConstant: 40),
            
            ])
        
        homeScoreStepper.setNeedsLayout()
        awayScoreStepper.setNeedsLayout()
    }
    
    
    // MARK: - User methods

    func resetScores() {
        
        homeScore = 0
        homeScoreLabel.text = "\(homeScore)"
        awayScore = 0
        awayScoreLabel.text = "\(awayScore)"
    }
    
    func homeMinusOne() {
        
        homeScoreLabel.layer.removeAllAnimations()
        homeScore -= 1
        homeScoreLabel.text = "\(homeScore)"
        delegate?.scoreHomeMinusOne()
    }
    
    func awayMinusOne() {
        
        awayScoreLabel.layer.removeAllAnimations()
        awayScore -= 1
        awayScoreLabel.text = "\(awayScore)"
        delegate?.scoreAwayMinusOne()
    }
    
    func toggleEditMode(on: Bool) {
        
        if on {
            hideBall()
            homeScoreLabel.alpha = 0.0
            awayScoreLabel.alpha = 0.0
            homeScoreStepper.appear(show: true, delay: 0.0, value: homeScore, completion: nil)
            awayScoreStepper.appear(show: true, delay: 0.0, value: awayScore, completion: nil)
        } else {
            homeScoreStepper.appear(show: false, delay: 0.0, completion: {
                self.homeScoreLabel.alpha = 1.0
            })
            awayScoreStepper.appear(show: false, delay: 0.0, completion: {
                self.awayScoreLabel.alpha = 1.0
                self.showBall()
            })
        }
    }
    
    func simplifyForOnboarding() {
        
        isUserInteractionEnabled = false
        background.hideEdge()
        homeScoreLabel.text = "2"
        awayScoreLabel.text = "1"
    }
    
    func animateScoreOnboarding(completion: (() -> Void)?) {
        
        guard homeScoreLabel.text == "2" else { return }
        ball.moveBallOnboarding(completion: {
            self.update(label: self.homeScoreLabel, withText: "3")
            completion?()
        })
    }
        
    
    // MARK: - Private Methods
    
    fileprivate func showBall() {
        
        ball.isUserInteractionEnabled = true
        if ball.alpha < 1 {
            UIView.animate(withDuration: 0.2) {
                self.ball.alpha = 1
            }
        }
    }
    
    fileprivate func hideBall() {
        
        ball.isUserInteractionEnabled = false
        if ball.alpha > 0 {
            UIView.animate(withDuration: 0.2) {
                self.ball.alpha = 0
            }
        }
    }
    
    fileprivate func updateScore(for game: HockeyGame) {
        
        if homeScoreLabel.text != "\(game.homeScore)" {
            update(label: homeScoreLabel, withText: "\(game.homeScore)")
        } else if awayScoreLabel.text != "\(game.awayScore)" {
            update(label: awayScoreLabel, withText: "\(game.awayScore)")
        }
    }
    
    fileprivate func update(label: UILabel, withText text: String) {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
            label.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (finished) in
            label.text = text
            label.transform = CGAffineTransform(scaleX: 3.5, y: 3.5)
            label.textColor = COLOR.LightYellow
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
                label.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                self.delegate?.scoreLabelChanged()
                UIView.transition(with: label, duration: 1, options: .transitionCrossDissolve, animations: {
                    label.textColor = COLOR.White
                }, completion: nil)
            })
        }
    }
}


extension Pitch: BallDelegate {
    
    func homeScored() {
        
        homeScore += 1
        update(label: homeScoreLabel, withText: "\(homeScore)")
        delegate?.scoreHome()
    }
    
    func awayScored() {
        
        awayScore += 1
        update(label: awayScoreLabel, withText: "\(awayScore)")
        delegate?.scoreAway()
    }
}


extension Pitch: ScoreStepperDelegate {
    
    func minusButtonTapped(stepper: ScoreStepper) {
        
        switch stepper.type {
        case .Home:
            guard homeScore > 0 else { return }
            homeMinusOne()
            print("Home: stepper \(stepper.type) tapped minus")
        case .Away:
            guard awayScore > 0 else { return }
            awayMinusOne()
            print("Away: stepper \(stepper.type) tapped minus")
        }
    }
    
    func plusButtonTapped(stepper: ScoreStepper) {
        
        switch stepper.type {
        case .Home:
            homeScore += 1
            homeScoreLabel.text = "\(homeScore)"
            delegate?.scoreHome()
            print("Home: stepper \(stepper.type) tapped plus")
        case .Away:
            awayScore += 1
            awayScoreLabel.text = "\(awayScore)"
            delegate?.scoreAway()
            print("Away: stepper \(stepper.type) tapped plus")
            
        }
    }
}
