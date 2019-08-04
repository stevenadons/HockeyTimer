//
//  PopupMessageView.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/11/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PopupMessageView: UIView {

    
    // MARK: - Properties
    
    private var message: String = ""
    private var label: UILabel!
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(message: String) {
        
        self.init()
        self.message = message
        label.text = message
        label.setNeedsDisplay()
    }
  
    
    private func setup() {
        
        // Configuring self
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        // Childviews - add
        label = UILabel()
        label.numberOfLines = 0
        label.text = message
        label.font = UIFont(name: FONTNAME.ThemeBlack, size: 22)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = COLOR.White
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        // Childviews - constraints (or in layoutSubviews ?)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            ])
    }
    
    
    // MARK: - Hit testing
    
    //  Sometimes it is necessary for a view to ignore touch events and pass them through to the views below.
    //  For example, assume a transparent overlay view placed above all other application views.
    //  The overlay has some subviews in the form of controls and buttons which should respond to touches normally.
    //  But touching the overlay somewhere else should pass the touch events to the views below the overlay.
    //  http://smnh.me/hit-testing-in-ios/
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        var hitTestView = super.hitTest(point, with: event)
        if hitTestView == self {
            hitTestView = nil
        }
        return hitTestView
    }
    

}
