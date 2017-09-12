//
//  ScoreStepperLabelFactory.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class ScoreStepperLabelFactory {
    
    class func standardLabel(text: String, textColor: UIColor, fontStyle: UIFontTextStyle, textAlignment: NSTextAlignment?, sizeToFit: Bool, adjustsFontSizeToFitWidth: Bool?) -> UILabel {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth {
            label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        }
        label.text = text
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 36)
        if let textAlignment = textAlignment {
            label.textAlignment = textAlignment
        }
        label.textColor = textColor
        if sizeToFit {
            label.sizeToFit()
        }
        label.baselineAdjustment = .alignBaselines
        label.numberOfLines = 1
        return label
    }
    
    
    
}
