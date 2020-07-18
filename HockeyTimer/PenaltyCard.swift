//
//  PenaltyCard.swift
//  HockeyTimer
//
//  Created by Steven Adons on 18/07/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import Foundation

struct PenaltyCard: Event {
    
    var type: CardType
    var player: String?
    var team: Team?
    
    var time: Date
    var inMinute: Int
    
    init(_ timer: AnnotatedCardTimer) {
        
        self.type = timer.card.type
        self.player = timer.player
        self.team = timer.team
        self.time = timer.time
        self.inMinute = timer.cardDrawnAtMinute
    }
}
