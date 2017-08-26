//
//  AnimationAnimationController.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 9/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class AnimationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    // MARK: - Properties

    var isPresenting: Bool
    let duration = 0.8
    
    
    
    // MARK: - Initializing
    
    init(isPresenting: Bool) {
        
        self.isPresenting = isPresenting
        super.init()
    }
    
    
    
    // MARK: - User Methods
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresenting {
            animatePresentationTransition(transitionContext: transitionContext)
        } else {
            animateDismissalTransition(transitionContext: transitionContext)
        }
    }
    
    
    // MARK: - Private Methods

    private func animatePresentationTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // Add presentingSnapshot (will move) on top of presentingVC.view
        let presentingVC = transitionContext.viewController(forKey: .from)!
        guard let presentingSnapshot = presentingVC.view.snapshotView(afterScreenUpdates: true) else { return }
        presentingSnapshot.frame = presentingVC.view.frame
        presentingSnapshot.layer.zPosition = UIScreen.main.bounds.width / 2
        transitionContext.containerView.addSubview(presentingSnapshot)
        presentingVC.view.isHidden = true

        // Position toVC (end result)
        let presentedVC = transitionContext.viewController(forKey: .to)!
        presentedVC.view.frame = transitionContext.finalFrame(for: presentedVC)
        transitionContext.containerView.addSubview(presentedVC.view)
        
        // Add presentedSnapshot (will move) on top of presentedVC.view
        guard let presentedSnapshot = presentedVC.view.snapshotView(afterScreenUpdates: true) else { return }
        presentedSnapshot.frame = presentedVC.view.frame
//        presentedSnapshot.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        transitionContext.containerView.addSubview(presentedSnapshot)
        
        // Temporarily hide presentedVC and presentedSnapshot
        presentedVC.view.isHidden = true
        presentedSnapshot.alpha = 0.0

        // Animation
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: .easeInOut)
        animator.addAnimations {
            UIView.animateKeyframes(withDuration: self.duration, delay: 0, options: [.calculationModeCubic], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.00, relativeDuration: 0.45, animations: {
//                    presentingSnapshot.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.10, animations: {
                    presentingSnapshot.alpha = 0.0
                    presentedSnapshot.alpha = 1.0
                })
                UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45, animations: {
//                    presentedSnapshot.transform = .identity
                })
            })
        }
        
        // Remove snapshots at end
        animator.addCompletion { (position) in
            presentedVC.view.isHidden = false
            presentedSnapshot.removeFromSuperview()
            presentingSnapshot.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
        // Perform animation
        animator.startAnimation()
    }
    
    
    func animateDismissalTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // Add presentingSnapshot (will move) on top of presentingVC.view
        let presentingVC = transitionContext.viewController(forKey: .to)!
        presentingVC.view.isHidden = false
        guard let presentingSnapshot = presentingVC.view.snapshotView(afterScreenUpdates: true) else { return }
        presentingSnapshot.frame = presentingVC.view.frame
//        presentingSnapshot.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        transitionContext.containerView.addSubview(presentingSnapshot)
        
        // Temporarily hide presentingVCView and presentingSnapshot
        presentingVC.view.isHidden = true
        presentingSnapshot.alpha = 1.0
        
        // Add presentedSnapshot (will move) on top of presentedVC.view
        let presentedVC = transitionContext.viewController(forKey: .from)!
        guard let presentedSnapshot = presentedVC.view.snapshotView(afterScreenUpdates: true) else { return }
        presentedSnapshot.frame = presentedVC.view.frame
        transitionContext.containerView.addSubview(presentedSnapshot)
        presentedVC.view.isHidden = true
        
        // Animation
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: .easeInOut)
        animator.addAnimations {
            UIView.animateKeyframes(withDuration: self.duration, delay: 0, options: [.calculationModeCubic], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.00, relativeDuration: 0.45, animations: {
//                    presentedSnapshot.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.10, animations: {
                    presentedSnapshot.alpha = 0.0
                    presentingSnapshot.alpha = 1.0
                })
                UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45, animations: {
//                    presentingSnapshot.transform = .identity
                })
            })
        }
        
        // Remove snapshots
        animator.addCompletion { (position) in
            presentingVC.view.isHidden = false
            presentingSnapshot.removeFromSuperview()
            presentedSnapshot.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
        // Perform animation
        animator.startAnimation()
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return duration
    }
    
}
