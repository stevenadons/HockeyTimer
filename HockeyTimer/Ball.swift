//
//  Ball.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 1/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class Ball: UIView {
    

    // MARK: - Properties
    
    private var shinySpot: BallShinySpot!
    
    private var pan: UIPanGestureRecognizer!
    private var animator: UIViewPropertyAnimator!
    private var haptic: UIImpactFeedbackGenerator?

    var centerFrame: CGRect!
    private var xOffset: CGFloat!

    fileprivate var delegate: BallDelegate?
    fileprivate var shouldRecordGoal: Bool = true
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(delegate: BallDelegate) {
        
        self.init()
        self.delegate = delegate
        shinySpot = BallShinySpot()
        layer.addSublayer(shinySpot)
    }
    
    private func setup() {
        
        layer.backgroundColor = COLOR.BallBody.cgColor
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(pan:)))
        addGestureRecognizer(pan)
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        centerFrame = CGRect(x: (superview!.bounds.width - bounds.width) / 2, y: (superview!.bounds.height - bounds.height) / 2, width: bounds.width, height: bounds.height)
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.shadowPath = UIBezierPath(ovalIn: bounds).cgPath
        shinySpot.frame = bounds
    }
    
    
    func repositionBall(withDelay delay: Double) {
        
        isUserInteractionEnabled = true
        pan.cancelsTouchesInView = false
        frame = self.centerFrame

        UIView.animate(withDuration: 0.2, delay: delay, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (finished) in
            self.shouldRecordGoal = true
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    
    
    // MARK: - Touch methods
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let distance = sqrt(pow(point.x - bounds.midX, 2) + pow(point.y - bounds.midY, 2))
        if distance <= min(bounds.width, bounds.height) {
            return true
        }
        return false
    }
    
    @objc private func handlePan(pan: UIPanGestureRecognizer) {
        
        let translation = pan.translation(in: superview!)
        
        switch pan.state {
            
        case .began:
            prepareHapticIfNeeded()
            xOffset = (UIScreen.main.bounds.width / 2 + bounds.width / 2) * copysign(1.0, translation.x)
            animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5, animations: {
                self.frame = self.centerFrame.offsetBy(dx: self.xOffset, dy: 0)
            })
            animator.pauseAnimation()
            
        case .changed:
            if copysign(1.0, translation.x) != copysign(1.0, xOffset) {
                xOffset = (UIScreen.main.bounds.width / 2 + bounds.width / 2) * copysign(1.0, translation.x)
                animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5, animations: {
                    self.frame = self.centerFrame.offsetBy(dx: self.xOffset, dy: 0)
                })
                animator.pauseAnimation()
            }
            animator.fractionComplete = translation.x / xOffset
            if animator.fractionComplete > 0.60 || abs(pan.velocity(in: self.superview!).x) > 1000 {
                handleScore(homeSide: (translation.x < 0))
            }
        case .ended:
            guard (animator.fractionComplete > 0.60 || abs(pan.velocity(in: self.superview!).x) > 1000) == false else {
                return
            }
            haptic = nil
            xOffset = 0
            animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5, animations: {
                self.frame = self.centerFrame
            })
            animator.startAnimation()
            
        default:
            print("other pan state")
        }
        
    }
    
    private func handleScore(homeSide: Bool) {
        
        haptic?.impactOccurred()
        haptic = nil
        guard shouldRecordGoal == true else { return }
        shouldRecordGoal = false
        isUserInteractionEnabled = false
        if homeSide {
            delegate?.homeScored()
        } else {
            delegate?.awayScored()
        }
        animator.stopAnimation(true)
        alpha = 0
        repositionBall(withDelay: 1.0)
    }
    
    
    
    // MARK: - Haptic
    
    private func prepareHapticIfNeeded() {
        
        guard #available(iOS 10.0, *) else { return }
        if haptic == nil {
            haptic = UIImpactFeedbackGenerator(style: .heavy)
            haptic!.prepare()
        }
    }

    
}


