//
//  Double.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

extension Double {
    
    var isInteger: Bool {
        return (floor(self) == self)
    }
    
    var maxOneDecimal: Double {
        return isInteger ? self : (self * 10).rounded() / 10
    }
    
    var stringWithMaxOneDecimal: String {
        
        if isInteger {
            let int = Int(self)
            return "\(int)"
        } else {
            return "\(self)"
        }
    }
    
    
    static func maxOneDecimalDividing(_ upper: Double, by lower: Double) -> Double {
        
        let fullCalculated = upper / lower
        return fullCalculated.maxOneDecimal
    }
    
    func createFormattedString(size pointSize: CGFloat, decimalSize: CGFloat) -> NSMutableAttributedString {
        
        let digitAndDecimals: Int = isInteger ? 0 : 2
        let rangeBeforeDigit = NSRange(location: 0, length: stringWithMaxOneDecimal.count - digitAndDecimals)
        let rangeDigitAndDecimals = NSRange(location: stringWithMaxOneDecimal.count - digitAndDecimals, length: digitAndDecimals)
        
        let attributedString = NSMutableAttributedString(string: stringWithMaxOneDecimal)
        attributedString.addAttribute(.font, value: UIFont(name: FONTNAME.Numbers, size: pointSize) as Any, range: rangeBeforeDigit)
        attributedString.addAttribute(.font, value: UIFont(name: FONTNAME.Numbers, size: decimalSize) as Any, range: rangeDigitAndDecimals)
        
        return attributedString
    }
}
