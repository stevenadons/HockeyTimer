//
//  XButton.swift
//  CryptoWatchdog
//
//  Created by Steven Adons on 07/01/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class XButton: UIButton {

    
    // MARK: - Properties
    
    private var icon: XButtonLayer!
    
    private var bgColor: UIColor!
    private var color: UIColor!
    
    private var haptic: UISelectionFeedbackGenerator?
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 67, height: 67)
    }
    
    
    // MARK: - Initializing and layout
    
    convenience init(color: UIColor, bgColor: UIColor? = nil) {
        
        self.init()
        
        self.color = color
        self.bgColor = bgColor ?? UIColor.clear
        
        setup()
    }
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = false
        
        backgroundColor = self.bgColor
        addIcon()
        
        addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    private func addIcon() {
        
        icon = XButtonLayer(lineColor: color, lineWidth: 2.0)
        layer.addSublayer(icon)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        icon.frame = bounds
        layer.cornerRadius = bounds.width / 2
    }
    
    
    // MARK: - Public Methods
    
    
    
    
    // MARK: - Private methods
    
    @objc private func tap() {
        
        prepareHaptic()
        doHaptic()
    }
    
    
    // MARK: - Haptic
    
    private func prepareHaptic() {
        
        if haptic == nil {
            haptic = UISelectionFeedbackGenerator()
            haptic!.prepare()
        }
    }
    
    private func doHaptic() {
        
        haptic?.selectionChanged()
        haptic = nil
    }

}
