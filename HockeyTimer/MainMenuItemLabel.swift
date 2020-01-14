//
//  MainMenuItemLabel.swift
//  HockeyTimer
//
//  Created by Steven Adons on 14/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class MainMenuItemLabel: UIButton {

    
    // MARK: - Properties
    
    var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
            setNeedsDisplay()
        }
    }
    var color: UIColor = UIColor(named: ColorName.OliveText)! {
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
        
        backgroundColor = .clear
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 16)
        contentHorizontalAlignment = .left
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
