//
//  RulesList.swift
//  HockeyTimer
//
//  Created by Steven Adons on 04/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit


protocol RulesListDelegate: class {
    
    func handleButtonTapped(sender: RulesButton)
}



class RulesList: UIView {
    
    
    // MARK: - Properties
    
    fileprivate var buttons: [[RulesButton]]!
    fileprivate var delegate: RulesListDelegate?
    fileprivate var country: Country!
    
    fileprivate var topInset: CGFloat {
        var inset = UIDevice.whenDeviceIs(small: 90, normal: 120, big: 175)
        if buttons.joined().count <= 7 {
            inset += 40
        } else if buttons.joined().count <= 10 {
            inset += 20
        }
        return inset
    }
    
    fileprivate let bottomInset: CGFloat = 130
    fileprivate var smallPadding: CGFloat {
        if buttons.joined().count >= 10 {
            return 8
        }
        return 10
    }
    
    fileprivate var totalButtonsHeight: CGFloat {
        return CGFloat(buttons.joined().count) * RulesButton.fixedHeight
    }
    fileprivate var totalSmallPadding: CGFloat {
        var result: CGFloat = 0
        for group in buttons {
            if group.count > 1 {
                result += CGFloat(group.count - 1) * smallPadding
            }
        }
        return result
    }
    var bigPadding: CGFloat {
        let totalbigPadding = bounds.height - topInset - bottomInset - totalButtonsHeight - totalSmallPadding
        return min(max(totalbigPadding / CGFloat(buttons.count - 1), smallPadding * 1.5), RulesButton.fixedHeight * 0.5)
    }
    
    
    
    // MARK: - Initializing
    
    
    convenience init(delegate: RulesListDelegate, country: Country) {
        
        self.init()
        self.delegate = delegate
        self.country = country
        setup()
        windUp()
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        buttons = []
        
        for outerIndex in 0..<country.groupsOfRules.count {
            if let groupOfRulesArray = country.groupsOfRules[outerIndex].rulesArray {
                
                var buttonGroup: [RulesButton] = []
                for innerIndex in 0..<groupOfRulesArray.count {
                    
                    // Color
                    var button = RulesButton(rules: groupOfRulesArray[innerIndex])
                    if outerIndex % 5 == 0 {
                        button = RulesButton.button(rules: groupOfRulesArray[innerIndex], color: COLOR.LightYellow, titleColor: COLOR.VeryDarkBlue)
                    } else if outerIndex % 5 == 1 {
                        button = RulesButton.button(rules: groupOfRulesArray[innerIndex], color: COLOR.White, titleColor: COLOR.VeryDarkBlue)
                    } else if outerIndex % 5 == 2 {
                        button = RulesButton.button(rules: groupOfRulesArray[innerIndex], color: COLOR.DarkBlue, titleColor: COLOR.White)
                    } else if outerIndex % 5 == 3 {
                        button = RulesButton.button(rules: groupOfRulesArray[innerIndex], color: COLOR.VeryDarkBlue, titleColor: COLOR.White)
                    } else if outerIndex % 5 == 4 {
                        button = RulesButton.button(rules: groupOfRulesArray[innerIndex], color: COLOR.LightBlue, titleColor: COLOR.VeryDarkBlue)
                    }
                    button.addTarget(self, action: #selector(handleButtonTapped(sender:forEvent:)), for: [.touchUpInside])
                    button.heightAnchor.constraint(equalToConstant: RulesButton.fixedHeight).isActive = true
                    button.widthAnchor.constraint(equalToConstant: RulesButton.fixedWidth).isActive = true
                    addSubview(button)
                    buttonGroup.append(button)
                }
                buttons.append(buttonGroup)
            }
        }
    }
    
    
    // MARK: - Layout And Draw Methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let horInset = min((bounds.width - RulesButton.fixedWidth) / 2 - 15, 55)
        for outerIndex in 0..<buttons.count {
            let buttonGroup = buttons[outerIndex]
            for innerIndex in 0..<buttonGroup.count {

                let button = buttonGroup[innerIndex]
                
                // Leading and trailing constraints
                if outerIndex % 2 == 0 {
                    button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horInset).isActive = true
                    
                } else {
                    button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horInset).isActive = true
                }
                
                // Top constraints
                if outerIndex == 0 && innerIndex == 0 {
                    button.topAnchor.constraint(equalTo: topAnchor, constant: topInset).isActive = true
                    
                } else if outerIndex > 0 && innerIndex == 0 {
                    let previousButtonGroup = buttons[outerIndex - 1]
                    if let previousButton = previousButtonGroup.last {
                        button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: bigPadding).isActive = true
                    }
                    
                } else if innerIndex > 0 {
                    button.topAnchor.constraint(equalTo: buttonGroup[innerIndex - 1].bottomAnchor, constant: smallPadding).isActive = true
                }
            }
        }
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func handleButtonTapped(sender: RulesButton, forEvent event: UIEvent) {
        
        delegate?.handleButtonTapped(sender: sender)
    }
    
    
    // MARK: - User Methods
    
    func windUp() {
        
        for outerIndex in 0..<buttons.count {
            let buttonGroup = buttons[outerIndex]
            for innerIndex in 0..<buttonGroup.count {
                
                if outerIndex % 2 == 0 {
                    buttonGroup[innerIndex].transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                    
                } else {
                    buttonGroup[innerIndex].transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
                }
            }
        }
    }
    
    func windUpAnimated(then handler: ((Bool) -> Void)? = nil) {
        
        for outerIndex in 0..<buttons.count {
            let buttonGroup = buttons[outerIndex]
            for innerIndex in 0..<buttonGroup.count {
                
                if outerIndex % 2 == 0 {
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
                        buttonGroup[innerIndex].transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                    }) { (finished) in
                        if outerIndex == self.buttons.count - 1 && innerIndex == buttonGroup.count - 1 {
                            handler?(finished)
                        }
                    }
                    
                } else {
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
                        buttonGroup[innerIndex].transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
                    }) { (finished) in
                        if outerIndex == self.buttons.count - 1 && innerIndex == buttonGroup.count - 1 {
                            handler?(finished)
                        }
                    }
                }
            }
        }
    }
    
    func animateFlyIn(then handler: ((Bool) -> Void)? = nil) {
                
        DispatchQueue.main.async {
            var delay: Double = 0.0
            for outerIndex in 0..<self.buttons.count {
                
                delay += (outerIndex > 0) ? 0.1 : 0.0
                let buttonGroup = self.buttons[outerIndex]
                for innerIndex in 0..<buttonGroup.count {
                    
                    delay += 0.03
                    if buttonGroup[innerIndex].transform != .identity {
                        UIView.animate(withDuration: 0.2, delay: delay, options: [.allowUserInteraction, .curveEaseOut], animations: {
                            buttonGroup[innerIndex].transform = .identity
                        }, completion: { finished in
                            if outerIndex == self.buttons.count - 1 && innerIndex == buttonGroup.count {
                                handler?(finished)
                            }
                        })
                    }
                }
            }
        }
        
        
    }
    
    func setCountry(_ country: Country) {
        
        guard country != self.country else { return }
        
        for button in buttons.joined() {
            button.removeFromSuperview()
        }
        self.country = country
        setup()
        windUp()
        animateFlyIn()
        
    }
}


