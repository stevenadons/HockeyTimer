//
//  PlusMinus.swift
//  HockeyTimer
//
//  Created by Steven Adons on 9/09/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PlusMinus: UIButton {

    
    // MARK: - Properties
    
    private var shape: PlusMinusLayer!
    private var haptic: UISelectionFeedbackGenerator?
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        shape = PlusMinusLayer()
        layer.addSublayer(shape)
        
        prepareHaptic()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        if touches.count == 1, let touch = touches.first {
            if touch.tapCount == 1 {
                doHaptic()
                prepareHaptic()
            }
        }
        
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        shape.frame = bounds
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
