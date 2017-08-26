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
    
    static let fixedWidth: CGFloat = 150
    static let fixedHeight: CGFloat = 35
    
    
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
        titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 12)
//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 1)
//        layer.shadowOpacity = 0.8
//        layer.shadowRadius = 3
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
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
    
    class func redButton() -> ConfirmationButton {
        
        let button = ConfirmationButton()
        button.backgroundColor = COLOR.Negation
        button.setTitleColor(COLOR.White, for: .normal)
        return button
    }
    
    class func yellowButton() -> ConfirmationButton {
        
        let button = ConfirmationButton()
        button.backgroundColor = COLOR.Affirmation
        button.setTitleColor(COLOR.Theme, for: .normal)
        return button
    }
    
    class func themeButton() -> ConfirmationButton {
        
        let button = ConfirmationButton()
        button.backgroundColor = COLOR.Theme
        button.setTitleColor(COLOR.White, for: .normal)
        return button
    }
}
