//
//  HockeyGame.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 21/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import Foundation


class HockeyGame {
    
    // MARK: - Properties
    
    private(set) var homeScore: Int = 0
    private(set) var awayScore: Int = 0

    var status: HockeyGameStatus = .WaitingToStart {
        didSet {
            NotificationCenter.default.post(name: .GameStatusChanged, object: nil)
        }
    }

    private(set) var lastScored: Player?
    
    var currentPeriod: Double = 1.0
    var periods: Double = 2.0
    var totalMinutes: Double = HockeyGame.standardTotalMinutes {
        didSet {
            runningMinutes = totalMinutes
        }
    }
    
    static let standardTotalMinutes: Double = 70.0
    static let standardPeriods: Double = 2.0
    
    
    // MARK: - Calculated Properties
    
    var periodString: String {
        switch periods {
        case 2:
            switch currentPeriod {
            case 1:
                return LS_FIRSTHALFLABEL
            case 2:
                return LS_SECONDHALFLABEL
            default:
                fatalError("Trying to get message for period > number of periods")
            }
        case 4:
            switch currentPeriod {
            case 1:
                return LS_FIRSTQUARTERLABEL
            case 2:
                return LS_SECONDQUARTERLABEL
            case 3:
                return LS_THIRDQUARTERLABEL
            case 4:
                return LS_FOURTHQUARTERLABEL
            default:
                fatalError("Trying to get message for period > number of periods")
            }
        default:
            return "P\(currentPeriod)"
        }
        return ""
    }
    
    var endOfPeriodMessage: String {
        if status == .Finished && (currentPeriod == periods) {
            return LS_FULLTIME
            
        } else if status == .EndOfPeriod {
            if currentPeriod * 2 == periods {
                return LS_HALFTIME
                
            } else if periods == 4 {
                if currentPeriod == 1 {
                    return LS_ENDOFFIRSTQUARTER
                } else if currentPeriod == 3 {
                    return LS_ENDOFTHIRDQUARTER
                }
            } else {
                return LS_ENDOFPERIOD
            }
        }
        return ""
    }
    
    var readyForNextPeriodMessage: String {
        guard currentPeriod <= periods else {
            return ""
        }
        switch periods {
        case 2:
            switch currentPeriod {
            case 1:
                return LS_NEWGAME
            case 2:
                return LS_READYFORH2
            default:
                fatalError("Trying to get message for period > number of periods")
            }
        case 4:
            switch currentPeriod {
            case 1:
                return LS_NEWGAME
            case 2:
                return LS_READYFORQ2
            case 3:
                return LS_READYFORQ3
            case 4:
                return LS_READYFORQ4
            default:
                fatalError("Trying to get message for period > number of periods")
            }
        default:
            if currentPeriod == 1 {
                return LS_NEWGAME
            } else {
                return LS_READYFORP + String(currentPeriod)
            }
        }
        return ""
    }
    
    
    
    // MARK: - Initializing

    convenience init(minutes: Double, periods: Double) {
        
        self.init()
        self.totalMinutes = minutes
        self.periods = periods
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
