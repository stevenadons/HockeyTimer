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
    var currentMinute: Int {
        let minutesPreviousPeriods = (totalMinutes / periods) * (currentPeriod - 1.0)
        return Int(minutesPreviousPeriods) + currentMinuteInPeriod
    }
    private var currentMinuteInPeriod: Int = 1

    private(set) var lastScored: Team?
    private(set) var startTime: Date?
    private(set) var endTime: Date?
    private(set) var events: [GameEvent] = [] 
    
    var currentPeriod: Double = 1.0
    var periods: Double = 2.0
    var totalMinutes: Double = HockeyGame.standardTotalMinutes 
    
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
            return "P\(Int(currentPeriod))"
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
        logGoal(team: .Home, homeScore: homeScore, awayScore: awayScore, inMinute: currentMinute)
    }
    
    func awayScored() {
        
        awayScore += 1
        lastScored = .Away
        logGoal(team: .Away, homeScore: homeScore, awayScore: awayScore, inMinute: currentMinute)
    }
    
    func homeScoreMinusOne() {
        
        if homeScore >= 1 {
            homeScore -= 1
        }
        print("About to clear last home goal")
        clearLastGoal(.Home)
    }
    
    func awayScoreMinusOne() {
        
        if awayScore >= 1 {
            awayScore -= 1
        }
        clearLastGoal(.Away)
    }
    
    func currentTimerProgressedToMinute(_ currentMinute: Int) {
        
        self.currentMinuteInPeriod = currentMinute
    }
    
    func logStartTime() {
        
        startTime = Date()
    }
    
    func logEndTime() {
        
        endTime = Date()
    }
    
    func logPenaltyCardsFrom(_ timers: [AnnotatedCardTimer]) {
        
        clearAllPenaltyCards()
        for timer in timers {
            let event = GameEvent.createFrom(timer)
            events.append(event)
        }
    }
    
    func logGoal(team: Team, homeScore: Int, awayScore: Int, inMinute: Int) {
        
        let type = GameEventType.goal(team: team, homeScore: homeScore, awayScore: awayScore, inMinute: inMinute)
        let event = GameEvent(type: type)
        events.append(event)
    }
    
    func clearLastGoal(_ team: Team) {
        
        let filteredEvents = events.filter {
            if case let GameEventType.goal(teamScore, _, _, _) = $0.type {
                return teamScore == team
            } else {
                return false
            }
        }
        let sortedEvents = filteredEvents.sorted {
            if team == .Home {
                if case let GameEventType.goal(_, firstHomeScore, _, _) = $0.type {
                    if case let GameEventType.goal(_, secondHomeScore, _, _) = $1.type {
                        return firstHomeScore < secondHomeScore
                    } else {
                        fatalError("Error in sorting events")
                    }
                } else {
                    fatalError("Error in sorting events")
                }
            } else {
                if case let GameEventType.goal(_, _, firstAwayScore, _) = $0.type {
                    if case let GameEventType.goal(_, _, secondAwayScore, _) = $1.type {
                        return firstAwayScore < secondAwayScore
                    } else {
                        fatalError("Error in sorting events")
                    }
                } else {
                    fatalError("Error in sorting events")
                }
            }
        }
        
        guard !sortedEvents.isEmpty else { return }
        let removingGoal = sortedEvents.last!
        
        if let index = events.firstIndex(of: removingGoal) {
            events.remove(at: index)
        }
        
    }
    
    func clearAllPenaltyCards() {
        
        let filteredEvents = events.filter {
            if case GameEventType.penaltyCard(_, _, _, _) = $0.type {
                return false
            } else {
                return true
            }
        }
        events = filteredEvents
    }
}
