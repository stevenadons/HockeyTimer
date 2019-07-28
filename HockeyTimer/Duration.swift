//
//  Duration.swift
//  HockeyTimer
//
//  Created by Steven Adons on 02/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import Foundation


enum Duration: Int, CaseIterable {
    
    #warning("testing")
    case One = 1
    case Nine = 9
    case Ten = 10
    case Twelve = 12
    case Fifteen = 15
//    #warning("test")
    case Twenty = 20  // For testing purposes: 1
    case TwentyFive = 25
    case Thirty = 30
    case ThirtyFive = 35
    
    var abbreviation: String {
        return "\(rawValue)m"
    }
}

