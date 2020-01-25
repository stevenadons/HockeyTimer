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
    
    private var resetButton: TopButton!
    private var stopWatchContainer: ContainerView!
    private var stopWatch: StopWatch!
    private var cardTimerPanel: CardTimerPanel!
    private var minutes: Int = HockeyGame.standardMinutes
    private var periods: Int = HockeyGame.standardPeriods
    
    var game: HockeyGame! {
        didSet {
            guard game != nil else { return }
            minutes = game.minutes
        }
    }
    var delegate: TimerVCDelegate?
    
    private let initialObjectYOffset: CGFloat = UIScreen.main.bounds.height

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
        
        resetButton = TopButton(imageName: "arrow.2.circlepath", tintColor: .white)
        resetButton.alpha = 0.0
        resetButton.addTarget(self, action: #selector(resetButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(resetButton)
        
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

        panArrowUpLabel.textColor = .white
        panArrowDownLabel.textColor = .white
        panArrowUpLabel.text = LS_TITLE_GAMETIME
        panArrowDownLabel.text = "0 - 0"
        panArrowDownLabel.font = UIFont(name: FONTNAME.ThemeBold, size: 20)
        liftPanArrowDownLabelUp()
        
        let resetButtonHorInset: CGFloat = UIDevice.whenDeviceIs(small: 28, normal: 32, big: 32)
        let resetButtonTopInset: CGFloat = UIDevice.whenDeviceIs(small: 0, normal: 12, big: 12)
        let stopWatchExtraYOffset: CGFloat = UIDevice.whenDeviceIs(small: 30, normal: 30, big: 55)

        NSLayoutConstraint.activate([
            
            resetButton.widthAnchor.constraint(equalToConstant: resetButton.standardWidth),
            resetButton.heightAnchor.constraint(equalToConstant: resetButton.standardHeight),
            resetButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: resetButtonTopInset),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -resetButtonHorInset),

            stopWatchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 240/375), 
            stopWatchContainer.heightAnchor.constraint(equalTo: stopWatchContainer.widthAnchor, multiplier: 1),
            stopWatchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopWatchContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50/2 - stopWatchExtraYOffset),
            
            stopWatch.widthAnchor.constraint(equalTo: stopWatchContainer.widthAnchor),
            stopWatch.heightAnchor.constraint(equalTo: stopWatchContainer.heightAnchor),
            stopWatch.centerXAnchor.constraint(equalTo: stopWatchContainer.centerXAnchor),
            stopWatch.centerYAnchor.constraint(equalTo: stopWatchContainer.centerYAnchor),
            
            cardTimerPanel.topAnchor.constraint(equalTo: stopWatchContainer.bottomAnchor, constant: 50),
            cardTimerPanel.heightAnchor.constraint(equalToConstant: 76),
            cardTimerPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardTimerPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            ])
        
        hideIcons()
    }
    
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterRestoringFromBackground), name: .CurrentTimerPositionLoaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewGame), name: .NewGame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleGoToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Drawing and laying out
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        panArrowUp.color = UIColor(named: ColorName.PantoneRed_LightYellow)!
        panArrowUp.setNeedsLayout()
        panArrowDown.color = UIColor(named: ColorName.PantoneRed_LightYellow)!
        panArrowDown.setNeedsLayout()
    }
    
    
    
    // MARK: - Private Methods
    
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
    
    @objc fileprivate func updateAfterRestoringFromBackground() {
        
        stopWatch.updateAfterRestoringFromBackground()
        cardTimerPanel.updateAfterRestoringFromBackground()
    }
    
    @objc fileprivate func handleNewGame() {
        
        game = pageVC?.game
        cardTimerPanel.deleteAllCards()
        stopWatch?.reset(withGame: game)
        panArrowDownLabel.text = "0 - 0"
        hideIcons()
    }
    
    @objc private func handleGoToBackground() {
        
        if timerIsRunning {
            stopWatch.hideTimeLabel()
        }
    }
    
    func createNewGame() {

        let savedMinutes = UserDefaults.standard.integer(forKey: UserDefaultsKey.Minutes)
        let minutes = savedMinutes > 0 ? savedMinutes : HockeyGame.standardMinutes
        let savedPeriods = UserDefaults.standard.integer(forKey: UserDefaultsKey.Periods)
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
    
    private func showAlertNewGame() {
        
        let askConfirmationVC = SimpleAlertVC(titleText: LS_WARNINGNEWGAME_TITLE, text: LS_WARNINGNEWGAME_TEXT, okButtonText: "OK", cancelButtonText: LS_BUTTON_CANCEL, okAction: {
            self.handleConfirmationNewGame()
        }, cancelAction: nil)
        
        DispatchQueue.main.async {
            self.present(askConfirmationVC, animated: true, completion: nil)
        }
    }
    
    private func handleConfirmationNewGame() {
        
        createNewGame()
        if message == LS_WARNINGRESETGAME {
            resetWithNewGame()
        } else if message == LS_WARNINGNEWGAME_TITLE {
            handleNewGame()
        }
    }
    
    
    
    // MARK: - Touch Methods
    
    @objc private func resetButtonTapped(sender: NewGameButtonIconOnly, forEvent event: UIEvent) {
        
        showAlertNewGame()
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
            showIcons()
        }
        completionHandler?()
    }
    
    func handleTappedForNewGame() {
        
        showAlertNewGame()
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



