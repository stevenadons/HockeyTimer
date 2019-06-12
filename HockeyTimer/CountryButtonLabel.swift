//
//  CountryButtonLabel.swift
//  HockeyTimer
//
//  Created by Steven Adons on 10/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class CountryButtonLabel: UILabel {
    
    
    // MARK: - Properties
    
    var title: String = "" {
        didSet {
            text = title
            setNeedsDisplay()
        }
    }
    var color: UIColor = UIColor.white {
        didSet {
            textColor = color
            setNeedsDisplay()
        }
    }
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        text = title
        font = UIFont(name: "Lato-Bold", size: 16)
        adjustsFontSizeToFitWidth = true
        isUserInteractionEnabled = false
        textAlignment = .right
        textColor = color
    }
    
    
    // MARK: - User Methods
    
    func grow(text: String, duration: Double) {
        
        let charCount = text.count
        var index: Int = 0
        let _ = Timer.scheduledTimer(withTimeInterval: duration / Double(charCount), repeats: true) { (timer) in
            self.title = "\(String(text.prefix(index)))"
            index += 1
            if index > charCount {
                timer.invalidate()
            }
        }
    }
    
}
