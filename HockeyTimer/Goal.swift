//
//  Goal.swift
//  HockeyTimer
//
//  Created by Steven Adons on 18/07/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import Foundation

struct Goal: Event, Equatable {
    
    var team: Team
    
    var time: Date
    var inMinute: Int
}
