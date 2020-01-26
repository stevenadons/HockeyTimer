//
//  UserDefaultsKey.swift
//  HockeyTimer
//
//  Created by Steven Adons on 11/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import Foundation

enum UserDefaultsKey {
    
    static let Minutes = "Minutes"
    static let Periods = "Periods"
    
    static let ShouldNotOnboard = "ShouldNotOnboard"
    static let TimerEndTimeWhenInBackground = "TimerEndTimeWhenInBackground"
    static let TimerStartTimeOverdue = "TimerStartTimeOverdue"
    static let TimerStartTimeCountingUp = "TimerStartTimeCountingUp"
    static let CardEndTimesWhenInBackground = "CardEndTimesWhenInBackground"
    static let PremiumMode = "PremiumMode"
    static let CountryIndex = "CountryIndex"
    static let AlwaysDarkMode = "AlwaysDarkMode"
    static let AlwaysLightMode = "AlwaysLightMode"
    static let DarkModeFollowsPhoneSettings = "DarkModeFollowsPhoneSettings"
}
