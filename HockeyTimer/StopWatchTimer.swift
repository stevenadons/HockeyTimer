//
//  StopWatchTimer.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 21/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


protocol StopWatchTimerDelegate: AnyObject {
    
    func handleTickCountDown()
    func handleTickCountUp()
    func handleTimerReset()
    func handleReachedZero()
}


class StopWatchTimer {
    
    
    // MARK: - Properties
    
    var state: StopWatchTimerState = .WaitingToStart {
        didSet {
            switch state {
            case .WaitingToStart:
                timerIsRunning = false
                resetTime()
                totalSecondsOverdue = 0
                totalSecondsCountingUp = 0
            case .RunningCountDown:
                timerIsRunning = true
            case .Paused:
                timerIsRunning = false
            case .Overdue:
                timerIsRunning = true
                totalSecondsToGo = 0
            case .RunningCountUp:
                timerIsRunning = true
                totalSecondsOverdue = 0
            case .Ended:
                timerIsRunning = false
            }
        }
    }
    var progress: CGFloat {
        switch state {
        case .WaitingToStart:
            return 0
        case .RunningCountDown, .Paused:
            return CGFloat(totalSecondsInPeriod - totalSecondsToGo) / CGFloat(totalSecondsInPeriod)
        case .RunningCountUp, .Overdue, .Ended:
            return 1
        }
    }
    var progressCappedAt1: CGFloat {
        return min(progress, 1)
    }
    
    var timer: Timer?
    private var delegate: StopWatchTimerDelegate!
    private var game: HockeyGame! {
        didSet {
            print("SWT - didSet game - willl call resetTime")
            resetTime()
        }
    }

    private var totalSecondsInPeriod: Int = Int(HockeyGame.standardTotalMinutes * 60)
    var totalSecondsToGo: Int = Int(HockeyGame.standardTotalMinutes * 60)
    var totalSecondsOverdue: Int = 0
    var totalSecondsCountingUp: Int = 0
    
    
    
    // MARK: - Initializing
    
    required init(delegate: StopWatchTimerDelegate, game: HockeyGame) {
        
        self.delegate = delegate
        self.game = game
    }
    
    
    
    // MARK: - Public Methods
    
    func set(game: HockeyGame) {
        
        print("SWT - set(game) with game \(game.periods) - will call resetTime")
        self.game = game
        resetTime()
    }
    
    func startCountDown() {
        
        guard state == .WaitingToStart || state == .Paused else { return }
        timer?.invalidate()
        state = .RunningCountDown
        startTimer(with: #selector(tickCountDown))
    }
    
    func startOverdueCountUp() {
        
        guard state == .RunningCountDown else { return }
        timer?.invalidate()
        state = .Overdue
        startTimer(with: #selector(tickCountUp))
    }
    
    func startCountUp() {
        
        guard state == .Overdue else { return }
        timer?.invalidate()
        state = .RunningCountUp
        startTimer(with: #selector(tickCountUp))
    }
    
    func pause() {
        
        guard state == .RunningCountDown else { return }
        timer?.invalidate()
        state = .Paused
    }
    
    func stopCountDown() {
        
        guard state == .RunningCountDown else { return }
        timer?.invalidate()
    }
    
    func stopCountUp() {
        
        guard state == .Overdue || state == .RunningCountUp else { return }
        timer?.invalidate()
        
        if state == .Overdue {
            totalSecondsOverdue = 0
        } else if state == .RunningCountUp {
            totalSecondsCountingUp = 0
        }
        runningCountingUp = false
    }
    
    func reset(withGame game: HockeyGame) {
        
        timer?.invalidate()
        self.game = game
        delegate.handleTimerReset()
        state = .WaitingToStart
        print("SWTimer - game set with \(game.periods)")
    }
    
    
    
    // MARK: - Private Methods
    
    private func resetTime() {

        self.totalSecondsInPeriod = Int(Double(game.totalMinutes * 60) / Double(game.periods))
        self.totalSecondsToGo = Int(Double(game.totalMinutes * 60) / Double(game.periods))
    }

    @objc private func tickCountDown() {
        
        guard UIApplication.shared.applicationState != .background else { return }
        
        if totalSecondsToGo >= 1 {
            // Count down
            totalSecondsToGo -= 1
            if totalSecondsToGo < 1 {
                // Reached zero
                stopCountDown()
                startOverdueCountUp()
                delegate.handleReachedZero()
            } else {
                // Keep on counting down
                delegate.handleTickCountDown()
            }
        } else {
            // Overdue - count up
            totalSecondsOverdue += 1
            delegate.handleTickCountDown()
        }
    }
    
    @objc private func tickCountUp() {
        
        guard UIApplication.shared.applicationState != .background else { return }

        if state == .Overdue {
            totalSecondsOverdue += 1
        } else if state == .RunningCountUp {
            totalSecondsCountingUp += 1
        }
        delegate.handleTickCountUp()
    }
    
    private func startTimer(with selector: Selector) {
        
        // Create the timer without scheduling it directly, then add it by hand to a runloop
        // Timers won’t fire when the user is interacting with your app
        // https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer
        timer = Timer(timeInterval: 1.0, target: self, selector: selector, userInfo: nil, repeats: true)
        timer!.tolerance = 0.1
        RunLoop.current.add(timer!, forMode: .common)
    }
}


