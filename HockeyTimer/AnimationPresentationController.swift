//
//  AnimationPresentationController.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 9/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class AnimationPresentationController: UIPresentationController {
    
    
    // MARK: - Properties
    
    let chrome = UIView()
    
    
    
    // MARK: - Methods
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        return containerView!.bounds.insetBy(dx: 0, dy: 0)
    }
    
    
    override func presentationTransitionWillBegin() {
        
        chrome.frame = containerView!.bounds
        chrome.backgroundColor = COLOR.Theme
        containerView!.insertSubview(chrome, at: 0)
        
        // animation or transitioncoordinator
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn, animations: {
//            if let presentingVC = self.presentingViewController as? TimerVC {
//                 change UI in TimerVC (alpha, scale,...)
//            }
        })
        animator.startAnimation()
    }
    
    
    override func dismissalTransitionWillBegin() {
        
        // get things from (to be dismissed) presentedviewcontroller and add to presentingviewcontroller
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
//            if let presentingVC = self.presentingViewController as? TimerVC {
//                 change UI in TimerVC (alpha, scale,...) back
//            }
        }, completion: { (context) in
            self.chrome.removeFromSuperview()
        })
    }
    
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        
        if !completed { chrome.removeFromSuperview() } // if transition gets interrupted
    }
    

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        
        if !completed { chrome.removeFromSuperview() } // if transition gets interrupted
    }
    
    
    override func containerViewWillLayoutSubviews() {
        
        chrome.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
}

