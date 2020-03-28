//
//  PanArrowLabelFactory.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PanArrowLabelFactory {
    
    class func standardLabel(text: String, textColor: UIColor, fontStyle: UIFont.TextStyle, textAlignment: NSTextAlignment?, sizeToFit: Bool, adjustsFontSizeToFitWidth: Bool?) -> UILabel {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth {
            label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        }
        label.text = text
        label.font = UIFont(name: FONTNAME.LessImportantNumbers, size: 14) 
        if let textAlignment = textAlignment {
            label.textAlignment = textAlignment
        }
        label.textColor = textColor
        if sizeToFit {
            label.sizeToFit()
        }
        label.isUserInteractionEnabled = true
        return label
    }
    
    
    
}
