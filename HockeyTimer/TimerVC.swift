//
//  TimerVC.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 16/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit
import AudioToolbox


class TimerVC: PanArrowVC {

    
    // MARK: - Properties
    
    private var stopWatchContainer: ContainerView!
    private var stopWatch: StopWatch!
    private var cardTimerPanel: CardTimerPanel!
    private var minutes: Double = HockeyGame.standardTotalMinutes
    private var periods: Double = HockeyGame.standardPeriods
    
    var game: HockeyGame! {
        didSet {
            guard game != nil else { return }
            minutes = game.totalMinutes
        }
    }
    var delegate: TimerVCDelegate?
    
    private let initialObjectYOffset: CGFloat = UIScreen.main.bounds.height
    private let resetButtonFadedAlpha: CGFloat = 1.0

    var message: String = ""
    
        
    // MARK: - Loading
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: ColorName.LightYellow_Black)! 
        view.clipsToBounds = true
        game = pageVC?.game
        setupViews()
        addObservers()
    }
    
    private func setupViews() {
        
        let iconColor = UIColor.white
        let textColor = UIColor(named: ColorName.PantoneRed)!
        
        gameTimeButton.setColor(iconColor: iconColor, textColor: textColor)
        rulesButton.setColor(iconColor: iconColor, textColor: textColor)
        menuButton.setColor(iconColor: iconColor, textColor: textColor)
        resetButton.setColor(iconColor: iconColor, textColor: textColor)
        resetButton.alpha = resetButtonFadedAlpha
        resetButton.isUserInteractionEnabled = false

        stopWatchContainer = ContainerView()
        view.addSubview(stopWatchContainer)
        
        stopWatch = StopWatch(delegate: self, game: game)
        stopWatch.translatesAutoresizingMaskIntoConstraints = false
        stopWatchContainer.addSubview(stopWatch)
        
        cardTimerPanel = CardTimerPanel()
        cardTimerPanel.delegate = self
        if !FeatureFlags.cards {
            cardTimerPanel.alpha = 0.0
        }
        view.addSubview(cardTimerPanel)

        panArrowUpLabel.alpha = 0.0
        panArrowUp.alpha = 0.0
        panArrowDownLabel.textColor = .white
        panArrowDownLabel.text = "0 - 0"
        panArrowDownLabel.font = UIFont(name: FONTNAME.ThemeBold, size: 20)
        liftPanArrowDownLabelUp()
        
        let stopWatchExtraYOffset: CGFloat = 0
//        let stopWatchExtraYOffset: CGFloat = UIDevice.whenDeviceIs(small: 10, normal: 10, big: 35)

        NSLayoutConstraint.activate([
            
            stopWatchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 240/375), 
            stopWatchContainer.heightAnchor.constraint(equalTo: stopWatchContainer.widthAnchor, multiplier: 1),
            stopWatchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopWatchContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50/2 - stopWatchExtraYOffset),
            
            stopWatch.widthAnchor.constraint(equalTo: stopWatchContainer.widthAnchor),
            stopWatch.heightAnchor.constraint(equalTo: stopWatchContainer.heightAnchor),
            stopWatch.centerXAnchor.constraint(equalTo: stopWatchContainer.centerXAnchor),
            stopWatch.centerYAnchor.constraint(equalTo: stopWatchContainer.centerYAnchor),
            
            cardTimerPanel.topAnchor.constraint(equalTo: stopWatchContainer.bottomAnchor, constant: 25),
            cardTimerPanel.heightAnchor.constraint(equalToConstant: 76),
            cardTimerPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardTimerPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            ])
        
        disableResetButton()
    }
    
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterRestoringFromBackground), name: .CurrentTimerPositionLoaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewGame), name: .NewGame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleGoToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(circularFABWillOpen), name: .CircularFABWillOpen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(circularFABDidClose), name: .CircularFABDidClose, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Drawing and laying out
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        panArrowDown.color = UIColor(named: ColorName.PantoneRed_LightYellow)!
        panArrowDown.setNeedsLayout()
    }
    
    
    
    // MARK: - Private Methods
    
    private func disableResetButton() {
        
        UIView.animate(withDuration: 0.2) {
            self.resetButton.alpha = self.resetButtonFadedAlpha
        }
        resetButton.isUserInteractionEnabled = false
    }
    
    private func enableResetButton() {
        
        UIView.animate(withDuration: 0.2) {
            self.resetButton.alpha = 1.0
        }
        resetButton.isUserInteractionEnabled = true

    }
    
    @objc fileprivate func updateAfterRestoringFromBackground() {
        
        stopWatch.updateAfterRestoringFromBackground()
        cardTimerPanel.updateAfterRestoringFromBackground()
    }
    
    @objc fileprivate func handleNewGame() {
        
        game = pageVC?.game
        cardTimerPanel.deleteAllCards()
        stopWatch?.reset(withGame: game)
        panArrowDownLabel.text = "0 - 0"
        disableResetButton()
    }
    
    @objc private func handleGoToBackground() {
        
        if timerIsRunning {
            stopWatch.hideTimeLabel()
        }
    }
    
    @objc private func circularFABWillOpen() {
        
        panArrowDown.alpha = 0.0
        panArrowDownLabel.alpha = 0.0
    }
    
    @objc private func circularFABDidClose() {
        
        panArrowDown.alpha = 1.0
        panArrowDownLabel.alpha = 1.0
    }
    
    func createNewGame() {

        let savedMinutes = UserDefaults.standard.double(forKey: UserDefaultsKey.Minutes)
        let minutes = savedMinutes > 0 ? savedMinutes : HockeyGame.standardTotalMinutes
        let savedPeriods = UserDefaults.standard.double(forKey: UserDefaultsKey.Periods)
        let periods = savedPeriods > 0 ? savedPeriods : HockeyGame.standardPeriods
        game = HockeyGame(minutes: minutes, periods: periods)
        
        pageVC?.game = game
        cardTimerPanel.deleteAllCards()
        NotificationCenter.default.post(name: .NewGame, object: nil)
    }
    
    private func showBuyPremiumVC(onProgressionEarned: ((Bool) -> Void)?) {
    
        let buyPremiumVC = BuyPremiumVC(title: LS_BUYPREMIUM_TITLE_CARD, text: LS_BUYPREMIUM_TEXT_CARD, showFirstButton: true, afterDismiss: onProgressionEarned)
        present(buyPremiumVC, animated: true, completion: nil)
    }
    
    private func showAlertNewGame(onOK: (() -> Void)?) {
        
        #warning("custom message : 2 cases")
        let askConfirmationVC = SimpleAlertVC(titleText: LS_WARNINGNEWGAME_TITLE, text: LS_WARNINGGAMERUNNING, okButtonText: LS_BUYPREMIUM_OK, cancelButtonText: LS_BUTTON_CANCEL, okAction: {
            onOK?()
        }, cancelAction: nil)
        
        DispatchQueue.main.async {
            self.present(askConfirmationVC, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Public Mehods

    
    func handleConfirmationNewGame() {
        
        createNewGame()
        if message == LS_WARNINGRESETGAME {
            resetWithNewGame()
        } else if message == LS_WARNINGNEWGAME_TITLE {
            handleNewGame()
        }
    }
    
    
    
    // MARK: - Touch Methods
        
    override func resetButtonTapped(sender: IconButton, forEvent event: UIEvent) {
        
        showAlertNewGame(onOK: {
            self.handleConfirmationNewGame()
        })
    }
    
    override func gameTimeButtonTapped(sender: IconButton, forEvent event: UIEvent) {
        
        let currentGameRunning = (game.status != .WaitingToStart)
        let vc = GameTimeVC(currentPeriods: game.periods, currentTotalMinutes: game.totalMinutes, currentGameRunning: currentGameRunning, onDismiss: { (totalMinutes, periods) in
            
            guard totalMinutes != nil || periods != nil else {
                return
            }
            
            let newMinutes = totalMinutes ?? self.game.totalMinutes
            let newPeriods = periods ?? self.game.periods
            UserDefaults.standard.set(newMinutes, forKey: UserDefaultsKey.Minutes)
            UserDefaults.standard.set(newPeriods, forKey: UserDefaultsKey.Periods)
            self.pageVC?.game = HockeyGame(minutes: newMinutes, periods: newPeriods)
            NotificationCenter.default.post(name: .NewGame, object: nil)
        })
        
        present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - Public Methods

    func resetWithNewGame() {
        
        handleNewGame()
        
        // Warn delegate (which is ScoreVC)
        delegate?.resetGame()
    }
    
    func scoreDidChange() {
        
        panArrowDownLabel.text = "\(game.homeScore) - \(game.awayScore)"
    }
}


extension TimerVC: StopWatchDelegate {
    
    func handleTimerStateChange(stopWatchTimer: StopWatchTimer, completionHandler: (() -> Void)?) {
        
        if stopWatchTimer.state != .WaitingToStart {
            enableResetButton()
        }
        completionHandler?()
    }
    
    func handleTappedForNewGame() {
        
        showAlertNewGame(onOK: {
            self.handleConfirmationNewGame()
        })
    }
    
    func minusOneSecond() {
        
        cardTimerPanel.minusOneSecond()
    }
}


extension TimerVC: CardTimerPanelDelegate {
    
    func shouldAddCard() {
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.PremiumMode) {
            showAddTimerVC()
            
        } else {
            showBuyPremiumVC(onProgressionEarned: { earned in
                if earned {
                    self.showAddTimerVC()
                }
            })
        }
    }
    
    private func showAddTimerVC() {
        
        let vc = AddCardTimerVC(okAction: { (cardType, minutes) in
            let card = Card(type: cardType)
            self.cardTimerPanel.add(card, minutes: minutes)
        }, cancelAction: nil)
        present(vc, animated: true, completion: nil)
    }
}



