//
//  PitchContainerView.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 5/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PitchContainerView: ContainerView {

    
    // Extends the touchable area of the containerview in order to let subviews (Pitch) receive touches
    // Swipe detection in score edit mode
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
            return nil
        }
        let touchRect = CGRect(x: 0, y: -distanceMoveUp, width: bounds.width, height: bounds.height + distanceMoveUp)
        if touchRect.contains(point) {
            for subview in self.subviews.reversed() {
                let convertedPoint = subview.convert(point, from: self)
                let hitTestView = subview.hitTest(convertedPoint, with: event)
                if hitTestView != nil {
                    return hitTestView
                }
            }
            return self
        }
        return nil
    }

}
