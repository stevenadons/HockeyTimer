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
    case EndOfPeriod = "EndOfPeriod"
    case Finished = "Finished"
}


