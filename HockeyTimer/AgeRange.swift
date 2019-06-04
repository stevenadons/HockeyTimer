//
//  AgeRange.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 6/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import Foundation

struct AgeRange {
    
    static func uString(for duration: Duration) -> String {
        
        var result = ""
        switch duration {
        case .Twenty:
            result = "U7 - U8"
        case .TwentyFive:
            result = "U9 - U10 - U11 - U12"
        case .Thirty:
            result = "U14 - Ladies - Gents"
        case .ThirtyFive:
            result = "U16 - U19"
        default:
            result = "ERROR"
        }
        return result
    }
    
    static func durationString(for duration: Duration) -> String {
        
        return "\(duration.rawValue)m"
    }
    
}
