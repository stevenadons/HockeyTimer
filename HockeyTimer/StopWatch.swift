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
    
    private var half: HALF {
        return game.half
    }
    private var duration: MINUTESINHALF {
        return game.duration
    }

    private var squareContainer: CALayer!
    private var progressZone: CAShapeLayer!
    private var core: CALayer!
    fileprivate var firstProgressBar: CAShapeLayer!
    fileprivate var secondProgressBar: CAShapeLayer!
    private var messageLabel: UILabel!
    fileprivate var halfLabel: UILabel!
    private var durationLabel: UILabel!
    
    fileprivate var haptic: UINotificationFeedbackGenerator?
    fileprivate var impactHaptic: UIImpactFeedbackGenerator?
    
    private let progressBarWidth: CGFloat = 18
    private let progressBarStrokeInsetRatio: CGFloat = 0.005
    
    private var squareSide: CGFloat {
        return min(self.bounds.width, self.bounds.height)
    }
    
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        game = HockeyGame(duration: .TwentyFive)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        game = HockeyGame(duration: .TwentyFive)
        setUp()
    }
    
    convenience init(delegate: StopWatchDelegate, game: HockeyGame) {
        
        self.init()
        self.delegate = delegate
        self.game = game
        timer.set(duration: game.duration)
        timeLabel.text = stopWatchLabelTimeString()
        updateDurationLabel()
        halfLabel.text = LS_FIRSTHALFLABEL
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
        
        firstProgressBar = progressBarLayer(for: .First)
        squareContainer.addSublayer(firstProgressBar)
        secondProgressBar = progressBarLayer(for: .Second)
        squareContainer.addSublayer(secondProgressBar)
        
        icon = StopWatchControlIcon(icon: .PlayIcon)
        icon.color = COLOR.DarkBlue
        addSubview(icon)
        
        timer = StopWatchTimer(delegate: self, duration: duration)
        
        timeLabel = StopWatchLabel(text: stopWatchLabelTimeString())
        addSubview(timeLabel)
        
        durationLabel = StopWatchSmallLabel()
        addSubview(durationLabel)
        messageLabel = StopWatchSmallLabel()
        message = LS_NEWGAME
        messageLabel.font = UIFont(name: FONTNAME.ThemeBold, size: durationLabel.font.pointSize)
        addSubview(messageLabel)
        halfLabel = StopWatchSmallLabel()
        halfLabel.font = UIFont(name: FONTNAME.ThemeBold, size: durationLabel.font.pointSize)
        addSubview(halfLabel)
        
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
            messageLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 20/230),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 34),
            
            durationLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80/230),
            durationLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 20/230),
            durationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            
            halfLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80/230),
            halfLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 20/230),
            halfLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            halfLabel.topAnchor.constraint(equalTo: durationLabel.topAnchor, constant: durationLabel.font.pointSize),
            
            ])
        
        updateDurationLabel()
    }
    
    private func updateDurationLabel() {
        
        durationLabel.text = "2x\(game.duration.rawValue)min"
        durationLabel.setNeedsDisplay()
    }
    
    func updateAfterRestoringFromBackground() {
        
        if shouldRestoreFromBackground {
            if runningSecondsToGo > 0 {
                timer.totalSecondsToGo = runningSecondsToGo
            } else if runningSecondsOverdue > 0 {
                if timer.state != .Overdue {
                    // Timer has gone overdue when app inactive
                    timer.state = .Overdue
                    timer.stopCountDown()
                    timer.totalSecondsOverdue = runningSecondsOverdue
                    timer.totalSecondsCountingUp = runningSecondsOverdue
                    timer.startCountUp()
                    handleReachedZero()
                }
            } else if runningSecondsCountingUp > 0 {
                timer.totalSecondsCountingUp = runningSecondsCountingUp
            }
            updateProgressBars()
            halfLabel.text = (runningHalf == .First) ? LS_FIRSTHALFLABEL : LS_SECONDHALFLABEL
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
        timer.reset() //
        message = LS_NEWGAME
        halfLabel.text = LS_FIRSTHALFLABEL
        halfLabel.alpha = 1.0
        runningHalf = .First
        updateProgressBars()
        resetTimeLabel(withColor: COLOR.White, alpha: 1)
        setProgressBarsColor(to: COLOR.White)
        icon.icon = .PlayIcon
        setNeedsLayout()
    }
    
    func simplifyForOnboarding(bgColor: UIColor, iconColor: UIColor, timeColor: UIColor, progressZoneColor: UIColor) {
        
        let simpleGame = HockeyGame(duration: .Thirty)
        reset(withGame: simpleGame)
        messageLabel.alpha = 0.0
        halfLabel.alpha = 0.0
        durationLabel.alpha = 0.0
        isUserInteractionEnabled = false
        core.backgroundColor = bgColor.cgColor
        icon.color = iconColor
        timeLabel.textColor = timeColor
        timeLabel.setFont(font: UIFont(name: FONTNAME.ThemeBold, size: 44)!)
        progressZone.fillColor = progressZoneColor.cgColor
    }
    
    
    
    // MARK: - Private methods
    
    fileprivate func updateProgressBars() {
        
        firstProgressBar.removeFromSuperlayer()
        firstProgressBar = progressBarLayer(for: .First)
        firstProgressBar.strokeEnd = (self.half == .Second || timer.state == .Overdue || timer.state == .RunningCountUp) ? strokeEndPosition(progress: 1) : strokeEndPosition(progress: timer.progress)
        squareContainer.addSublayer(firstProgressBar)
        
        secondProgressBar.removeFromSuperlayer()
        secondProgressBar = progressBarLayer(for: .Second)
        if self.half == .First {
            secondProgressBar.strokeEnd = strokeEndPosition(progress: 0)
        } else {
            secondProgressBar.strokeEnd = (timer.state == .Overdue || timer.state == .RunningCountUp) ? strokeEndPosition(progress: 1) : strokeEndPosition(progress: timer.progress)
        }
        squareContainer.addSublayer(secondProgressBar)
    }
    
    
    
    // MARK: - Progress Bar Methods
    
    private func progressBarLayer(for half: HALF) -> CAShapeLayer {
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
        shape.path = progressBarPath(for: half).cgPath
        return shape
    }
    
    private func progressBarPath(for half: HALF) -> UIBezierPath {
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
                if game.half == .First {
                    // End of first half - will enter half time count up mode
                    game.status = .HalfTime
                    timer.startCountUp()
                    halfLabel.alpha = 0.0
                    message = LS_HALFTIME
                } else {
                    // End of second half
                    game.status = .Finished
                    setProgressBarsColor(to: UIColor.clear)
                    halfLabel.alpha = 0.0
                    icon.change(to: .NoIcon)
                    message = LS_FULLTIME
                }
                delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: nil)

            } else if game.status == .HalfTime {
                // Half time counter stopped
                game.half = .Second
                halfLabel.text = LS_SECONDHALFLABEL
                runningHalf = .Second
                timer.reset()
                setProgressBarsColor(to: COLOR.White)
                if durationLabel.alpha > 0 {
                    halfLabel.alpha = 1.0
                }
                message = LS_READYFORH2
                delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: {
                    self.icon.change(to: .PlayIcon)
                })
            }
            resetTimeLabel(withColor: COLOR.White, alpha: 1)
            JukeBox.instance.stopPlayingAll()
            JukeBox.instance.removeSound(SOUND.BeepBeep)
            
        case .NoIcon:
            delegate?.handleTappedForNewGame()
        }
    }
    
    fileprivate func resetTimeLabel(withColor color: UIColor, alpha: CGFloat) {
        timeLabel.textColor = color
        timeLabel.alpha = alpha
        timeLabel.text = stopWatchLabelTimeString()
        timeLabel.setNeedsDisplay()
    }
    
    fileprivate func setProgressBarsColor(to newColor: UIColor) {
        firstProgressBar.strokeColor = newColor.cgColor
        firstProgressBar.setNeedsDisplay()
        secondProgressBar.strokeColor = newColor.cgColor
        secondProgressBar.setNeedsDisplay()
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
        runningSecondsToGo = timer.totalSecondsToGo
        timeLabel.text = stopWatchLabelTimeString()
        timeLabel.setNeedsDisplay()
        updateProgressBars()
    }
    
    func handleTickCountUp() {
        timeLabel.text = stopWatchLabelTimeString()
        timeLabel.setNeedsDisplay()
        if message == LS_OVERTIME {
            if #available(iOS 10.0, *) {
                haptic?.notificationOccurred(.warning)
                haptic = nil
            }
            runningSecondsOverdue = timer.totalSecondsOverdue
            JukeBox.instance.playSound(SOUND.BeepBeep)
            prepareHapticIfNeeded()
        } else {
            runningCountingUp = true
            runningSecondsCountingUp = timer.totalSecondsCountingUp
        }
    }
    
    func handleTimerReset() {
        runningSecondsOverdue = 0
        runningSecondsCountingUp = 0
        runningCountingUp = false
        timer.set(duration: game.duration)
        timeLabel.text = stopWatchLabelTimeString()
        timeLabel.setNeedsDisplay()
    }
    
    func handleReachedZero() {
        prepareHapticIfNeeded()
        if #available(iOS 10.0, *) {
            haptic?.notificationOccurred(.warning)
            haptic = nil
        } 
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
