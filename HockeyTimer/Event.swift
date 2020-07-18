//
//  Event.swift
//  HockeyTimer
//
//  Created by Steven Adons on 18/07/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import Foundation

protocol Event {
    
    var time: Date { get }
    var inMinute: Int { get set }
}
