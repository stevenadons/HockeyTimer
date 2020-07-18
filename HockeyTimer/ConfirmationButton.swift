//
//  ConfirmationButton.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 12/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class ConfirmationButton: UIButton {

    
    // MARK: - Properties
    
    static let fixedWidth: CGFloat = 180
    static let fixedHeight: CGFloat = 44
    
    
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
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline) // UIFont(name: FONTNAME.ThemeBlack, size: 14)
        layer.cornerRadius = 8
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    }
    
    
    
    // MARK: - User Methods

    func grow() {
        
        transform = CGAffineTransform(scaleX: 0.01, y: 1)
        alpha = 1.0
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [.allowUserInteraction], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func shrink() {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations: { 
            self.transform = CGAffineTransform(scaleX: 0.01, y: 1)
        }) { (finished) in
            self.alpha = 0
            self.transform = CGAffineTransform.identity
        }
    }
}


extension ConfirmationButton {
    
    class func redButton(largeFont: Bool = false, shadow: Bool = false) -> ConfirmationButton {
        
        let button = ConfirmationButton()
        
        button.backgroundColor = UIColor(named: ColorName.PantoneRed)!
        button.setTitleColor(UIColor.white, for: .normal)
        if shadow {
            button.layer.shadowColor = UIColor.lightGray.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 1)
            button.layer.shadowOpacity = shadowed ? 0.8 : 0.0
            button.layer.shadowRadius = 3
        }
        
        if largeFont {
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline) // UIFont(name: FONTNAME.ThemeBold, size: 16)
        }
        
        return button
    }
    
    class func blueButton(largeFont: Bool = false) -> ConfirmationButton {
        
        let button = ConfirmationButton()
        
        button.backgroundColor = UIColor(named: ColorName.DarkBlue)!
        button.setTitleColor(UIColor.white, for: .normal)
        
        if largeFont {
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline) // UIFont(name: FONTNAME.ThemeBold, size: 16)
        }
        
        return button
    }
    
    class func yellowButton(largeFont: Bool = false) -> ConfirmationButton {
        
        let button = ConfirmationButton()
        
        button.backgroundColor = UIColor(named: ColorName.LightYellow)! 
        button.setTitleColor(UIColor(named: ColorName.VeryDarkBlue)!, for: .normal)
        
        if largeFont {
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline) // UIFont(name: FONTNAME.ThemeBold, size: 16)
        }
        
        return button
    }
    
    class func invertedYellowButton(largeFont: Bool = false) -> ConfirmationButton {
        
        let button = ConfirmationButton()
        
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor(named: ColorName.LightYellow)!, for: .normal)
        button.layer.borderColor = UIColor(named: ColorName.LightYellow)!.cgColor
        button.layer.borderWidth = 1.0
        
        if largeFont {
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline) // UIFont(name: FONTNAME.ThemeBlack, size: 16)
        }
        
        return button
    }
    
    class func themeButton() -> ConfirmationButton {
        
        let button = ConfirmationButton()
        button.backgroundColor = UIColor(named: ColorName.Theme)!
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }
}
