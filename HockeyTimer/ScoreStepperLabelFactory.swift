//
//  ScoreStepperLabelFactory.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class ScoreStepperLabelFactory {
    
    class func standardLabel(text: String, textColor: UIColor, fontStyle: UIFont.TextStyle, textAlignment: NSTextAlignment?, sizeToFit: Bool, adjustsFontSizeToFitWidth: Bool?) -> UILabel {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth {
            label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        }
        label.text = text
        let fontSize: CGFloat = UIDevice.whenDeviceIs(small: 28, normal: 36, big: 36)
        label.font = UIFont(name: FONTNAME.ThemeBold, size: fontSize)
        if let textAlignment = textAlignment {
            label.textAlignment = textAlignment
        }
        label.baselineAdjustment = .alignCenters
        label.textColor = textColor
        if sizeToFit {
            label.sizeToFit()
        }
        label.baselineAdjustment = .alignBaselines
        label.numberOfLines = 1
        return label
    }
    
    
    
}
