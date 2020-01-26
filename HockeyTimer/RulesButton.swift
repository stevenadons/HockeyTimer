//
//  RulesButton.swift
//  HockeyTimer
//
//  Created by Steven Adons on 04/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class RulesButton: UIButton {
    
    
    // MARK: - Properties
    
    private(set) var rules: Rules! {
        didSet {
            setTitle(rules.name, for: .normal)
            setNeedsDisplay()
        }
    }
    
    static let fixedWidth: CGFloat = 220
    static var fixedHeight: CGFloat {
        return UIDevice.whenDeviceIs(small: 38, normal: 44, big: 44)
    }
    static var fixedHeightSmaller: CGFloat {
        return UIDevice.whenDeviceIs(small: 34, normal: 40, big: 40)
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
    
    convenience init(rules: Rules) {
        
        self.init()
        convenienceSet(rules: rules)
    }
    
    private func convenienceSet(rules: Rules) {
        
        self.rules = rules
    }
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 15)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}


extension RulesButton {
    
    class func button(rules: Rules, color: UIColor, titleColor: UIColor) -> RulesButton {
        
        let button = RulesButton(rules: rules)
        
        button.backgroundColor = color
        button.setTitleColor(titleColor, for: .normal)
        
        return button
    }
}

