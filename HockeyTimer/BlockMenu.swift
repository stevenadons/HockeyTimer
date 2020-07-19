//
//  BlockMenu.swift
//  HockeyTimer
//
//  Created by Steven Adons on 19/07/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


class BlockMenu: UIView {
    
    
    // NOTE
    // How to use:
    // Initialize with BlockMenu.init(inView: superView) // f.i. with superView being VC.view
    // No need to add to a view
    // Remove with yourBlockMenu.removeFromSuperview()

    
    // MARK: - Properties
    
    private var tap: UITapGestureRecognizer!
    
    private var mainButton: BlockMenuMainButton!
    private var itemButtons: [BlockMenuItemButton] = []
    private var itemLabels: [UILabel] = []
    
    private var imageNames: [String]!
    private var itemTitles: [String] = []
    private var delegate: BlockMenuDelegate!
    
    private let itemButtonDiameter: CGFloat = 48
    private let mainButtonDiameter: CGFloat = 54
    static let standardMainButtonDiameter: CGFloat = 54
    private let mainButtonRightInset: CGFloat = 28
    private let mainButtonBottomInset: CGFloat = 26
    private let horGrid: CGFloat = 64
    private let vertPadding: CGFloat = 16
    private let itemTitleWidth: CGFloat = 58
    private let itemTitleHeight: CGFloat = 20
    private let itemToLabelPadding: CGFloat = 4
    
    private let mainButtonColor: UIColor = UIColor(named: ColorName.DarkBlue)!
    private let mainButtonContentColor: UIColor = .white
    private let mainButtonCloseColor: UIColor = UIColor(named: ColorName.PantoneRed)!
    private let itemButtonColor: UIColor = UIColor(named: ColorName.DarkBlue)!
    private let itemButtonContentColor: UIColor = .white
    
    
    // MARK: - Initializing
    
    convenience init(inView containingView: UIView, centerX: CGFloat, centerY: CGFloat, imageNames: [String], itemTitles: [String], delegate: BlockMenuDelegate) {
        
        self.init()
        
        self.frame = containingView.frame
        self.center = containingView.center
        self.backgroundColor = UIColor.clear
        self.imageNames = imageNames
        self.itemTitles = itemTitles
        self.delegate = delegate
        
        tap = UITapGestureRecognizer(target: self, action: #selector(close))
        addGestureRecognizer(tap)
        
        mainButton = BlockMenuMainButton(shapeColor: mainButtonContentColor, bgColor: mainButtonColor)
        mainButton.addTarget(self, action: #selector(mainButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        mainButton.frame = CGRect(x: 0, y: 0, width: mainButtonDiameter, height: mainButtonDiameter)
        let originX = centerX - mainButtonDiameter / 2.0
        let originY = centerY - mainButtonDiameter / 2.0
        mainButton.frame.origin = CGPoint(x: originX, y: originY)
        addSubview(mainButton)
        
        for index in 0 ..< imageNames.count {
            
            let imageName = imageNames[index]
            let itemButton = BlockMenuItemButton(shapeColor: itemButtonContentColor, bgColor: itemButtonColor, imageName: imageName)
            itemButton.tag = index
            itemButton.addTarget(self, action: #selector(itemButtonTapped(sender:forEvent:)), for: [.touchUpInside])
            itemButton.frame = CGRect(x: 0, y: 0, width: itemButtonDiameter, height: itemButtonDiameter)
            
            if imageNames.count == 1 {
                let originX = mainButton.frame.origin.x
                let originY = mainButton.frame.origin.y + (mainButtonDiameter - itemButtonDiameter) / 2 + vertPadding
                itemButton.frame.origin = CGPoint(x: originX, y: originY)
                
            } else {
                if imageNames.count.isMultiple(of: 2) {
                    let firstRightIndex = imageNames.count / 2
                    let firstRightIndexOriginX = mainButton.frame.origin.x + (mainButtonDiameter - itemButtonDiameter) / 2 + horGrid / 2
                    let firstRightIndexOriginY = mainButton.frame.origin.y + mainButtonDiameter + vertPadding
                    let originX = firstRightIndexOriginX + CGFloat(index - firstRightIndex) * horGrid
                    itemButton.frame.origin = CGPoint(x: originX, y: firstRightIndexOriginY)
                } else {
                    let midIndex = (imageNames.count - 1) / 2
                    let midIndexOriginX = mainButton.frame.origin.x + (mainButtonDiameter - itemButtonDiameter) / 2
                    let midIndexOriginY = mainButton.frame.origin.y + mainButtonDiameter + vertPadding
                    let originX = midIndexOriginX + CGFloat(index - midIndex) * horGrid
                    itemButton.frame.origin = CGPoint(x: originX, y: midIndexOriginY)
                }
            }
            itemButtons.append(itemButton)
            insertSubview(itemButton, belowSubview: mainButton)
            
            let label = UILabel()
            label.numberOfLines = 1
            label.text = index < itemTitles.count ? itemTitles[index] : ""
            label.textColor = UIColor(named: ColorName.DarkBlueText)!
            label.font = UIFont(name: FONTNAME.ThemeBold, size: 14)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            let labelX = itemButton.frame.origin.x - (itemTitleWidth - itemButton.frame.width) / 2.0
            let labelY = itemButton.frame.origin.y + itemButton.frame.height + itemToLabelPadding
            label.frame = CGRect(x: 0, y: 0, width: itemTitleWidth, height: itemTitleHeight)
            label.frame.origin = CGPoint(x: labelX, y: labelY)
            itemLabels.append(label)
            insertSubview(label, belowSubview: mainButton)
        }
        
        windUp()
        
        containingView.addSubview(self)
    }
    
    private func windUp() {
        
        mainButton.hideCloseImage()
        
        for index in 0 ..< itemButtons.count {
            
            let itemButton = itemButtons[index]
            if itemButtons.count == 1 {
                let translationX: CGFloat = 0.0
                let translationY: CGFloat = -vertPadding
                itemButton.transform = CGAffineTransform(translationX: translationX, y: translationY)
                
            } else {
                if itemButtons.count.isMultiple(of: 2) {
                    let firstRightIndex = itemButtons.count / 2
                    let translationX: CGFloat = -horGrid / 2 - CGFloat(index - firstRightIndex) * horGrid
                    let translationY: CGFloat = -mainButtonDiameter - vertPadding
                    itemButton.transform = CGAffineTransform(translationX: translationX, y: translationY)
                } else {
                    let midIndex = (imageNames.count - 1) / 2
                    let translationX: CGFloat = -CGFloat(index - midIndex) * horGrid
                    let translationY: CGFloat = -mainButtonDiameter - vertPadding
                    itemButton.transform = CGAffineTransform(translationX: translationX, y: translationY)
                }
            }
            itemLabels[index].alpha = 0.0
        }
    }
    
    @objc private func mainButtonTapped(sender: BlockMenuMainButton, forEvent event: UIEvent) {
        
        if mainButton.isShowingHideImage {
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
        
        NotificationCenter.default.post(name: .BlockMenuWillOpen, object: nil)
        
        mainButton.showCloseImage()
        mainButton.bgColor = mainButtonCloseColor
        
        for index in 0 ..< itemButtons.count {
            
            UIView.animate(withDuration: 0.2, delay: 0.05 * Double(index), usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [], animations: {
                self.itemButtons[index].transform = .identity
            }) { (finished) in
                self.itemLabels[index].alpha = finished ? 1.0 : 0.0
            }
        }
    }
    
    
    // MARK: - Public Methods

    @objc func close() {
        
        mainButton.hideCloseImage()
        mainButton.bgColor = mainButtonColor

        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.0, options: [], animations: {
            
            self.backgroundColor = UIColor.clear
            
            for index in 0 ..< self.itemButtons.count {
                
                let itemButton = self.itemButtons[index]
                if self.itemButtons.count == 1 {
                    let translationX: CGFloat = 0.0
                    let translationY: CGFloat = -self.vertPadding
                    itemButton.transform = CGAffineTransform(translationX: translationX, y: translationY)
                    
                } else {
                    if self.itemButtons.count.isMultiple(of: 2) {
                        let firstRightIndex = self.itemButtons.count / 2
                        let translationX: CGFloat = -self.horGrid / 2 - CGFloat(index - firstRightIndex) * self.horGrid
                        let translationY: CGFloat = -self.mainButtonDiameter - self.vertPadding
                        itemButton.transform = CGAffineTransform(translationX: translationX, y: translationY)
                    } else {
                        let midIndex = (self.itemButtons.count - 1) / 2
                        let translationX: CGFloat = -CGFloat(index - midIndex) * self.horGrid
                        let translationY: CGFloat = -self.mainButtonDiameter - self.vertPadding
                        itemButton.transform = CGAffineTransform(translationX: translationX, y: translationY)
                    }
                }
                self.itemLabels[index].alpha = 0.0
            }
        }, completion: { (finished) in
            NotificationCenter.default.post(name: .BlockMenuDidClose, object: nil)
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
