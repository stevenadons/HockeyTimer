//
//  CountryMenu.swift
//  HockeyTimer
//
//  Created by Steven Adons on 10/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit


protocol CountryMenuDelegate: class {
    
    func handleCountryMenuMainButtonTapped()
    func handleCountryMenuOtherButtonTapped(buttonNumber: Int)
    func didShowButtons()
    func willHideButtons()
}


class CountryMenu: UIView {
    
    
    // NOTE
    // How to use:
    // var menu: CountryMenu!
    // menu = CountryMenu(inView: view, delegate: self)
    // menu.removeFromSuperview()
    
    
    // MARK: - Properties
    
    private weak var delegate: CountryMenuDelegate?
    private var labelNames: [String]!
    private var capitalsStrings: [String]!
    private var selected: Int!
    private var leftSide: Bool!
    private var condensedColor: UIColor = .white
    private var foldOutColor: UIColor = UIColor(named: ColorName.OliveText)!

    private var menuButton: OvalCountryButton!
    private var buttons: [OvalCountryButton]!
    private var labels: [CountryLabelButton]!
    
    private var tap: UITapGestureRecognizer!
    
    private let buttonWidth: CGFloat = 44
    private let buttonHeight: CGFloat = 44
    private let horInset: CGFloat = UIDevice.whenDeviceIs(small: 37, normal: 42, big: 42)
    private var topInset: CGFloat = UIDevice.whenDeviceIs(small: 30, normal: 45, big: 45)
    private let labelHeight: CGFloat = 25
    private let padding: CGFloat = 18
    private let labelInset: CGFloat = 20
    
    
    // MARK: - Initializing
    
    convenience init(inView containingView: UIView, condensedColor: UIColor, foldOutColor: UIColor, delegate: CountryMenuDelegate, labelNames: [String], capitalsStrings: [String], leftSide: Bool = false, selected: Int? = 0) {
        
        self.init()
        
        self.frame = containingView.frame
        self.center = containingView.center
        self.backgroundColor = .clear
        self.condensedColor = condensedColor
        self.foldOutColor = foldOutColor
        self.delegate = delegate
        self.labelNames = labelNames
        self.capitalsStrings = capitalsStrings
        self.leftSide = leftSide
        self.selected = selected
        
        tap = UITapGestureRecognizer(target: self, action: #selector(hideButtons))
        addGestureRecognizer(tap)
        
        var menuButtonCapitals = ""
        if let selectedInt = selected, selectedInt < capitalsStrings.count {
            menuButtonCapitals = capitalsStrings[selectedInt]
        }
        menuButton = OvalCountryButton(capitals: menuButtonCapitals, color: condensedColor, crossColor: foldOutColor)
        menuButton.addTarget(self, action: #selector(handleMenuButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        addSubview(menuButton)
        
        buttons = []
        
        for index in 0..<capitalsStrings.count {
            
            let button = OvalCountryButton(capitals: capitalsStrings[index], color: foldOutColor, crossColor: foldOutColor)
            button.tag = index
            button.addTarget(self, action: #selector(handleOtherButtonTapped(sender:forEvent:)), for: [.touchUpInside])
            if index == 0 {
                insertSubview(button, belowSubview: menuButton)
            } else {
                insertSubview(button, belowSubview: buttons[index - 1])
            }
            buttons.append(button)
        }
        
        labels = []
        
        for index in 0..<labelNames.count {
            
            let labelButton = CountryLabelButton()
            labelButton.contentHorizontalAlignment = leftSide ? .left : .right
            labelButton.tag = index
            labelButton.addTarget(self, action: #selector(handleOtherButtonTapped(sender:forEvent:)), for: [.touchUpInside])
            labelButton.isUserInteractionEnabled = false
            if index == 0 {
                insertSubview(labelButton, belowSubview: menuButton)
            } else {
                insertSubview(labelButton, belowSubview: labels[index - 1])
            }
            labels.append(labelButton)
        }
        
        windUp()
        
        containingView.addSubview(self)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        menuButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        let x = leftSide ? horInset : UIScreen.main.bounds.width - horInset - buttonWidth
        menuButton.frame.origin = CGPoint(x: x, y: topInset)
        
        for index in 0..<buttons.count {
            buttons[index].frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            let baseY = menuButton.frame.origin.y + menuButton.bounds.height + padding
            let y = baseY + CGFloat(index) * (buttons[index].bounds.height + padding)
            buttons[index].frame.origin = CGPoint(x: x, y: y)
        }
        
        let labelWidth = UIScreen.main.bounds.width * 0.9 - buttonWidth - labelInset - horInset
        let xLabel = leftSide ? horInset + buttonWidth + labelInset : UIScreen.main.bounds.width * 0.1
        for index in 0..<labels.count {
            labels[index].frame = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
            let y = buttons[index].frame.origin.y + (buttons[index].bounds.height - labels[index].bounds.height) / 2
            labels[index].frame.origin = CGPoint(x: xLabel, y: y)
        }
        
        menuButton.setColor(condensedColor, crossColor: foldOutColor)
        buttons.forEach {
            $0.setColor(foldOutColor, crossColor: foldOutColor)
        }
    }
    
    private func windUp() {
        
        for index in 0..<buttons.count {
            let y = -CGFloat(index + 1) * (padding + buttons[0].bounds.height)
            buttons[index].transform = CGAffineTransform(translationX: 0, y: y)
            buttons[index].alpha = 0.0
        }
    }
    
    
    @objc private func handleMenuButtonTapped(sender: OvalCountryButton, forEvent event: UIEvent) {
        
        delegate?.handleCountryMenuMainButtonTapped()

        if buttons[0].transform == .identity {
            hideButtons()
            
        } else {
            showButtons()
        }
    }
    
    @objc private func handleOtherButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        
        delegate?.handleCountryMenuOtherButtonTapped(buttonNumber: sender.tag)

        selected = sender.tag
        if selected < capitalsStrings.count {
            menuButton.setCapitals(capitalsStrings[selected])
        }
        
        hideButtons()
    }
    
    private func showButtons(animated: Bool = true) {
        
        menuButton.showCross()
        
        buttons.forEach {
            $0.alpha = 1.0
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                self.backgroundColor = UIColor.systemBackground
                self.buttons.forEach {
                    $0.transform = .identity
                }
                
            }, completion: {(finished) in
                for index in 0..<self.labels.count {
                    self.labels[index].grow(text: self.labelNames[index], duration: 0.1)
                    self.labels[index].isUserInteractionEnabled = true
                }
            })
            
        } else {
            backgroundColor = UIColor.systemBackground
            buttons.forEach {
                $0.transform = .identity
            }
            for index in 0..<self.labels.count {
                self.labels[index].grow(text: self.labelNames[index], duration: 0.1)
                self.labels[index].isUserInteractionEnabled = true
            }
        }
        
        delegate?.didShowButtons()
        
    }
    
    
    // MARK: - Public Methods
    
    @objc func hideButtons(animated: Bool = true) {
        
        guard buttons[0].transform == .identity else { return }

        menuButton.hideCross()
        delegate?.willHideButtons()
        
        labels.forEach {
            $0.title = ""
            $0.isUserInteractionEnabled = false
        }
        
        if animated {
            UIView.animate(withDuration: 0.1) {
                self.buttons.forEach {
                    $0.alpha = 0.0
                }
            }
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.0, options: [], animations: {
                self.backgroundColor = .clear
                for index in 0..<self.buttons.count {
                    let y = -CGFloat(index + 1) * (self.padding + self.buttons[0].bounds.height)
                    self.buttons[index].transform = CGAffineTransform(translationX: 0, y: y)
                }
            }, completion: nil)
            
        } else {
            buttons.forEach {
                $0.alpha = 0.0
            }
            self.backgroundColor = .clear
            for index in 0..<self.buttons.count {
                let y = -CGFloat(index + 1) * (self.padding + self.buttons[0].bounds.height)
                self.buttons[index].transform = CGAffineTransform(translationX: 0, y: y)
            }
        }
        
    }
    
    
    // MARK: - Touch Methods
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if backgroundColor == .clear {
            // If menu not collapsed: only return subviews
            var hitTestView = super.hitTest(point, with: event)
            if hitTestView == self {
                hitTestView = nil
            }
            return hitTestView
        }
        // If menu expanded: standard hittesting
        return super.hitTest(point, with: event)
    }
}
