//
//  HockeyGame.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 21/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import Foundation


enum Player {
    
    case Home, Away
}

enum HalfGame {
    
    case First, Second
}

enum QuarterGame: Int {
    
    case First = 1
    case Second = 2
    case Third = 3
    case Fourth = 4
}


class HockeyGame {
    
    
    // MARK: - Properties
    
    private(set) var homeScore: Int = 0
    private(set) var awayScore: Int = 0
    private(set) var pausesOnQuarters: Bool = false
    var half: HalfGame = .First
    var quarter: QuarterGame = .First
    var status: HockeyGameStatus = .WaitingToStart
    var duration: Duration = .Twenty {
        didSet {
            runningDuration = duration
        }
    }
    private(set) var lastScored: Player?
    
    
    
    // MARK: - Initializing

    convenience init(duration: Duration, pausesOnQuarters: Bool) {
        
        self.init()
        self.duration = duration
        self.pausesOnQuarters = pausesOnQuarters
        runningDuration = duration
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
