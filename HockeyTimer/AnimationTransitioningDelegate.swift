//
//  AnimationTransitioningDelegate.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 9/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//


//  How to use:
//  newVC.transitioningDelegate = animationTransitioningDelegate
//  newVC.modalPresentationStyle = .custom
//  newVC.modalTransitionStyle = .crossDissolve
//  present(newVC, animated: true, completion: nil)


import UIKit

class AnimationTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var startFrame: CGRect!
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return AnimationPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return AnimationAnimationController(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return AnimationAnimationController(isPresenting: false)
    }
    
}
