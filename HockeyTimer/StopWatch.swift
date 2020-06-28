//
//  StopWatch.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 22/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit
import AudioToolbox

protocol StopWatchDelegate: AnyObject {
    
    func handleTimerStateChange(stopWatchTimer: StopWatchTimer, completionHandler: (() -> Void)?)
    func handleTappedForNewGame()
    func minusOneSecond()
}


class StopWatch: UIControl {
    
    
    // MARK: - Properties
    
    var game: HockeyGame! {
        didSet {
            updateLabels()
            resetTimeLabel(withColor: timeLabel.standardColor, alpha: 1) // .label
        }
    }
    
    var message: String = LS_NEWGAME {
        didSet {
            messageLabel.text = message
            messageLabel.setNeedsDisplay()
        }
    }

    private var delegate: StopWatchDelegate!
    var timer: StopWatchTimer!
    private var icon: StopWatchControlIcon!
    private var timeLabel: StopWatchLabel!

    private var squareContainer: CALayer!
    private var progressZone: CAShapeLayer!
    private var core: CALayer!
    
    private var progressBars: [CAShapeLayer]!
    
    private var messageLabel: UILabel!
    private var periodLabel: UILabel!
    private var durationLabel: UILabel!
    
    private var haptic: UINotificationFeedbackGenerator?
    private var impactHaptic: UIImpactFeedbackGenerator?
    
    private let progressBarWidth: CGFloat = 14
    private let progressZoneWidth: CGFloat = 20
    private var progressBarStrokeInsetRatio: CGFloat {
        let roundPart: CGFloat = progressBarWidth / 2
        let segmentAngle: CGFloat = (2 * .pi) / CGFloat(game.periods)
        let segmentLength: CGFloat = segmentAngle * (squareSide - progressBarWidth / 2)
        return roundPart * 2.75 / segmentLength
    }
    
    private var squareSide: CGFloat {
        return min(self.bounds.width, self.bounds.height)
    }
    
    private let progressBarColor: UIColor = .white
    
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        game = HockeyGame(minutes: HockeyGame.standardTotalMinutes, periods: HockeyGame.standardPeriods)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        game = HockeyGame(minutes: HockeyGame.standardTotalMinutes, periods: HockeyGame.standardPeriods)
        setUp()
    }
    
    convenience init(delegate: StopWatchDelegate, game: HockeyGame) {
        
        self.init()
        self.delegate = delegate
        self.game = game
        print("SW init will call timer.set with game \(game.periods)")
        timer.set(game: game)
        runningSecondsToGo = timer.totalSecondsToGo
        updateLabels()
        periodLabel.text = game.periodString
        setNeedsLayout()
    }
    
    private func setUp() {
        
        backgroundColor = .clear
        
        squareContainer = CALayer()
        squareContainer.backgroundColor = UIColor.clear.cgColor
        squareContainer.shouldRasterize = true
        squareContainer.rasterizationScale = UIScreen.main.scale
        layer.addSublayer(squareContainer)
        
        progressZone = CAShapeLayer()
        progressZone.strokeColor = UIColor.clear.cgColor
        progressZone.fillColor = UIColor(named: ColorName.StopWatchProgressZone)!.cgColor
        squareContainer.addSublayer(progressZone)
        
        core = CALayer()
        core.backgroundColor = UIColor.systemBackground.cgColor
        squareContainer.addSublayer(core)
        
        progressBars = createProgressBars()
        
        icon = StopWatchControlIcon(icon: .PlayIcon)
        icon.color = UIColor(named: ColorName.StopWatchIcon)!
        addSubview(icon)
        
        timer = StopWatchTimer(delegate: self, game: game)
        
        timeLabel = StopWatchLabel(text: stopWatchLabelTimeString())
        addSubview(timeLabel)
        
        durationLabel = StopWatchSmallLabel()
        durationLabel.font = UIFont(name: FONTNAME.LessImportantNumbers, size: durationLabel.font.pointSize)
        addSubview(durationLabel)
        
        messageLabel = StopWatchSmallLabel()
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.numberOfLines = 0
        message = LS_NEWGAME
        messageLabel.font = UIFont(name: FONTNAME.LessImportantNumbers, size: durationLabel.font.pointSize)
        addSubview(messageLabel)
        
        periodLabel = StopWatchSmallLabel()
        periodLabel.font = UIFont(name: FONTNAME.LessImportantNumbers, size: durationLabel.font.pointSize)
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
        
        core.frame = squareContainer.bounds.insetBy(dx: progressZoneWidth, dy: progressZoneWidth)
        core.cornerRadius = core.bounds.width / 2
        
        updateProgressBars()
        
        icon.frame = bounds.insetBy(dx: (130 * bounds.width / 230) / 2, dy: (130 * bounds.height / 230) / 2)
        
        timeLabel.frame = bounds.insetBy(dx: bounds.width * 0.15, dy: bounds.height * 0.35)
        
        NSLayoutConstraint.activate([
            
            messageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 90/230),
            messageLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 40/230),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 28),
            
            durationLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80/230),
            durationLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 20/230),
            durationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -41),
            
            periodLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80/230),
            periodLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 20/230),
            periodLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            periodLabel.topAnchor.constraint(equalTo: durationLabel.topAnchor, constant: durationLabel.font.pointSize + 2),
            
            ])
        
        updateLabels()
        
        core.backgroundColor = UIColor.systemBackground.cgColor
        progressZone.fillColor = UIColor(named: ColorName.StopWatchProgressZone)!.cgColor

        progressBars.forEach {
            $0.strokeColor = progressBarColor.cgColor
        }
        
        [timeLabel, messageLabel, periodLabel, durationLabel].forEach {
            $0?.setNeedsLayout()
        }
        
        timeLabel.setNeedsLayout()
    }
    
    private func updateLabels() {
        
        updateDurationLabel()
        updateTimeLabel()
    }
    
    private func updateDurationLabel() {
        
        let numberOfPeriods = "\(Int(game.periods))"
        let periodMinutes = Double.maxOneDecimalDividing(game.totalMinutes, by: game.periods)
        let minutesString = periodMinutes.stringWithMaxOneDecimal + " min"
        
        durationLabel.text = numberOfPeriods + "x" + minutesString
        durationLabel.setNeedsDisplay()
    }
    
    private func updateTimeLabel() {
        
        timeLabel.text = stopWatchLabelTimeString()
        showTimeLabel()
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
                    timer.totalSecondsCountingUp = runningSecondsCountingUp
                    timer.startOverdueCountUp()
                    handleReachedZero()
                } else {
                    timer.totalSecondsOverdue = runningSecondsOverdue
                    timer.totalSecondsCountingUp = runningSecondsCountingUp
                }
            } else if runningSecondsCountingUp > 0 {
                timer.totalSecondsCountingUp = runningSecondsCountingUp
            }
            updateProgressBars()
            periodLabel.text = game.periodString
            updateTimeLabel()
            showTimeLabel()
            shouldRestoreFromBackground = false
        }
    }
    
    
    // MARK: - User methods
    
    func stopWatchLabelTimeString() -> String {
        
        if game.status == .Finished {
            return "\(game.homeScore)-\(game.awayScore)"
        }
        
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
        timer.reset(withGame: game)
        updateLabels()
        message = LS_NEWGAME
        periodLabel.text = game.periodString
        periodLabel.alpha = 1.0
        updateProgressBars()
        resetTimeLabel(withColor: timeLabel.standardColor, alpha: 1) // .label
        setProgressBarsColor(to: progressBarColor)
        icon.icon = .PlayIcon
        setNeedsLayout()
    }
    
    func simplifyForOnboarding(bgColor: UIColor, iconColor: UIColor, timeColor: UIColor, progressZoneColor: UIColor) {
        
        let simpleGame = HockeyGame(minutes: HockeyGame.standardTotalMinutes, periods: HockeyGame.standardPeriods)
        reset(withGame: simpleGame)
        messageLabel.alpha = 0.0
        periodLabel.alpha = 0.0
        durationLabel.alpha = 0.0
        isUserInteractionEnabled = false
        core.backgroundColor = bgColor.cgColor
        icon.color = iconColor
        timeLabel.textColor = timeColor
        timeLabel.setFont(font: UIFont(name: FONTNAME.ThemeBlack, size: 40)!)
        progressZone.fillColor = progressZoneColor.cgColor
    }
    
    func hideTimeLabel() {
        
        timeLabel.alpha = 0.0
    }
    
    func showTimeLabel() {
        
        if timeLabel.alpha == 0.0 {
            UIView.animate(withDuration: 0.3) {
                self.timeLabel.alpha = 1.0
            }
        }
    }
    
    
    // MARK: - Progress Bar Methods

    @objc fileprivate func updateProgressBars() {

        progressBars.forEach {
            $0.removeFromSuperlayer()
        }
        progressBars = createProgressBars()
        
        for index in 1 ... progressBars.count {
            let bar = progressBars[index - 1]
            switch index {
            case ..<Int(game.currentPeriod):
                bar.strokeEnd = strokeEndPosition(progress: 1)
            case Int(game.currentPeriod):
                bar.strokeEnd = strokeEndPosition(progress: timer.progressCappedAt1)
            case (Int(game.currentPeriod) + 1)...:
                bar.strokeEnd = strokeEndPosition(progress: 0)
            default:
                fatalError("Trying to access incorrect index")
            }
        }
    }
    
    private func createProgressBars() -> [CAShapeLayer] {
        
        var result: [CAShapeLayer] = []
        for index in 1 ... Int(game.periods) {
            let bar = progressBarLayer(forPeriod: index)
            squareContainer.addSublayer(bar)
            result.append(bar)
        }
        return result
    }
    
    private func progressBarLayer(forPeriod period: Int) -> CAShapeLayer {
        
        let shape = progressBarLayer()
        shape.path = progressBarPath(forPeriod: period).cgPath
        return shape
    }
    
    private func progressBarLayer() -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        
        shape.strokeColor = progressBarColor.cgColor
        shape.lineWidth = progressBarWidth
        shape.lineCap = .round
        shape.lineJoin = .miter
        shape.fillColor = UIColor.clear.cgColor
        shape.position = CGPoint.zero
        shape.strokeStart = progressBarStrokeInsetRatio
        shape.strokeEnd = progressBarStrokeInsetRatio
        shape.contentsScale = UIScreen.main.scale
        
        return shape
    }
    
    
    private func progressBarPath(forPeriod period: Int) -> UIBezierPath {
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius: CGFloat = squareSide / 2 - progressZoneWidth / 2
        let segmentAngle: CGFloat = (2 * .pi) / CGFloat(game.periods)
        let zeroAngle: CGFloat = (.pi / 2) * (-1)
        let startAngle: CGFloat = zeroAngle + segmentAngle * CGFloat(period - 1)
        let endAngle: CGFloat = startAngle + segmentAngle
        
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
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
            
            // Start Period or Resume after pausing
            timer.startCountDown()
            game.status = .Running
            JukeBox.instance.prepareSound(Sound.BeepBeep)
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
                dismissOvertime()
                delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: nil)

            } else if game.status == .EndOfPeriod {
                // Overtime dismissed
                getReadyForNextPeriod()
            }
            
            resetTimeLabel(withColor: timeLabel.standardColor, alpha: 1) // .label
            JukeBox.instance.stopPlayingAll()
            JukeBox.instance.removeSound(Sound.BeepBeep)
            
        case .NoIcon:
            delegate?.handleTappedForNewGame()
        }
    }
    
    private func dismissOvertime() {
        
        if game.currentPeriod == game.periods {
            dismissFullGameOvertime()
        } else {
            dismissPeriodOvertime()
        }
    }
    
    private func dismissPeriodOvertime() {
        
        game.status = .EndOfPeriod
        periodLabel.alpha = 0.0
        message = game.endOfPeriodMessage
        
        timer.startCountUp()
    }
    
    private func dismissFullGameOvertime() {
        
        game.status = .Finished
        periodLabel.alpha = 0.0
        message = game.endOfPeriodMessage

        icon.change(to: .NoIcon)
        setProgressBarsColor(to: .clear)
        scheduleRequestReview()
    }
    
    private func getReadyForNextPeriod() {
        
        guard game.currentPeriod <= game.periods else {
            fatalError("Game in period exceeding total number of periods")
        }
        game.currentPeriod += 1
        periodLabel.text = game.periodString
        timer.reset(withGame: game)
        setProgressBarsColor(to: progressBarColor)
        if durationLabel.alpha > 0 {
            periodLabel.alpha = 1.0
        }
        message = game.readyForNextPeriodMessage
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
    
    private func resetTimeLabel(withColor color: UIColor, alpha: CGFloat) {
        
        timeLabel.textColor = color
        timeLabel.alpha = alpha
        timeLabel.text = stopWatchLabelTimeString()
        showTimeLabel()
    }
    
    private func setProgressBarsColor(to newColor: UIColor) {
        
        progressBars.forEach {
            $0.strokeColor = newColor.cgColor
            $0.setNeedsDisplay()
        }
    }
    
    private func syncTimerPosition() {
        
        runningSecondsToGo = timer.totalSecondsToGo
        runningSecondsOverdue = timer.totalSecondsOverdue
        runningSecondsCountingUp = timer.totalSecondsCountingUp
    }
    
    private func beepInOvertime() {
        
        guard message == LS_OVERTIME else { return }
        
        haptic?.notificationOccurred(.warning)
        haptic = nil
        JukeBox.instance.playSound(Sound.BeepBeep)
        prepareHapticIfNeeded()
    }
    
    // MARK: - Haptic
    
    private func prepareHapticIfNeeded() {
        guard #available(iOS 10.0, *) else { return }
        if haptic == nil {
            haptic = UINotificationFeedbackGenerator()
            haptic!.prepare()
        }
    }
    
    private func prepareImpactHapticIfNeeded() {
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
        showTimeLabel()
        delegate.minusOneSecond()
        game.currentTimerProgressedToMinute(timer.currentMinute)
        updateProgressBars()
        beepInOvertime()
    }
    
    func handleTickCountUp() {
        
        timeLabel.text = stopWatchLabelTimeString()
        showTimeLabel()
        beepInOvertime()
        if message != LS_OVERTIME {
            runningCountingUp = true
        }
        syncTimerPosition()
    }
    
    func handleTimerReset() {
        
        runningSecondsOverdue = 0
        runningSecondsCountingUp = 0
        runningCountingUp = false
        timer.set(game: game)
        timeLabel.text = stopWatchLabelTimeString()
        showTimeLabel()
    }
    
    func handleReachedZero() {
        
        prepareHapticIfNeeded()
        haptic?.notificationOccurred(.warning)
        haptic = nil
        
        JukeBox.instance.playSound(Sound.BeepBeep)
        prepareHapticIfNeeded()
        updateProgressBars()
        runningSecondsToGo = 0
        message = LS_OVERTIME
        resetTimeLabel(withColor: UIColor(named: ColorName.PantoneRed)!, alpha: 1)
        icon.change(to: .StopIcon)
        delegate?.handleTimerStateChange(stopWatchTimer: timer, completionHandler: nil)
    }
}
