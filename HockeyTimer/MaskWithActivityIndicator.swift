//
//  MaskWithActivityIndicator.swift
//  EcoWERFAfvalkalenders
//
//  Created by Steven Adons on 19/02/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

// HOW TO USE
// -------------------------------------------------------------------------------------------
// Property:
// private var maskWithActivityIndicator: MaskWithActivityIndicator?
//
// To add:
// maskWithActivityIndicator = MaskWithActivityIndicator.init(inView: view)
//
// To remove:
// maskWithActivityIndicator?.removeFromSuperview()
// -------------------------------------------------------------------------------------------

import UIKit

class MaskWithActivityIndicator: UIView {

    private var loadingView: UIView!
    private let loadingViewWidth: Int = 80
    private let loadingViewHeight: Int = 80
    private let loadingViewColor: UIColor = UIColor(named: ColorName.DarkBlue)!
    private let loadingViewAlpha: CGFloat = 1.0 // 0.7
    private let loadingViewCornerRadius: CGFloat = 10
    
    private var activityIndicatorView: UIActivityIndicatorView!
    private let activityIndicatorViewWidth: Int = 40
    private let activityIndicatorViewHeight: Int = 40
    private let activityIndicatorViewStyle: UIActivityIndicatorView.Style = .large
    
    convenience init(inView containingView: UIView) {
        
        self.init()
        self.frame = containingView.frame
        self.center = containingView.center
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        loadingView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: loadingViewWidth, height: loadingViewHeight)
        loadingView.center.x = containingView.center.x
        loadingView.center.y = containingView.center.y * 2 / 3 // * 2 / 3
        loadingView.backgroundColor = loadingViewColor
        loadingView.alpha = loadingViewAlpha
        loadingView.layer.cornerRadius = loadingViewCornerRadius
        loadingView.clipsToBounds = true
        
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: activityIndicatorViewWidth, height: activityIndicatorViewHeight)
        activityIndicatorView.style = activityIndicatorViewStyle
        activityIndicatorView.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(activityIndicatorView)
        self.addSubview(loadingView)
        containingView.addSubview(self)
        activityIndicatorView.startAnimating()
        
    }

}
