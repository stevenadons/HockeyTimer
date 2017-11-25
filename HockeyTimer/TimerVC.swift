//
//  TimerVC.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 16/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit
import AudioToolbox

protocol StopWatchDelegate: class {
    
    func handleTimerStateChange(stopWatchTimer: StopWatchTimer, completionHandler: (() -> Void)?)
    func handleTappedForNewGame()
}


class TimerVC: PanArrowVC {

    
    // MARK: - Properties
    
    fileprivate var resetButton: NewGameButtonIconOnly!
    fileprivate var stopWatchContainer: ContainerView!
    fileprivate var stopWatch: StopWatch!
    fileprivate var maskView: UIButton!
    fileprivate var confirmationButton: ConfirmationButton!

    fileprivate var duration: MINUTESINHALF = .TwentyFive
    var game: HockeyGame!
    var delegate: TimerVCDelegate?
    private var scorePanelCenterYConstraint: NSLayoutConstraint!
    private let initialObjectYOffset: CGFloat = UIScreen.main.bounds.height
    fileprivate var messageTimer: Timer?
    fileprivate var haptic: UISelectionFeedbackGenerator?

    var message: String = "" {
        didSet {
            confirmationButton.setTitle(message, for: .normal)
        }
    }
    
    
    
    // MARK: - Loading
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = COLOR.VeryDarkBlue
        view.clipsToBounds = true
        game = pageVC?.game
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTime), name: Notification.Name(rawValue: NOTIFICATIONNAME.AppWillEnterForeground), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        prepareHapticIfNeeded()
    }
    
    private func setupViews() {
        
        resetButton = NewGameButtonIconOnly()
        resetButton.alpha = 0.0
        resetButton.addTarget(self, action: #selector(resetButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(resetButton)
        
        stopWatchContainer = ContainerView()
        view.addSubview(stopWatchContainer)
        stopWatch = StopWatch(delegate: self, game: game)
        stopWatch.translatesAutoresizingMaskIntoConstraints = false
        stopWatchContainer.addSubview(stopWatch)

        maskView = UIButton()
        maskView.addTarget(self, action: #selector(maskViewTapped(sender:forEvent:)), for: [.touchUpInside])
        maskView.translatesAutoresizingMaskIntoConstraints = false
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.0
        view.addSubview(maskView)
        
        confirmationButton = ConfirmationButton.blueButton()
        confirmationButton.alpha = 0.0
        confirmationButton.setTitle(LS_BUTTON_BACK, for: .normal)
        confirmationButton.addTarget(self, action: #selector(confirmationButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(confirmationButton)
        
        panArrowUp.color = COLOR.LightYellow
        panArrowDown.color = COLOR.LightYellow
        panArrowUpLabel.text = LS_TITLE_GAMETIME
        panArrowDownLabel.text = LS_TITLE_SCORE
        
        NSLayoutConstraint.activate([
            
            resetButton.widthAnchor.constraint(equalToConstant: 44),
            resetButton.heightAnchor.constraint(equalToConstant: 44),
            resetButton.topAnchor.constraint(equalTo: stopWatch.bottomAnchor, constant: 20),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stopWatchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 210/375),
            stopWatchContainer.heightAnchor.constraint(equalTo: stopWatchContainer.widthAnchor, multiplier: 1),
            stopWatchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopWatchContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50/2 - 30),
            stopWatch.widthAnchor.constraint(equalTo: stopWatchContainer.widthAnchor),
            stopWatch.heightAnchor.constraint(equalTo: stopWatchContainer.heightAnchor),
            stopWatch.centerXAnchor.constraint(equalTo: stopWatchContainer.centerXAnchor),
            stopWatch.centerYAnchor.constraint(equalTo: stopWatchContainer.centerYAnchor),
            
            maskView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            maskView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            maskView.topAnchor.constraint(equalTo: view.topAnchor),
            maskView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            confirmationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmationButton.widthAnchor.constraint(equalToConstant: ConfirmationButton.fixedWidth),
            confirmationButton.heightAnchor.constraint(equalToConstant: ConfirmationButton.fixedHeight),
            confirmationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -95 - admobHeight),
            
            ])
        
        hideIcons()
    }
    
    
    // MARK: - Drawing and laying out
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    
    
    // MARK: - Private Methods
    
    fileprivate func showConfirmationButton() {
        
        confirmationButton.grow()
    }
    
    @objc fileprivate func hideConfirmationButton() {
        
        if messageTimer != nil {
            messageTimer!.invalidate()
            messageTimer = nil
        }
        confirmationButton.shrink()
        UIView.animate(withDuration: 0.2) {
            self.maskView.alpha = 0.0
        }
    }
    
    fileprivate func temporarilyShowConfButtonWithMask(message: String) {
        
        self.message = message
        showConfirmationButton()
        UIView.animate(withDuration: 0.2) {
            self.maskView.alpha = 0.75
        }
        messageTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideConfirmationButton), userInfo: nil, repeats: false)
    }
    
    fileprivate func hideIcons() {
        
        UIView.animate(withDuration: 0.2) {
            self.resetButton?.alpha = 0.0
        }
    }
    
    fileprivate func showIcons() {
        
        UIView.animate(withDuration: 0.2) {
            self.resetButton?.alpha = 1.0
        }
    }
    
    @objc fileprivate func updateTime() {
        
        stopWatch.updateTimeLabel()
    }
    
    private func prepareHapticIfNeeded() {
        
        guard #available(iOS 10.0, *) else { return }
        if haptic == nil {
            haptic = UISelectionFeedbackGenerator()
            haptic!.prepare()
        }
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func resetButtonTapped(sender: NewGameButtonIconOnly, forEvent event: UIEvent) {
        
        temporarilyShowConfButtonWithMask(message: LS_WARNINGRESETGAME)
    }
    
    @objc private func confirmationButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        
        hideConfirmationButton()
        if message == LS_WARNINGRESETGAME {
            resetWithNewGame()
        } else if message == LS_WARNINGNEWGAME {
            handleNewGame()
        }
    }
    
    @objc private func maskViewTapped(sender: UIButton, forEvent event: UIEvent) {
        
        hideConfirmationButton()
    }
    
    
    
    // MARK: - Private Methods

    
    func resetWithNewGame() {
        
        handleNewGame()
        delegate?.resetGame()
    }
    
    
    fileprivate func handleNewGame() {
        
        if let minutes = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.Duration) as? Int {
            if let enumCase = MINUTESINHALF(rawValue: minutes) {
                duration = enumCase
            }
        }
        game = HockeyGame(duration: duration)
        pageVC?.game = game
        stopWatch?.reset(withGame: game)
        hideIcons()
    }
}



extension TimerVC: StopWatchDelegate {
    
    func handleTimerStateChange(stopWatchTimer: StopWatchTimer, completionHandler: (() -> Void)?) {
        
        if #available(iOS 10.0, *) {
            haptic?.selectionChanged()
            haptic = nil
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(1519))
        }
        
        if stopWatchTimer.state != .WaitingToStart {
            showIcons()
        }
        
        switch stopWatchTimer.state {
        case .WaitingToStart:
            completionHandler?()
        case .RunningCountDown:
            completionHandler?()
        case .RunningCountUp:
            completionHandler?()
        case .Paused:
            completionHandler?()
        case .Overdue:
            completionHandler?()
        case .Ended:
            completionHandler?()
        }
    }
    
    func handleTappedForNewGame() {
        
        temporarilyShowConfButtonWithMask(message: LS_WARNINGNEWGAME)
    }

}



