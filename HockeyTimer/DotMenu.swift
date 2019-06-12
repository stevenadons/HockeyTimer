//
//  DotMenu.swift
//  DotMenu
//
//  Created by Steven Adons on 14/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


protocol DotMenuDelegate: class {
    
    func handleDotMenuMainButtonTapped()
    func handleDotMenuOtherButtonTapped(buttonNumber: Int)
    func dotMenuDidShowButtons()
    func dotMenuWillHideButtons()
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
   
    private var menuButton: MenuButton!
    private var buttons: [ItemButton]!
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
    
    convenience init(inView containingView: UIView, delegate: DotMenuDelegate, labelNames: [String]) {
        
        self.init()
        
        self.frame = containingView.frame
        self.center = containingView.center
        let extraOffset = UIDevice.whenDeviceIs(small: 32, normal: 40, big: 60)
        self.topInset = containingView.safeAreaLayoutGuide.layoutFrame.origin.y + extraOffset
        self.backgroundColor = UIColor.clear
        self.delegate = delegate
        self.labelNames = labelNames

        tap = UITapGestureRecognizer(target: self, action: #selector(hideButtons))
        addGestureRecognizer(tap)
        
        menuButton = MenuButton(shapeColor: COLOR.White, bgColor: UIColor.clear)
        menuButton.addTarget(self, action: #selector(handleMenuButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        menuButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        menuButton.frame.origin = CGPoint(x: horInset, y: topInset)
        addSubview(menuButton)
        
        buttons = []
        
        for index in 0..<labelNames.count {
            
            var path: UIBezierPath
            switch index % 3 {
            case 0:
                path = pathEditButton(buttonWidth: buttonWidth, buttonHeight: buttonHeight)
            case 1:
                path = pathTimeButton(buttonWidth: buttonWidth, buttonHeight: buttonHeight)
            default:
                path = pathDocumentButton(buttonWidth: buttonWidth, buttonHeight: buttonHeight)
            }
            
            let button = ItemButton(shapeColor: COLOR.White, bgColor: UIColor.clear, path: path)
            button.tag = index
            button.addTarget(self, action: #selector(handleOtherButtonTapped(sender:forEvent:)), for: [.touchUpInside])
            button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            let baseY = menuButton.frame.origin.y + menuButton.bounds.height + padding
            let y = baseY + CGFloat(index) * (button.bounds.height + padding)
            button.frame.origin = CGPoint(x: horInset, y: y)
            if index == 0 {
                insertSubview(button, belowSubview: menuButton)
            } else {
                insertSubview(button, belowSubview: buttons[index - 1])
            }
            buttons.append(button)
        }
        
        let labelWidth = UIScreen.main.bounds.width * 0.75 - buttonWidth - labelInset - horInset
        let xLabel = horInset + buttonWidth + labelInset
        
        labels = []
        
        for index in 0..<labelNames.count {
            
            let label = ButtonLabel()
            label.textAlignment = .left
            label.frame = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
            let y = buttons[index].frame.origin.y + (buttons[index].bounds.height - label.bounds.height) / 2
            label.frame.origin = CGPoint(x: xLabel, y: y)
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
        
        delegate?.handleDotMenuMainButtonTapped()
        if buttons[0].transform == .identity {
            hideButtons()
            
        } else {
            showButtons()
        }
    }
    
    @objc private func handleOtherButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        
        delegate?.handleDotMenuOtherButtonTapped(buttonNumber: sender.tag)
        hideButtons()
    }
    
    private func showButtons(animated: Bool = true) {
        
        menuButton.invert()
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                self.buttons.forEach {
                    $0.transform = .identity
                    $0.alpha = 1.0
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
                $0.alpha = 1.0
            }
            for index in 0..<self.labels.count {
                self.labels[index].grow(text: self.labelNames[index], duration: 0.1)
            }
        }
        
        delegate?.dotMenuDidShowButtons()
        
    }
    
    
    // MARK: - Public Methods

    @objc func hideButtons(animated: Bool = true) {
        
        guard buttons[0].transform == .identity else { return }
        
        delegate?.dotMenuWillHideButtons()
        
        labels.forEach {
            $0.title = ""
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.0, options: [], animations: {
                self.backgroundColor = UIColor.clear
                self.menuButton.reset()
                for index in 0..<self.buttons.count {
                    let y = -CGFloat(index + 1) * (self.padding + self.buttons[0].bounds.height)
                    self.buttons[index].transform = CGAffineTransform(translationX: 0, y: y)
                    self.buttons[index].alpha = 0.0
                }
            }, completion: nil)
            
        } else {
            backgroundColor = UIColor.clear
            for index in 0..<self.buttons.count {
                let y = -CGFloat(index + 1) * (self.padding + self.buttons[0].bounds.height)
                buttons[index].transform = CGAffineTransform(translationX: 0, y: y)
                buttons[index].alpha = 0.0
            }
            menuButton.reset()
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
    
    
    // MARK: - Paths
    
    private func pathEditButton(buttonWidth: CGFloat, buttonHeight: CGFloat) -> UIBezierPath {
        
        let widthScale = buttonWidth / 44
        let heightScale = buttonHeight / 44
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 15.5 * widthScale, y: 19 * heightScale))
        path.addLine(to: CGPoint(x: 22 * widthScale, y: 12 * heightScale))
        path.addLine(to: CGPoint(x: 28.5 * widthScale, y: 19 * heightScale))
        path.move(to: CGPoint(x: 15.5 * widthScale, y: 25 * heightScale))
        path.addLine(to: CGPoint(x: 22 * widthScale, y: 32 * heightScale))
        path.addLine(to: CGPoint(x: 28.5 * widthScale, y: 25 * heightScale))
        
        return path
    }
    
    private func pathTimeButton(buttonWidth: CGFloat, buttonHeight: CGFloat) -> UIBezierPath {
        
        let widthScale = buttonWidth / 44
        let heightScale = buttonHeight / 44
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 22 * widthScale, y: 10 * heightScale))
        path.addArc(withCenter: CGPoint(x: 22 * widthScale, y: 22 * widthScale), radius: 12 * min(widthScale, heightScale), startAngle: -.pi/2, endAngle: .pi * 3 / 2, clockwise: true)
        path.move(to: CGPoint(x: 22 * widthScale, y: 14.5 * heightScale))
        path.addLine(to: CGPoint(x: 22 * widthScale, y: 22 * heightScale))
        path.addLine(to: CGPoint(x: 26.5 * widthScale, y: 19 * heightScale))
        
        return path
    }
    
    private func pathDocumentButton(buttonWidth: CGFloat, buttonHeight: CGFloat) -> UIBezierPath {
        
        let widthScale = buttonWidth / 44
        let heightScale = buttonHeight / 44
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 24.5 * widthScale, y: 10.5 * heightScale))
        path.addLine(to: CGPoint(x: 14.5 * widthScale, y: 10.5 * heightScale))
        path.addLine(to: CGPoint(x: 14.5 * widthScale, y: 34.5 * heightScale))
        path.addLine(to: CGPoint(x: 30.5 * widthScale, y: 34.5 * heightScale))
        path.addLine(to: CGPoint(x: 30.5 * widthScale, y: 16.5 * heightScale))
        path.addLine(to: CGPoint(x: 24.5 * widthScale, y: 10.5 * heightScale))
        path.addLine(to: CGPoint(x: 24.5 * widthScale, y: 16.5 * heightScale))
        path.addLine(to: CGPoint(x: 30.5 * widthScale, y: 16.5 * heightScale))
        path.move(to: CGPoint(x: 17.5 * widthScale, y: 20.5 * heightScale))
        path.addLine(to: CGPoint(x: 27.5 * widthScale, y: 20.5 * heightScale))
        path.move(to: CGPoint(x: 17.5 * widthScale, y: 24.5 * heightScale))
        path.addLine(to: CGPoint(x: 25.5 * widthScale, y: 24.5 * heightScale))
        path.move(to: CGPoint(x: 17.5 * widthScale, y: 28.5 * heightScale))
        path.addLine(to: CGPoint(x: 27.5 * widthScale, y: 28.5 * heightScale))
        
        return path
    }

}
