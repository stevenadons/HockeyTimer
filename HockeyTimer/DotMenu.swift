//
//  DotMenu.swift
//  DotMenu
//
//  Created by Steven Adons on 14/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


protocol DotMenuDelegate: class {
    
    func handleDotMenuButtonTapped(buttonNumber: Int)
}


class DotMenu: UIView {
    
    
    // NOTE
    // How to use:
    // var dotMenu: DotMenu!
    // dotMenu = DotMenu(inView: view, delegate: self)
    // dotMenu.removeFromSuperview()

    
    // MARK: - Properties
    
    private weak var delegate: DotMenuDelegate?
    private var labelNames: [String]!
    private var capitalsStrings: [String]!
    private var selected: Int!
   
    private var menuButton: OvalCountryButton!
    private var buttons: [OvalCountryButton]!
    private var labels: [ButtonLabel]!
    
    private var tap: UITapGestureRecognizer!
   
    private let buttonWidth: CGFloat = 44
    private let buttonHeight: CGFloat = 44
    private let horInset: CGFloat = 40
    private var topInset: CGFloat = 44
    private let labelHeight: CGFloat = 25
    private let padding: CGFloat = 18
    private let labelInset: CGFloat = 20
    
    
    // MARK: - Initializing
    
    convenience init(inView containingView: UIView, delegate: DotMenuDelegate, labelNames: [String], capitalsStrings: [String], selected: Int? = 0) {
        
        self.init()
        self.frame = containingView.frame
        self.center = containingView.center
        let extraOffset = UIDevice.whenDeviceIs(small: 32, normal: 40, big: 60)
        self.topInset = containingView.safeAreaLayoutGuide.layoutFrame.origin.y + extraOffset
        self.backgroundColor = UIColor.clear
        self.delegate = delegate
        self.labelNames = labelNames
        self.capitalsStrings = capitalsStrings
        self.selected = selected
        
        tap = UITapGestureRecognizer(target: self, action: #selector(hideButtons))
        addGestureRecognizer(tap)
        
        var menuButtonCapitals = ""
        if let selectedInt = selected, selectedInt < capitalsStrings.count {
            menuButtonCapitals = capitalsStrings[selectedInt]
        }
        menuButton = OvalCountryButton(capitals: menuButtonCapitals)
        menuButton.addTarget(self, action: #selector(handleMenuButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        menuButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        let x = UIScreen.main.bounds.width - horInset - buttonWidth
        menuButton.frame.origin = CGPoint(x: x, y: topInset)
        addSubview(menuButton)
        
        buttons = []
        
        for index in 0..<capitalsStrings.count {
            
            let button = OvalCountryButton(capitals: capitalsStrings[index])
            button.tag = index
            button.addTarget(self, action: #selector(handleOtherButtonTapped(sender:forEvent:)), for: [.touchUpInside])
            button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            let baseY = menuButton.frame.origin.y + menuButton.bounds.height + padding
            let y = baseY + CGFloat(index) * (button.bounds.height + padding)
            button.frame.origin = CGPoint(x: x, y: y)
            if index == 0 {
                insertSubview(button, belowSubview: menuButton)
            } else {
                insertSubview(button, belowSubview: buttons[index - 1])
            }
            buttons.append(button)
        }
        
        let labelWidth = UIScreen.main.bounds.width * 0.75 - buttonWidth - labelInset - horInset
        
        labels = []
        
        for index in 0..<labelNames.count {
            
            let label = ButtonLabel()
            label.frame = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
            let y = buttons[index].frame.origin.y + (buttons[index].bounds.height - label.bounds.height) / 2
            label.frame.origin = CGPoint(x: UIScreen.main.bounds.width * 0.25, y: y)
            if index == 0 {
                insertSubview(label, belowSubview: menuButton)
            } else {
                insertSubview(label, belowSubview: labels[index - 1])
            }
            labels.append(label)
        }
        
        windUp()
        
        containingView.addSubview(self)
    }
    
    private func windUp() {
        
        for index in 0..<buttons.count {
            let y = -CGFloat(index + 1) * (padding + buttons[0].bounds.height)
            buttons[index].transform = CGAffineTransform(translationX: 0, y: y)
            buttons[index].alpha = 0.0
        }
    }
    
    
    @objc private func handleMenuButtonTapped(sender: OvalCountryButton, forEvent event: UIEvent) {
        
        if buttons[0].transform == .identity {
            hideButtons()
            
        } else {
            showButtons()
        }
    }
    
    @objc private func handleOtherButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        
        selected = sender.tag
        if selected < capitalsStrings.count {
            menuButton.setCapitals(capitalsStrings[selected])
        }
        
        hideButtons()
        
        delegate?.handleDotMenuButtonTapped(buttonNumber: sender.tag)
    }
    
    private func showButtons(animated: Bool = true) {
        
        menuButton.showCross()
        
        buttons.forEach {
            $0.alpha = 1.0
        }
        
        if animated {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                self.buttons.forEach {
                    $0.transform = .identity
                }
                
            }, completion: {(finished) in
                for index in 0..<self.labels.count {
                    self.labels[index].grow(text: self.labelNames[index], duration: 0.1)
                }
            })
            
        } else {
            backgroundColor = UIColor.black.withAlphaComponent(0.8)
            buttons.forEach {
                $0.transform = .identity
            }
            for index in 0..<self.labels.count {
                self.labels[index].grow(text: self.labelNames[index], duration: 0.1)
            }
        }
        
    }
    
    
    // MARK: - Public Methods

    @objc func hideButtons(animated: Bool = true) {
        
        menuButton.hideCross()
        
        labels.forEach {
            $0.title = ""
        }
        
        if animated {
            UIView.animate(withDuration: 0.1) {
                self.buttons.forEach {
                    $0.alpha = 0.0
                }
            }
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.0, options: [], animations: {
                self.backgroundColor = UIColor.clear
                for index in 0..<self.buttons.count {
                    let y = -CGFloat(index + 1) * (self.padding + self.buttons[0].bounds.height)
                    self.buttons[index].transform = CGAffineTransform(translationX: 0, y: y)
                }
            }, completion: nil)
            
        } else {
            buttons.forEach {
                $0.alpha = 0.0
            }
            self.backgroundColor = UIColor.clear
            for index in 0..<self.buttons.count {
                let y = -CGFloat(index + 1) * (self.padding + self.buttons[0].bounds.height)
                self.buttons[index].transform = CGAffineTransform(translationX: 0, y: y)
            }
        }
        
    }
   
    
    // MARK: - Touch Methods
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if backgroundColor == UIColor.clear {
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
