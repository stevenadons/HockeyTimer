//
//  GameEvent.swift
//  HockeyTimer
//
//  Created by Steven Adons on 29/06/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import Foundation


class GameEvent {
    
    
    // MARK: - Properties
    
    var type: GameEventType
    var inMinute: Int? {
        switch type {
        case let .penaltyCard(_, inMinute, _, _):
            return inMinute
        case let .goal(_, _, _, inMinute):
            return inMinute
        default:
            return nil
        }
    }
    
    // MARK: - Init
    
    init(type: GameEventType) {
        
        self.type = type
    }

    
    
    // MARK: - Public Methods
    
    static func createFrom(_ timer: AnnotatedCardTimer) -> GameEvent {
        
        let type = GameEventType.penaltyCard(type: timer.card.type, inMinute: timer.cardDrawnAtMinute, player: timer.player, team: timer.team)
        return GameEvent(type: type)
    }

}

extension GameEvent: Equatable {

    static func == (lhs: GameEvent, rhs: GameEvent) -> Bool {

        return lhs.type == rhs.type
    }

}
