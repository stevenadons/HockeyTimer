//
//  MainMenu.swift
//  HockeyTimer
//
//  Created by Steven Adons on 14/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


protocol MainMenuDelegate: class {
    
    func mainMenuMainButtonTapped()
    func mainMenuOtherButtonTapped(buttonNumber: Int)
    func mainMenuDidShowButtons()
    func mainMenuWillHideButtons()
}


class MainMenu: UIView {
    
    // MARK: - Properties
    
    private weak var delegate: MainMenuDelegate?
    private var labelNames: [String] = [LS_SETTINGS_WRITE_A_REVIEW, LS_SETTINGS_SHARE, LS_SETTINGS_CONTACT]
    private var condensedColor: UIColor = .white
    private var foldOutColor: UIColor = UIColor(named: ColorName.OliveText)!
   
    private var menu: MainMenuButton!
    private var itemButtons: [UIButton]!
    private var itemLabels: [MainMenuItemLabel]!
    
    private var tap: UITapGestureRecognizer!
   
    private let buttonWidth: CGFloat = 44
    private let buttonHeight: CGFloat = 44
    private let horInset: CGFloat = UIDevice.whenDeviceIs(small: 37, normal: 42, big: 42)
    private var topInset: CGFloat = UIDevice.whenDeviceIs(small: 30, normal: 45, big: 45)
    private let labelHeight: CGFloat = 25
    private let padding: CGFloat = 18
    private let labelInset: CGFloat = 18
    
    
    // MARK: - Initializing
    
    convenience init(inView containingView: UIView, condensedColor: UIColor, foldOutColor: UIColor, delegate: MainMenuDelegate) {
        
        self.init()
        
        self.frame = containingView.frame
        self.center = containingView.center
        self.backgroundColor = .clear
        self.condensedColor = condensedColor
        self.foldOutColor = foldOutColor
        self.delegate = delegate

        tap = UITapGestureRecognizer(target: self, action: #selector(hideButtons))
        addGestureRecognizer(tap)
        
        menu = MainMenuButton(color: condensedColor, crossColor: foldOutColor)
        menu.addTarget(self, action: #selector(handleMenuButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        menu.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        menu.frame.origin = CGPoint(x: horInset, y: topInset)
        addSubview(menu)
        
        itemButtons = []
        
        for index in 0..<labelNames.count {
            
            let button = UIButton()
            button.setImage(imageAtPosition(index), for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(handleOtherButtonTapped(sender:forEvent:)), for: [.touchUpInside])
            button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            let baseY = menu.frame.origin.y + menu.bounds.height + padding
            let y = baseY + CGFloat(index) * (button.bounds.height + padding)
            button.frame.origin = CGPoint(x: horInset, y: y)
            if index == 0 {
                insertSubview(button, belowSubview: menu)
            } else {
                insertSubview(button, belowSubview: itemButtons[index - 1])
            }
            itemButtons.append(button)
        }
        
        let labelWidth = UIScreen.main.bounds.width * 0.9 - buttonWidth - labelInset - horInset
        let xLabel = horInset + buttonWidth + labelInset
        
        itemLabels = []
        
        for index in 0..<labelNames.count {
            
            let labelButton = MainMenuItemLabel()
            labelButton.tag = index
            labelButton.addTarget(self, action: #selector(handleOtherButtonTapped(sender:forEvent:)), for: [.touchUpInside])
            labelButton.isUserInteractionEnabled = false
            labelButton.frame = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
            let y = itemButtons[index].frame.origin.y + (itemButtons[index].bounds.height - labelButton.bounds.height) / 2
            labelButton.frame.origin = CGPoint(x: xLabel, y: y)
            if index == 0 {
                insertSubview(labelButton, belowSubview: menu)
            } else {
                insertSubview(labelButton, belowSubview: itemLabels[index - 1])
            }
            itemLabels.append(labelButton)
        }
        
        windUp()
        
        containingView.addSubview(self)
    }
    
    private func windUp() {
        
        for index in 0..<itemButtons.count {
            let y = -CGFloat(index + 1) * (padding + itemButtons[0].bounds.height)
            itemButtons[index].transform = CGAffineTransform(translationX: 0, y: y)
            itemButtons[index].alpha = 0.0
        }
    }
    
    private func imageAtPosition(_ int: Int) -> UIImage {
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)
        switch int {
        case 0:
            return (UIImage(systemName: "square.and.pencil", withConfiguration: configuration)?.withTintColor(foldOutColor, renderingMode: .alwaysOriginal))!
        case 1:
            return (UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration)?.withTintColor(foldOutColor, renderingMode: .alwaysOriginal))!
        default:
            return (UIImage(systemName: "envelope", withConfiguration: configuration)?.withTintColor(foldOutColor, renderingMode: .alwaysOriginal))!
        }
    }
    
    
    @objc private func handleMenuButtonTapped(sender: OvalCountryButton, forEvent event: UIEvent) {
        
        delegate?.mainMenuMainButtonTapped()
        if itemButtons[0].transform == .identity {
            hideButtons()
            
        } else {
            showButtons()
        }
    }
    
    @objc private func handleOtherButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        
        delegate?.mainMenuOtherButtonTapped(buttonNumber: sender.tag)
        hideButtons()
    }
    
    private func showButtons(animated: Bool = true) {
        
        menu.invert()
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                self.backgroundColor = .systemBackground
                self.itemButtons.forEach {
                    $0.transform = .identity
                    $0.alpha = 1.0
                }
                
            }, completion: {(finished) in
                for index in 0..<self.itemLabels.count {
                    self.itemLabels[index].grow(text: self.labelNames[index], duration: 0.1)
                    self.itemLabels[index].isUserInteractionEnabled = true
                }
            })
            
        } else {
            backgroundColor = .systemBackground
            itemButtons.forEach {
                $0.transform = .identity
                $0.alpha = 1.0
            }
            for index in 0..<self.itemLabels.count {
                self.itemLabels[index].grow(text: self.labelNames[index], duration: 0.1)
                self.itemLabels[index].isUserInteractionEnabled = true
            }
        }
        
        delegate?.mainMenuDidShowButtons()
        
    }
    
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        menu.setColor(condensedColor, crossColor: foldOutColor)
        for index in 0..<itemButtons.count {
            let image = imageAtPosition(index)
            itemButtons[index].setImage(image, for: .normal)
        }
    }

    
    
    // MARK: - Public Methods

    @objc func hideButtons(animated: Bool = true) {
        
        guard itemButtons[0].transform == .identity else { return }
        
        delegate?.mainMenuWillHideButtons()
        
        itemLabels.forEach {
            $0.title = ""
            $0.isUserInteractionEnabled = false
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.0, options: [], animations: {
                self.backgroundColor = .clear
                self.menu.reset()
                for index in 0..<self.itemButtons.count {
                    let y = -CGFloat(index + 1) * (self.padding + self.itemButtons[0].bounds.height)
                    self.itemButtons[index].transform = CGAffineTransform(translationX: 0, y: y)
                    self.itemButtons[index].alpha = 0.0
                }
            }, completion: nil)
            
        } else {
            backgroundColor = .clear
            for index in 0..<self.itemButtons.count {
                let y = -CGFloat(index + 1) * (self.padding + self.itemButtons[0].bounds.height)
                itemButtons[index].transform = CGAffineTransform(translationX: 0, y: y)
                itemButtons[index].alpha = 0.0
            }
            menu.reset()
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
