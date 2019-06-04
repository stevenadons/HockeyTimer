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
        var inset: CGFloat = UIScreen.main.bounds.height >= 600 ? 135 : 105
        if UIScreen.main.bounds.height >= 750 {
            inset = 180
        }
        return inset
    }
    
    fileprivate let bottomInset: CGFloat = 130
    fileprivate let smallPadding: CGFloat = 10
    
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
        return min(max(totalbigPadding / 3, smallPadding * 2), RulesButton.fixedHeight * 0.75)
    }
    
    
    
    // MARK: - Initializing
    
    
    convenience init(delegate: RulesListDelegate, country: Country) {
        
        self.init()
        self.delegate = delegate
        self.country = country
        setup()
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
                    if outerIndex % 4 == 0 {
                        button = RulesButton.button(rules: groupOfRulesArray[innerIndex], color: COLOR.LightYellow, titleColor: COLOR.VeryDarkBlue)
                    } else if outerIndex % 4 == 1 {
                        button = RulesButton.button(rules: groupOfRulesArray[innerIndex], color: COLOR.LightBlue, titleColor: COLOR.VeryDarkBlue)
                    } else if outerIndex % 4 == 2 {
                        button = RulesButton.button(rules: groupOfRulesArray[innerIndex], color: COLOR.DarkBlue, titleColor: COLOR.White)
                    } else if outerIndex % 4 == 3 {
                        button = RulesButton.button(rules: groupOfRulesArray[innerIndex], color: COLOR.VeryDarkBlue, titleColor: COLOR.White)
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
        windUp()
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
    
    func animateFlyIn() {
        
        var delay: Double = 0.0
        for outerIndex in 0..<buttons.count {
            
            delay += (outerIndex > 0) ? 0.1 : 0.0
            let buttonGroup = buttons[outerIndex]
            for innerIndex in 0..<buttonGroup.count {
                
                delay += 0.03
                if buttonGroup[innerIndex].transform != .identity {
                    UIView.animate(withDuration: 0.2, delay: delay, options: [.allowUserInteraction, .curveEaseOut], animations: {
                        buttonGroup[innerIndex].transform = .identity
                    }, completion: nil)
                }
            }
        }
    }
}


