//
//  Mask.swift
//  HockeyTimer
//
//  Created by Steven Adons on 25/05/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//
//
// HOW TO USE
// -------------------------------------------------------------------------------------------
// Property:
// private var mask: Mask?
//
// To add:
// mask = Mask(color: UIColor.black, inView: view)
//
// To remove:
// mask?.removeFromSuperview()
// -------------------------------------------------------------------------------------------
//


import UIKit

class Mask: UIView {
    
    convenience init(color: UIColor, inView containingView: UIView) {
        
        self.init()
        self.frame = containingView.frame
        self.center = containingView.center
        self.backgroundColor = color
        
        containingView.addSubview(self)
    }
}
