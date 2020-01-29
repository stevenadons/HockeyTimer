//
//  Double.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import Foundation

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
}
