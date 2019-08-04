//
//  StopWatch.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 22/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit
import AudioToolbox


protocol StopWatchTimerDelegate: class {
    
    func handleTickCountDown()
    func handleTickCountUp()
    func handleTimerReset()
    func handleReachedZero()
}


class StopWatch: UIControl {
    
    
    // MARK: - Properties
    
    var game: HockeyGame! {
        didSet {
            updateDurationLabel()
            resetTimeLabel(withColor: COLOR.White, alpha: 1)
        }
    }
    
    var message: String = LS_NEWGAME {
        didSet {
            messageLabel.text = message
            messageLabel.setNeedsDisplay()
        }
    }

    fileprivate var delegate: StopWatchDelegate!
    var timer: StopWatchTimer!
    fileprivate var icon: StopWatchControlIcon!
    fileprivate var timeLabel: StopWatchLabel!

    private var squareContainer: CALayer!
    private var progressZone: CAShapeLayer!
    private var core: CALayer!
    fileprivate var progressBarFirstHalf: CAShapeLayer!
    fileprivate var progressBarSecondHalf: CAShapeLayer!
    fileprivate var progressBarFirstQuarter: CAShapeLayer!
    fileprivate var progressBarSecondQuarter: CAShapeLayer!
    fileprivate var progressBarThirdQuarter: CAShapeLayer!
    fileprivate var progressBarFourthQuarter: CAShapeLayer!
    private var messageLabel: UILabel!
    fileprivate var periodLabel: UILabel!
    private var durationLabel: UILabel!
    
    fileprivate var haptic: UINotificationFeedbackGenerator?
    fileprivate var impactHaptic: UIImpactFeedbackGenerator?
    
    private let progressBarWidth: CGFloat = 18
    private let progressBarStrokeInsetRatio: CGFloat = 0.01
    
    private var squareSide: CGFloat {
        return min(self.bounds.width, self.bounds.height)
    }
    
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        game = HockeyGame(duration: .TwentyFive, pausesOnQuarters: false)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        game = HockeyGame(duration: .TwentyFive, pausesOnQuarters: false)
        setUp()
    }
    
    convenience init(delegate: StopWatchDelegate, game: HockeyGame) {
        
        self.init()
        self.delegate = delegate
        self.game = game
        timer.set(game: game)
        runningSecondsToGo = timer.totalSecondsToGo
        timeLabel.text = stopWatchLabelTimeString()
        updateDurationLabel()
        periodLabel.text = game.pausesOnQuarters ? "Q1" : LS_FIRSTHALFLABEL
        setNeedsLayout()
    }
    
    private func setUp() {
        
        backgroundColor = UIColor.clear
        
        squareContainer = CALayer()
        squareContainer.backgroundColor = UIColor.clear.cgColor
        squareContainer.shouldRasterize = true
        squareContainer.rasterizationScale = UIScreen.main.scale
        layer.addSublayer(squareContainer)
        
        progressZone = CAShapeLayer()
        progressZone.strokeColor = UIColor.clear.cgColor
        progressZone.fillColor = COLOR.DarkGray.cgColor
        squareContainer.addSublayer(progressZone)
        
        core = CALayer()
        core.backgroundColor = COLOR.VeryDarkBlue.cgColor
        squareContainer.addSublayer(core)
        
        progressBarFirstHalf = progressBarLayer(for: HalfGame.First)
        squareContainer.addSublayer(progressBarFirstHalf)
        progressBarSecondHalf = progressBarLayer(for: HalfGame.Second)
        squareContainer.addSublayer(progressBarSecondHalf)
        
        progressBarFirstQuarter = progressBarLayer(for: QuarterGame.First)
        squareContainer.addSublayer(progressBarFirstQuarter)
        progressBarSecondQuarter = progressBarLayer(for: QuarterGame.Second)
        squareContainer.addSublayer(progressBarSecondQuarter)
        progressBarThirdQuarter = progressBarLayer(for: QuarterGame.Third)
        squareContainer.addSublayer(progressBarThirdQuarter)
        progressBarFourthQuarter = progressBarLayer(for: QuarterGame.Fourth)
        squareContainer.addSublayer(progressBarFourthQuarter)
        
        icon = StopWatchControlIcon(icon: .PlayIcon)
        icon.color = COLOR.DarkBlue
        addSubview(icon)
        
        timer = StopWatchTimer(delegate: self, game: game)
        
        timeLabel = StopWatchLabel(text: stopWatchLabelTimeString())
        addSubview(timeLabel)
        
        durationLabel = StopWatchSmallLabel()
        addSubview(durationLabel)
        messageLabel = StopWatchSmallLabel()
        messageLabel.adjustsFontSizeToFitWidth = false
        messageLabel.numberOfLines = 0
        message = LS_NEWGAME
        messageLabel.font = UIFont(name: FONTNAME.ThemeBold, size: durationLabel.font.pointSize)
        addSubview(messageLabel)
        periodLabel = StopWatchSmallLabel()
        periodLabel.font = UIFont(name: FONTNAME.ThemeBold, size: durationLabel.font.pointSize)
        addSubview(periodLabel)
        
        for subview in subviews {
            bringSubviewToFront(subview)
        }
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        squareContainer.frame = bounds.insetBy(dx: (bounds.width - squareSide) / 2, dy: (bounds.height - squareSide) / 2)
        progressZone.frame = squareContainer.bounds
        progressZone.path = UIBezierPath(ovalIn: progressZone.bounds).cgPath
        core.frame = squareContainer.bounds.insetBy(dx: progressBarWidth, dy: progressBarWidth)
        core.cornerRadius = core.bounds.width / 2
        updateProgressBars()
        icon.frame = bounds.insetBy(dx: (130 * bounds.width / 230) / 2, dy: (130 * bounds.height / 230) / 2)
        timeLabel.frame = bounds.insetBy(dx: bounds.width * 0.15, dy: bounds.height * 0.35)
        NSLayoutConstraint.activate([
            
            messageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80/230),
            messageLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 40/230),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 28),
            
            durationLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80/230),
            durationLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 20/230),
            durationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            
            periodLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80/230),
            periodLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 20/230),
            periodLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            periodLabel.topAnchor.constraint(equalTo: durationLabel.topAnchor, constant: durationLabel.font.pointSize),
            
            ])
        
        updateDurationLabel()
    }
    
    private func updateDurationLabel() {
        
        let numberOfPeriods = game.pausesOnQuarters ? "4" : "2"
        durationLabel.text = numberOfPeriods + "x\(game.duration.rawValue)min"
        durationLabel.setNeedsDisplay()
    }
    
    func updateAfterRestoringFromBackground() {
        
        print("SW - updateAfterRestoringFromBackground")
        if shouldRestoreFromBackground {
            if runningSecondsToGo > 0 {
                timer.totalSecondsToGo = runningSecondsToGo
                print("SW - case 1 - did set timer.totalSecondsToGo to \(timer.totalSecondsToGo)")
            } else if runningSecondsOverdue > 0 {
                print("SW - case 2 - this is the one")
                if timer.state != .Overdue {
                    // Timer has gone overdue when app inactive
                    timer.state = .Overdue
                    timer.stopCountDown()
                    print("SW - case 2a - calling timer.stopCountDown")
                    timer.totalSecondsOverdue = runningSecondsOverdue
                    timer.totalSecondsCountingUp = runningSecondsCountingUp
                    print("SW - case 2a - did set timer.totalSecondsOverdue to \(timer.totalSecondsOverdue)")
                    print("SW - case 2a - did set timer.totalSecondsCountingUp to \(timer.totalSecondsCountingUp)")
                    timer.startOverdueCountUp()
                    print("SW - case 2a - calling timer.startOverdueCountUp")
                    handleReachedZero()
                } else {
                    timer.totalSecondsOverdue = runningSecondsOverdue
                    timer.totalSecondsCountingUp = runningSecondsCountingUp
                    print("SW - case 2b - did set timer.totalSecondsOverdue to \(timer.totalSecondsOverdue)")
                    print("SW - case 2b - did set timer.totalSecondsCountingUp to \(timer.totalSecondsCountingUp)")
                }
            } else if runningSecondsCountingUp > 0 {
                timer.totalSecondsCountingUp = runningSecondsCountingUp
                print("SW - case 3 - did set timer.totalSecondsCountingUp to \(timer.totalSecondsCountingUp)")
            }
            updateProgressBars()
            if game.pausesOnQuarters {
                periodLabel.text = "Q\(game.quarter.rawValue)"
            } else {
                periodLabel.text = (game.half == .First) ? LS_FIRSTHALFLABEL : LS_SECONDHALFLABEL
            }
            shouldRestoreFromBackground = false
        }
    }
    
    
    // MARK: - User methods
    
    func stopWatchLabelTimeString() -> String {
        
        var result: String = ""
        var total: Int
        switch timer.state {
        case .Overdue:
            total = timer.totalSecondsOverdue
        case .RunningCountUp:
            total = timer.totalSecondsCountingUp
        default:
            total = timer.totalSecondsToGo
        }
        if game.status == .Finished {
            total = 0
        }
        if minutes(totalSeconds: total) < 10 {
            result.append("0")
        }
        result.append("\(minutes(totalSeconds: total)):")
        if seconds(totalSeconds: total) < 10 {
            result.append("0")
        }
        result.append("\(seconds(totalSeconds: total))")
        return result
    }
    
    func reset(withGame game: HockeyGame) {
        
        self.game = game
        timer.reset(withGame: game) //
        message = LS_NEWGAME
        periodLabel.text = game.pausesOnQuarters ? "Q1" : LS_FIRSTHALFLABEL
        periodLabel.alpha = 1.0
        updateProgressBars()
        resetTimeLabel(withColor: COLOR.White, alpha: 1)
        setProgressBarsColor(to: COLOR.White)
        icon.icon = .PlayIcon
        setNeedsLayout()
    }
    
    func simplifyForOnboarding(bgColor: UIColor, iconColor: UIColor, timeColor: UIColor, progressZoneColor: UIColor) {
        
        let simpleGame = HockeyGame(duration: .Thirty, pausesOnQuarters: false)
        reset(withGame: simpleGame)
        messageLabel.alpha = 0.0
        periodLabel.alpha = 0.0
        durationLabel.alpha = 0.0
        isUserInteractionEnabled = false
        core.backgroundColor = bgColor.cgColor
        icon.color = iconColor
        timeLabel.textColor = timeColor
        timeLabel.setFont(font: UIFont(name: FONTNAME.ThemeBold, size: 44)!)
        progressZone.fillColor = progressZoneColor.cgColor
    }
    
    
    
    // MARK: - Private methods
    
    @objc fileprivate func updateProgressBars() {
        
        if game.pausesOnQuarters {
            updateProgressBarsQuarterGame()
        } else {
            updateProgressBarsHalfGame()
        }
    }
    
    private func updateProgressBarsHalfGame() {
        
        progressBarFirstHalf.removeFromSuperlayer()
        progressBarSecondHalf.removeFromSuperlayer()
        
        progressBarFirstHalf = progressBarLayer(for: HalfGame.First)
        progressBarFirstHalf.strokeEnd = (game.half == .Second) ? strokeEndPosition(progress: 1) : strokeEndPosition(progress: timer.progressCappedAt1)
        squareContainer.addSublayer(progressBarFirstHalf)
        
        progressBarSecondHalf = progressBarLayer(for: HalfGame.Second)
        progressBarSecondHalf.strokeEnd = (game.half == .First) ? strokeEndPosition(progress: 0) : strokeEndPosition(progress: timer.progressCappedAt1)
        squareContainer.addSublayer(progressBarSecondHalf)
    }
    
    private func updateProgressBarsQuarterGame() {
        
        [progressBarFirstQuarter, progressBarSecondQuarter, progressBarThirdQuarter, progressBarFourthQuarter].forEach {
            $0?.removeFromSuperlayer()
        }
        
        progressBarFirstQuarter = progressBarLayer(for: QuarterGame.First)
        switch game.quarter {
        case .First:
            progressBarFirstQuarter.strokeEnd = strokeEndPosition(progress: timer.progressCappedAt1)
        case .Second, .Third, .Fourth:
            progressBarFirstQuarter.strokeEnd = strokeEndPosition(progress: 1)
        }
        squareContainer.addSublayer(progressBarFirstQuarter)
        
        progressBarSecondQuarter = progressBarLayer(for: QuarterGame.Second)
        switch game.quarter {
        case .First:
            progressBarSecondQuarter.strokeEnd = strokeEndPosition(progress: 0)
        case .Second:
            progressBarSecondQuarter.strokeEnd = strokeEndPosition(progress: timer.progressCappedAt1)
        case .Third, .Fourth:
            progressBarSecondQuarter.strokeEnd = strokeEndPosition(progress: 1)
        }
        squareContainer.addSublayer(progressBarSecondQuarter)
        
        progressBarThirdQuarter = progressBarLayer(for: QuarterGame.Third)
        switch game.quarter {
        case .First, .Second:
            progressBarThirdQuarter.strokeEnd = strokeEndPosition(progress: 0)
        case .Third:
            progressBarThirdQuarter.strokeEnd = strokeEndPosition(progress: timer.progressCappedAt1)
        case .Fourth:
            progressBarThirdQuarter.strokeEnd = strokeEndPosition(progress: 1)
        }
        squareContainer.addSublayer(progressBarThirdQuarter)
        
        progressBarFourthQuarter = progressBarLayer(for: QuarterGame.Fourth)
        switch game.quarter {
        case .First, .Second, .Third:
            progressBarFourthQuarter.strokeEnd = strokeEndPosition(progress: 0)
        case .Fourth:
            progressBarFourthQuarter.strokeEnd = strokeEndPosition(progress: timer.progressCappedAt1)
        }
        squareContainer.addSublayer(progressBarFourthQuarter)
    }
    
    
    // MARK: - Progress Bar Methods
    
    private func progressBarLayer(for half: HalfGame) -> CAShapeLayer {
        
        let shape = progressBarLayer()
        shape.path = progressBarPath(for: half).cgPath
        return shape
    }
    
    private func progressBarLayer(for quarter: QuarterGame) -> CAShapeLayer {
        
        let shape = progressBarLayer()
        shape.path = progressBarPath(for: quarter).cgPath
        return shape
    }
    
    private func progressBarLayer() -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        
        shape.strokeColor = COLOR.White.cgColor
        shape.lineWidth = progressBarWidth
        shape.lineCap = CAShapeLayerLineCap.butt
        shape.lineJoin = CAShapeLayerLineJoin.miter
        shape.fillColor = UIColor.clear.cgColor
        shape.position = CGPoint.zero
        shape.strokeStart = progressBarStrokeInsetRatio
        shape.strokeEnd = progressBarStrokeInsetRatio
        shape.contentsScale = UIScreen.main.scale
        
        return shape
    }
    
    
    private func progressBarPath(for half: HalfGame) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        switch half {
        case .First:
            path.move(to: CGPoint(x: bounds.width / 2, y: progressBarWidth / 2))
            path.addArc(withCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: (squareSide / 2 - progressBarWidth / 2), startAngle: -.pi/2, endAngle: .pi/2, clockwise: true)
        case .Second:
            path.move(to: CGPoint(x: bounds.width / 2, y: bounds.height - progressBarWidth / 2))
            path.addArc(withCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: (squareSide / 2 - progressBarWidth / 2), startAngle: .pi/2, endAngle: -.pi/2, clockwise: true)
        }
        
        return path
    }
    
    private func progressBarPath(for quarter: QuarterGame) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        switch quarter {
        case .First:
            path.move(to: CGPoint(x: bounds.width / 2, y: progressBarWidth / 2))
            path.addArc(withCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: (squareSide / 2 - progressBarWidth / 2), startAngle: -.pi/2, endAngle: 0, clockwise: true)
        case .Second:
            path.move(to: CGPoint(x: bounds.width - progressBarWidth / 2, y: bounds.height / 2))
            path.addArc(withCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: (squareSide / 2 - progressBarWidth / 2), startAngle: 0, endAngle: .pi/2, clockwise: true)
        case .Third:
            path.move(to: CGPoint(x: bounds.width / 2, y: bounds.height - progressBarWidth / 2))
            path.addArc(withCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: (squareSide / 2 - progressBarWidth / 2), startAngle: .pi/2, endAngle: .pi, clockwise: true)
        case .Fourth:
            path.move(to: CGPoint(x: progressBarWidth / 2, y: bounds.height / 2))
            path.addArc(withCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: (squareSide / 2 - progressBarWidth / 2), startAngle: .pi, endAngle: -.pi/2, clockwise: true)
        }
        
        return path
    }
    
    private func strokeEndPosition(progress: CGFloat) -> CGFloat {
        
        let strokeField = 1.0 - progressBarStrokeInsetRatio * 2
        return progressBarStrokeInsetRatio + strokeField * progress
    }
    
    
    
    // MARK: - Helper methods

    private func seconds(totalSeconds: Int) -> Int {
        return totalSeconds % 60
    }
    
    private func minutes(totalSeconds: Int) -> Int {
        return totalSeconds / 60
    }
    
    
    
    // MARK: - Touch methods
    
    private func isInsideCore(event: UIEvent) -> Bool {
        
        if let point: CGPoint = event.allTouches?.first?.location(in: self.superview) {
            let distance: CGFloat = sqrt(CGFloat(powf((Float(self.center.x - point.x)), 2) + powf((Float(self.center.y - point.y)), 2)))
            if (distance < (squareSide / 2 - progressBarWidth)) {
                return true
            }
        }
        return false
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        super.beginTracking(touch, with: event)
        if let event = event {
            if isInsideCore(event: event) {
                return true
            }
        }
        return false
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        super.continueTracking(touch, with: event)
        if let event = event {
            if isInsideCore(event: event) {
                return true
            }
        }
        return false
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        super.endTracking(touch, with: event)
        if let event = event {
            if isInsideCore(event: event) {
                handleTap()
            }
        }
    }
    
    
    private func handleTap() {
        
        prepareImpactHapticIfNeeded()
        impactHaptic?.impactOccurred()
        
        switch icon.icon {
            
        case .PlayIcon:
            
            // Start Half or Resume after pausing
            timer.startCountDown()
            game.status = .Running
            JukeBox.instance.prepareSound(SOUND.BeepBeep)
            icon.change(to: .PauseIcon)
            message = ""
            delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: nil)

        case .PauseIcon:
            
            // Pause while counting down
            timer.pause()
            game.status = .Pausing
            icon.change(to: .PlayIcon)
            message = LS_GAMEPAUSED
            
        case .StopIcon:
            
            timer.stopCountUp()
            haptic = nil
            
            if game.status == .Running {
                // Game running in overtime
                if game.pausesOnQuarters {
                    switch game.quarter {
                    case .First:
                        endQ1RunningInOvertime()
                    case .Second:
                        endQ2RunningInOvertime()
                    case .Third:
                        endQ3RunningInOvertime()
                    case .Fourth:
                        endQ4RunningInOvertime()
                    }
                } else {
                    if game.half == .First {
                        endH1RunningInOvertime()
                    } else {
                        endH2RunningInOvertime()
                    }
                }
                delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: nil)

            } else if game.status == .HalfTime {
                setReadyForH2()
            } else if game.status == .EndOfQuarter1 {
                setReadyForQ2()
            } else if game.status == .EndOfQuarter2 {
                setReadyForQ3()
            } else if game.status == .EndOfQuarter3 {
                setReadyForQ4()
            } else if game.status == .Finished {
                
            }
            
            resetTimeLabel(withColor: COLOR.White, alpha: 1)
            JukeBox.instance.stopPlayingAll()
            JukeBox.instance.removeSound(SOUND.BeepBeep)
            
        case .NoIcon:
            delegate?.handleTappedForNewGame()
        }
    }
    
    private func endQ1RunningInOvertime() {
        
        game.status = .EndOfQuarter1
        timer.startCountUp()
        periodLabel.alpha = 0.0
        message = LS_ENDOFFIRSTQUARTER
    }
    
    private func endQ2RunningInOvertime() {
        
        game.status = .EndOfQuarter2
        timer.startCountUp()
        periodLabel.alpha = 0.0
        message = LS_HALFTIME
        scheduleRequestReview()
    }
    
    private func endQ3RunningInOvertime() {
        
        game.status = .EndOfQuarter3
        timer.startCountUp()
        periodLabel.alpha = 0.0
        message = LS_ENDOFTHIRDQUARTER
    }
    
    private func endQ4RunningInOvertime() {
        
        game.status = .Finished
        setProgressBarsColor(to: UIColor.clear)
        periodLabel.alpha = 0.0
        icon.change(to: .NoIcon)
        message = LS_FULLTIME
        scheduleRequestReview()
    }
    
    private func endH1RunningInOvertime() {
        
        game.status = .HalfTime
        timer.startCountUp()
        periodLabel.alpha = 0.0
        message = LS_HALFTIME
        scheduleRequestReview()
    }
    
    private func endH2RunningInOvertime() {
        
        game.status = .Finished
        setProgressBarsColor(to: UIColor.clear)
        periodLabel.alpha = 0.0
        icon.change(to: .NoIcon)
        message = LS_FULLTIME
        scheduleRequestReview()
    }
    
    private func setReadyForH2() {
        
        game.half = .Second
        periodLabel.text = LS_SECONDHALFLABEL
        timer.reset(withGame: game)
        setProgressBarsColor(to: COLOR.White)
        if durationLabel.alpha > 0 {
            periodLabel.alpha = 1.0
        }
        message = LS_READYFORH2
        delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: {
            self.icon.change(to: .PlayIcon)
        })
    }
    
    private func setReadyForQ2() {
        
        game.quarter = .Second
        periodLabel.text = "Q2"
        timer.reset(withGame: game)
        setProgressBarsColor(to: COLOR.White)
        if durationLabel.alpha > 0 {
            periodLabel.alpha = 1.0
        }
        message = LS_READYFORQ2
        delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: {
            self.icon.change(to: .PlayIcon)
        })
    }
    
    private func setReadyForQ3() {
        
        game.quarter = .Third
        periodLabel.text = "Q3"
        timer.reset(withGame: game)
        setProgressBarsColor(to: COLOR.White)
        if durationLabel.alpha > 0 {
            periodLabel.alpha = 1.0
        }
        message = LS_READYFORQ3
        delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: {
            self.icon.change(to: .PlayIcon)
        })
    }
    
    private func setReadyForQ4() {
        
        game.quarter = .Fourth
        periodLabel.text = "Q4"
        timer.reset(withGame: game)
        setProgressBarsColor(to: COLOR.White)
        if durationLabel.alpha > 0 {
            periodLabel.alpha = 1.0
        }
        message = LS_READYFORQ4
        delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: {
            self.icon.change(to: .PlayIcon)
        })
    }
    
    private func scheduleRequestReview() {
        
        let twoSecondsFromNow = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) { [weak self] in
            guard self != nil else { return }
            AppStoreReviewManager.requestReviewAtHurdle()
        }
    }
    
    fileprivate func resetTimeLabel(withColor color: UIColor, alpha: CGFloat) {
        timeLabel.textColor = color
        timeLabel.alpha = alpha
        timeLabel.text = stopWatchLabelTimeString()
        timeLabel.setNeedsDisplay()
    }
    
    fileprivate func setProgressBarsColor(to newColor: UIColor) {
        
        [progressBarFirstQuarter, progressBarSecondQuarter, progressBarThirdQuarter, progressBarFourthQuarter].forEach {
            $0?.strokeColor = newColor.cgColor
            $0?.setNeedsDisplay()
        }
    }
    
    private func syncTimerPosition() {
        
        runningSecondsToGo = timer.totalSecondsToGo
        runningSecondsOverdue = timer.totalSecondsOverdue
        runningSecondsCountingUp = timer.totalSecondsCountingUp
    }
    
    // MARK: - Haptic
    
    fileprivate func prepareHapticIfNeeded() {
        guard #available(iOS 10.0, *) else { return }
        if haptic == nil {
            haptic = UINotificationFeedbackGenerator()
            haptic!.prepare()
        }
    }
    
    fileprivate func prepareImpactHapticIfNeeded() {
        guard #available(iOS 10.0, *) else { return }
        if impactHaptic == nil {
            impactHaptic = UIImpactFeedbackGenerator(style: .medium)
            impactHaptic!.prepare()
        }
    }
}


extension StopWatch: StopWatchTimerDelegate {
    
    func handleTickCountDown() {
        
        runningCountingUp = false
        syncTimerPosition()
        timeLabel.text = stopWatchLabelTimeString()
        timeLabel.setNeedsDisplay()
        updateProgressBars()
    }
    
    func handleTickCountUp() {
        
        timeLabel.text = stopWatchLabelTimeString()
        timeLabel.setNeedsDisplay()
        if message == LS_OVERTIME {
            haptic?.notificationOccurred(.warning)
            haptic = nil
            syncTimerPosition()
            print("StopWatch - handleTickCountUp - runningSecondsOverdue is \(runningSecondsOverdue)")
            JukeBox.instance.playSound(SOUND.BeepBeep)
            prepareHapticIfNeeded()
        } else {
            runningCountingUp = true
            syncTimerPosition()
        }
    }
    
    func handleTimerReset() {
        
        runningSecondsOverdue = 0
        runningSecondsCountingUp = 0
        runningCountingUp = false
        timer.set(game: game)
        timeLabel.text = stopWatchLabelTimeString()
        timeLabel.setNeedsDisplay()
    }
    
    func handleReachedZero() {
        
        prepareHapticIfNeeded()
        haptic?.notificationOccurred(.warning)
        haptic = nil
        
        JukeBox.instance.playSound(SOUND.BeepBeep)
        prepareHapticIfNeeded()
        updateProgressBars()
        runningSecondsToGo = 0
        message = LS_OVERTIME
        resetTimeLabel(withColor: COLOR.LightYellow, alpha: 1)
        icon.change(to: .StopIcon)
        delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: nil)
    }
}
