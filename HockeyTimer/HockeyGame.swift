//
//  HockeyGame.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 21/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import Foundation


enum Player {
    
    case Home
    case Away
}


class HockeyGame {
    
    
    // MARK: - Helpers
    
    enum Status {
        
        case WaitingToStart
        case Running
        case Pausing
        case HalfTime
        case Finished
    }
    
    
    // MARK: - Properties
    
    private(set) var homeScore: Int = 0
    private(set) var awayScore: Int = 0
    var half: HALF = .First
    var status: Status = .WaitingToStart
    var duration: MINUTESINHALF = .Twenty
    private(set) var lastScored: Player?
    
    
    
    // MARK: - Initializing

    convenience init(duration: MINUTESINHALF) {
        
        self.init()
        self.duration = duration
    }
    
    
    // MARK: - User Methods

    func homeScored() {
        
        homeScore += 1
        lastScored = .Home
    }
    
    func awayScored() {
        
        awayScore += 1
        lastScored = .Away
    }
    
    func homeScoreMinusOne() {
        
        if homeScore >= 1 {
            homeScore -= 1
        }
    }
    
    func awayScoreMinusOne() {
        
        if awayScore >= 1 {
            awayScore -= 1
        }
    }
}
