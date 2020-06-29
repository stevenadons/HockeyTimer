//
//  GameEventType.swift
//  HockeyTimer
//
//  Created by Steven Adons on 29/06/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import Foundation


enum GameEventType: Equatable {
    
    case penaltyCard(type: CardType, inMinute: Int, player: String?, team: Team?)
    case goal(team: Team, homeScore: Int, awayScore: Int, inMinute: Int)
    case start(time: Date)
    case end(time: Date)
}

