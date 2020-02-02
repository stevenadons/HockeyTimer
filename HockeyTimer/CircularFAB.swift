//
//  CircularFAB.swift
//  CircularFAB
//
//  Created by Steven Adons on 01/02/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


protocol CircularFABDelegate {
    
    func itemButtonTapped(buttonNumber: Int)
}


class CircularFAB: UIView {
    
    
    // NOTE
    // How to use:
    // Initialize with CircularFAB.init(inView: superView) // f.i. with superView being VC.view
    // No need to add to a view
    // Remove with yourCircularFAB.removeFromSuperview()

    
    // MARK: - Properties
    
    private var tap: UITapGestureRecognizer!
    
    private var menuButton: CircularFABButton!
    private var itemButtons: [CircularFABItemButton] = []
    private var circle: UIView!
    
    private var imageNames: [String]!
    private var delegate: CircularFABDelegate!
    
    private let itemButtonDiameter: CGFloat = 48
    private let menuButtonDiameter: CGFloat = 54
    private let menuButtonRightInset: CGFloat = 28
    private let menuButtonBottomInset: CGFloat = 26
    private let radius: CGFloat = 85
    
    private let circleColor: UIColor = .white
    private let circleBorderColor: UIColor = .clear
    private let menuButtonColor: UIColor = UIColor(named: "DarkBlue")!
    private let menuButtonContentColor: UIColor = .white
    private let menuButtonCloseColor: UIColor = UIColor(named: "PantoneRed")!
    private let itemButtonColor: UIColor = UIColor(named: "DarkBlue")!
    private let itemButtonContentColor: UIColor = .white
    
    
    // MARK: - Initializing
    
    convenience init(inView containingView: UIView, imageNames: [String]!, delegate: CircularFABDelegate) {
        
        self.init()
        
        self.frame = containingView.frame
        self.center = containingView.center
        self.backgroundColor = UIColor.clear
        self.imageNames = imageNames
        self.delegate = delegate
        
        tap = UITapGestureRecognizer(target: self, action: #selector(close))
        addGestureRecognizer(tap)
        
        menuButton = CircularFABButton(shapeColor: menuButtonContentColor, bgColor: menuButtonColor)
        menuButton.addTarget(self, action: #selector(menuButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        menuButton.frame = CGRect(x: 0, y: 0, width: menuButtonDiameter, height: menuButtonDiameter)
        let originX = bounds.width - menuButtonRightInset - menuButtonDiameter
        let originY = bounds.height - menuButtonBottomInset - menuButtonDiameter
        menuButton.frame.origin = CGPoint(x: originX, y: originY)
        addSubview(menuButton)
        
        circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = circleColor
        circle.frame = menuButton.frame
        circle.layer.cornerRadius = min(circle.bounds.width, circle.bounds.height) / 2
        circle.layer.borderColor = circleBorderColor.cgColor
        circle.layer.borderWidth = 0.5
        insertSubview(circle, belowSubview: menuButton)
        
        for index in 0 ..< imageNames.count {
            
            let imageName = imageNames[index]
            let itemButton = CircularFABItemButton(shapeColor: itemButtonContentColor, bgColor: itemButtonColor, imageName: imageName)
            itemButton.tag = index
            itemButton.addTarget(self, action: #selector(itemButtonTapped(sender:forEvent:)), for: [.touchUpInside])
            itemButton.frame = CGRect(x: 0, y: 0, width: itemButtonDiameter, height: itemButtonDiameter)
            
            if imageNames.count == 1 {
                let originX = menuButton.frame.origin.x
                let originY = menuButton.frame.origin.y + (menuButtonDiameter - itemButtonDiameter) / 2 - radius
                itemButton.frame.origin = CGPoint(x: originX, y: originY)
                
            } else {
                let baseAngle: CGFloat = (.pi / 2) / CGFloat(imageNames.count - 1)
                let originX = menuButton.frame.origin.x + (menuButtonDiameter - itemButtonDiameter) / 2 - cos(baseAngle * CGFloat(index)) * radius
                let originY = menuButton.frame.origin.y + (menuButtonDiameter - itemButtonDiameter) / 2 - sin(baseAngle * CGFloat(index)) * radius
                itemButton.frame.origin = CGPoint(x: originX, y: originY)
            }
            itemButtons.append(itemButton)
            insertSubview(itemButton, belowSubview: menuButton)
        }
        
        windUp()
        
        containingView.addSubview(self)
    }
    
    private func windUp() {
        
        menuButton.hideCloseImage()
        
        for index in 0 ..< itemButtons.count {
            
            let itemButton = itemButtons[index]
            if itemButtons.count == 1 {
                let translationX: CGFloat = 0.0
                let translationY: CGFloat = radius
                itemButton.transform = CGAffineTransform(translationX: translationX, y: translationY)
                
            } else {
                let baseAngle: CGFloat = (.pi / 2) / CGFloat(itemButtons.count - 1)
                let translationX: CGFloat = cos(baseAngle * CGFloat(index)) * radius
                let translationY: CGFloat = sin(baseAngle * CGFloat(index)) * radius
                itemButton.transform = CGAffineTransform(translationX: translationX, y: translationY)
            }
        }
    }
    
    @objc private func menuButtonTapped(sender: CircularFABButton, forEvent event: UIEvent) {
        
        if menuButton.isShowingHideImage {
            close()
        } else {
            open()
        }
    }
    
    @objc private func itemButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        
        close()
        delegate.itemButtonTapped(buttonNumber: sender.tag)
    }
    
    private func open() {
        
        NotificationCenter.default.post(name: .CircularFABWillOpen, object: nil)
        
        menuButton.showCloseImage()
        menuButton.bgColor = menuButtonCloseColor
        
        let itemsOffset: CGFloat = itemButtonDiameter * 0.45
        let circleRadius: CGFloat = radius + itemButtonDiameter / 2 + itemsOffset
        let menuButtonRadius: CGFloat = menuButtonDiameter / 2
        let scale = circleRadius / menuButtonRadius
        UIView.animate(withDuration: 0.2, animations: {
            self.circle.transform = CGAffineTransform(scaleX: scale, y: scale)
        })
        
        for index in 0 ..< itemButtons.count {
            
            UIView.animate(withDuration: 0.3, delay: 0.05 * Double(index), usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [], animations: {
                self.itemButtons[index].transform = .identity
            })
        }
    }
    
    @objc private func close() {
        
        menuButton.hideCloseImage()
        menuButton.bgColor = menuButtonColor

        UIView.animate(withDuration: 0.2, animations: {
            self.circle.transform = .identity
        })
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.0, options: [], animations: {
            
            self.backgroundColor = UIColor.clear
            
            for index in 0 ..< self.itemButtons.count {
                
                let itemButton = self.itemButtons[index]
                if self.itemButtons.count == 1 {
                    let translationX: CGFloat = 0.0
                    let translationY: CGFloat = self.radius
                    itemButton.transform = CGAffineTransform(translationX: translationX, y: translationY)
                    
                } else {
                    let baseAngle: CGFloat = (.pi / 2) / CGFloat(self.imageNames.count - 1)
                    let translationX: CGFloat = cos(baseAngle * CGFloat(index)) * self.radius
                    let translationY: CGFloat = sin(baseAngle * CGFloat(index)) * self.radius
                    itemButton.transform = CGAffineTransform(translationX: translationX, y: translationY)
                }
            }
        }, completion: { (finished) in
            NotificationCenter.default.post(name: .CircularFABDidClose, object: nil)
        })
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
