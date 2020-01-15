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
    private var labelNames: [String] = [LS_SETTINGS_WRITE_A_REVIEW, LS_SETTINGS_SHARE, LS_SETTINGS_CONTACT, "Dark Mode", "Light Mode", "Privacy Policy"]
    private let switchFlags: [Bool] = [false, false, false, true, true, false]
    private var condensedColor: UIColor = .white
    private var foldOutColor: UIColor = UIColor(named: ColorName.OliveText)!
   
    private var menu: MainMenuButton!
    private var itemButtons: [UIButton] = []
    private var itemLabels: [MainMenuItemLabel] = []
    private var uiSwitches: [UISwitch] = []
    
    private var tap: UITapGestureRecognizer!
   
    private let buttonWidth: CGFloat = 44
    private let buttonHeight: CGFloat = 44
    private let horInset: CGFloat = UIDevice.whenDeviceIs(small: 20, normal: 25, big: 25) // UIDevice.whenDeviceIs(small: 37, normal: 42, big: 42)
    private var topInset: CGFloat = UIDevice.whenDeviceIs(small: 30, normal: 45, big: 45)
    private let labelHeight: CGFloat = 25
    private let padding: CGFloat = 16
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
        
        menu = MainMenuButton(hamburgerColor: condensedColor, crossColor: foldOutColor)
        menu.addTarget(self, action: #selector(handleMenuButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        menu.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        menu.frame.origin = CGPoint(x: horInset, y: topInset)
        addSubview(menu)
                
        createItemButtons()
        createLabelButtons()
        createUISwitches()
        
        windUp()
        
        containingView.addSubview(self)
    }
    
    private func createItemButtons() {
        
        for index in 0 ..< labelNames.count {
            
            let button = UIButton()
            button.setImage(imageAtPosition(index), for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(handleOtherButtonTapped(sender:forEvent:)), for: [.touchUpInside])
            if index == 0 {
                insertSubview(button, belowSubview: menu)
            } else {
                insertSubview(button, belowSubview: itemButtons[index - 1])
            }
            itemButtons.append(button)
        }
    }
    
    private func createLabelButtons() {
        
        for index in 0 ..< labelNames.count {
            
            let labelButton = MainMenuItemLabel()
            labelButton.tag = index
            labelButton.addTarget(self, action: #selector(handleOtherButtonTapped(sender:forEvent:)), for: [.touchUpInside])
            labelButton.isUserInteractionEnabled = false
            if index == 0 {
                insertSubview(labelButton, belowSubview: menu)
            } else {
                insertSubview(labelButton, belowSubview: itemLabels[index - 1])
            }
            itemLabels.append(labelButton)
        }
    }
    
    private func createUISwitches() {
        
        for index in 0 ..< labelNames.count {
            
            let uiSwitch = UISwitch()
            uiSwitch.tag = index
            uiSwitch.addTarget(self, action: #selector(handleSwitch(uiSwitch:)), for: [.valueChanged])
            uiSwitch.tintColor = UIColor(named: ColorName.OliveText)!
            uiSwitch.thumbTintColor = UIColor(named: ColorName.OliveText)!
            uiSwitch.onTintColor = UIColor(named: ColorName.LightYellow)!
            uiSwitch.isUserInteractionEnabled = false
            if index == 0 {
                insertSubview(uiSwitch, belowSubview: menu)
            } else {
                insertSubview(uiSwitch, belowSubview: uiSwitches[index - 1])
            }
            uiSwitches.append(uiSwitch)
        }
    }
    
    private func windUp() {
        
        for index in 0..<itemButtons.count {
            
            let yItemButton = -CGFloat(index + 1) * (padding + itemButtons[0].bounds.height)
            itemButtons[index].transform = CGAffineTransform(translationX: 0, y: yItemButton)
            itemButtons[index].alpha = 0.0

            uiSwitches[index].alpha = 0.0
        }
    }
    
    private func imageAtPosition(_ int: Int) -> UIImage {
        
        var systemName: String
        switch int {
        case 0:
            systemName = "square.and.pencil"
        case 1:
            systemName = "square.and.arrow.up"
        case 2:
            systemName = "envelope"
        case 3:
            systemName = "aspectratio.fill"
        case 4:
            systemName = "aspectratio"
        default:
            systemName = "checkmark.shield"
        }
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)
        return (UIImage(systemName: systemName, withConfiguration: configuration)?.withTintColor(foldOutColor, renderingMode: .alwaysOriginal))!
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
        
        menu.showCross()
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                self.backgroundColor = .systemBackground
                self.itemButtons.forEach {
                    $0.transform = .identity
                    $0.alpha = 1.0
                }
                
            }, completion: {(finished) in
                for index in 0 ..< self.itemLabels.count {
                    
                    self.itemLabels[index].grow(text: self.labelNames[index], duration: 0.1)
                    self.itemLabels[index].isUserInteractionEnabled = true
                    
                    UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
                        self.uiSwitches[index].alpha = self.switchFlags[index] ? 1.0 : 0.0
                    }) { (finished) in
                        self.uiSwitches[index].isUserInteractionEnabled = self.switchFlags[index]
                    }
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
                self.uiSwitches[index].alpha = self.switchFlags[index] ? 1.0 : 0.0
                self.uiSwitches[index].isUserInteractionEnabled = self.switchFlags[index]
            }
        }
        delegate?.mainMenuDidShowButtons()
    }
    
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        for index in 0 ..< itemButtons.count {
            
            let image = imageAtPosition(index)
            itemButtons[index].setImage(image, for: .normal)
            
            uiSwitches[index].tintColor = UIColor(named: ColorName.OliveText)!
            uiSwitches[index].thumbTintColor = UIColor(named: ColorName.OliveText)!
            uiSwitches[index].onTintColor = UIColor(named: ColorName.LightYellow)!
        }
        
        menu.setColor(hamburgerColor: condensedColor, crossColor: foldOutColor)
        positionElements()
    }
    
    private func positionElements() {
        
        let uiSwitchWidth: CGFloat = 80
        let labelWidth = bounds.width - horInset - buttonWidth - labelInset - labelInset / 2 - uiSwitchWidth - horInset
        let xLabel = horInset + buttonWidth + labelInset
        let xUISwitch = horInset + buttonWidth + labelInset + labelWidth + labelInset / 2

        for index in 0 ..< labelNames.count {
            
            let button = itemButtons[index]
            let yButton = menu.frame.origin.y + menu.bounds.height + padding + CGFloat(index) * (button.bounds.height + padding)
            button.frame = CGRect(x: horInset, y: yButton, width: buttonWidth, height: buttonHeight)
            
            let label = itemLabels[index]
            let yLabel = button.frame.origin.y + (button.bounds.height - label.bounds.height) / 2
            label.frame = CGRect(x: xLabel, y: yLabel, width: labelWidth, height: labelHeight)
            
            let uiSwitch = uiSwitches[index]
            let yUISwitch = button.frame.origin.y + (button.bounds.height - uiSwitch.bounds.height) / 2
            uiSwitch.frame = CGRect(x: xUISwitch, y: yUISwitch, width: uiSwitchWidth, height: 60)
        }
    }
    
    
    // MARK: - Touch
    
    @objc private func handleSwitch(uiSwitch: UISwitch) {
        
        print("switch")
    }

    
    // MARK: - Public Methods

    @objc func hideButtons(animated: Bool = true) {
        
        guard itemButtons[0].transform == .identity else { return }
        
        delegate?.mainMenuWillHideButtons()
        
        itemLabels.forEach {
            $0.title = ""
            $0.isUserInteractionEnabled = false
        }
        uiSwitches.forEach {
            $0.alpha = 0.0
            $0.isUserInteractionEnabled = false
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.0, options: [], animations: {
                self.backgroundColor = .clear
                self.menu.showHamburger()
                for index in 0 ..< self.itemButtons.count {
                    
                    let yItemButton = -CGFloat(index + 1) * (self.padding + self.itemButtons[0].bounds.height)
                    self.itemButtons[index].transform = CGAffineTransform(translationX: 0, y: yItemButton)
                    self.itemButtons[index].alpha = 0.0
                    
                    let yUISwitch = -CGFloat(index + 1) * (self.padding + self.uiSwitches[0].bounds.height)
                    self.uiSwitches[index].transform = CGAffineTransform(translationX: 0, y: yUISwitch)
                    self.uiSwitches[index].alpha = 0.0
                    self.uiSwitches[index].isUserInteractionEnabled = false
                }
            }, completion: nil)
            
        } else {
            
            backgroundColor = .clear
            for index in 0..<self.itemButtons.count {
                
                let yItemButton = -CGFloat(index + 1) * (padding + itemButtons[0].bounds.height)
                itemButtons[index].transform = CGAffineTransform(translationX: 0, y: yItemButton)
                itemButtons[index].alpha = 0.0
                
                let yUISwitch = -CGFloat(index + 1) * (padding + uiSwitches[0].bounds.height)
                uiSwitches[index].transform = CGAffineTransform(translationX: 0, y: yUISwitch)
                uiSwitches[index].alpha = 0.0
                uiSwitches[index].isUserInteractionEnabled = false
                
            }
            menu.showHamburger()
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
