//
//  StopWatchTimerState.swift
//  HockeyTimer
//
//  Created by Steven Adons on 01/08/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import Foundation

enum StopWatchTimerState {
    
    case WaitingToStart
    case RunningCountDown
    case RunningCountUp
    case Paused
    case Overdue
    case Ended
}
