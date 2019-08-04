//
//  HockeyGameStatus.swift
//  HockeyTimer
//
//  Created by Steven Adons on 01/08/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import Foundation

enum HockeyGameStatus: String {
    
    case WaitingToStart = "WaitingToStart"
    case Running = "Running"
    case Pausing = "Pausing"
    case HalfTime = "HalfTime"
    case EndOfQuarter1 = "EndOfQuarter1"
    case EndOfQuarter2 = "EndOfQuarter2"
    case EndOfQuarter3 = "EndOfQuarter3"
    case Finished = "Finished"
}


