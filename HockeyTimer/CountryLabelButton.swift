//
//  CountryLabelButton.swift
//  HockeyTimer
//
//  Created by Steven Adons on 13/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class CountryLabelButton: UIButton {
    
    
    // MARK: - Properties
    
    var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
            setNeedsDisplay()
        }
    }
    var color: UIColor = UIColor.white {
        didSet {
            setTitleColor(color, for: .normal)
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
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        titleLabel?.font = UIFont(name: "Lato-Bold", size: 16)
        contentHorizontalAlignment = .right
    }
    
    
    // MARK: - User Methods
    
    func grow(text: String, duration: Double) {
        
        let charCount = text.count
        var index: Int = 0
        let _ = Timer.scheduledTimer(withTimeInterval: duration / Double(charCount), repeats: true) { (timer) in
            self.setTitle("\(String(text.prefix(index)))", for: .normal)
            index += 1
            if index > charCount {
                timer.invalidate()
            }
        }
    }
    
}
