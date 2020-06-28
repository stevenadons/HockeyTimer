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
    private var messageView: MessageView!
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

    var message: String = ""
    
        
    // MARK: - Loading
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: ColorName.LightYellow_Black)! 
        view.clipsToBounds = true
        game = pageVC?.game
        setupViews()
        addObservers()
        
        if FeatureFlags.secretGestureToTestingVC {
            let tap = UITapGestureRecognizer(target: self, action: #selector(secretTap))
            tap.numberOfTapsRequired = 2
            tap.numberOfTouchesRequired = 3
            view.addGestureRecognizer(tap)
        }
    }
    
    private func setupViews() {
        
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
        
        messageView = MessageView()
        messageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageView)

        panArrowUpLabel.alpha = 0.0
        panArrowUp.alpha = 0.0
        panArrowDownLabel.textColor = .white
        panArrowDownLabel.text = "0 - 0"
        panArrowDownLabel.font = UIFont(name: FONTNAME.ThemeBold, size: 20)
        liftPanArrowDownLabelUp()

        NSLayoutConstraint.activate([
            
            stopWatchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 240/375), 
            stopWatchContainer.heightAnchor.constraint(equalTo: stopWatchContainer.widthAnchor, multiplier: 1),
            stopWatchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopWatchContainer.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 10), // 20
            
            stopWatch.widthAnchor.constraint(equalTo: stopWatchContainer.widthAnchor),
            stopWatch.heightAnchor.constraint(equalTo: stopWatchContainer.heightAnchor),
            stopWatch.centerXAnchor.constraint(equalTo: stopWatchContainer.centerXAnchor),
            stopWatch.centerYAnchor.constraint(equalTo: stopWatchContainer.centerYAnchor),
            
            cardTimerPanel.topAnchor.constraint(equalTo: stopWatchContainer.bottomAnchor, constant: 35),
            cardTimerPanel.heightAnchor.constraint(equalToConstant: 90),
            cardTimerPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardTimerPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            messageView.topAnchor.constraint(equalTo: cardTimerPanel.bottomAnchor, constant: 16),
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95)
            
            ])
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    // MARK: - Drawing and laying out
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        panArrowDown.color = UIColor(named: ColorName.PantoneRed)!
        panArrowDown.setNeedsLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        panArrowDown.color = UIColor(named: ColorName.PantoneRed)!
        panArrowDown.setNeedsLayout()
    }
    
    
    // MARK: - Private Methods
    
    @objc private func updateAfterRestoringFromBackground() {
        
        stopWatch.updateAfterRestoringFromBackground()
        cardTimerPanel.updateAfterRestoringFromBackground()
    }
    
    @objc private func handleNewGame() {
        
        game = pageVC?.game
        cardTimerPanel.deleteAllCards()
        stopWatch?.reset(withGame: game)
        panArrowDownLabel.text = "0 - 0"
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
    
        let buyPremiumVC = BuyPremiumVC(title: LS_BUYPREMIUM_TITLE_CARD, text: LS_BUYPREMIUM_TEXT_CARD, showFirstButton: false, afterDismiss: onProgressionEarned)
        present(buyPremiumVC, animated: true, completion: nil)
    }
    
    private func showAlertNewGame(onOK: (() -> Void)?) {
        
        let askConfirmationVC = SimpleAlertVC(titleText: LS_WARNINGNEWGAME_TITLE, text: LS_WARNING_NEWGAME_GAMERUNNING, okButtonText: LS_BUTTON_YES, cancelButtonText: LS_BUTTON_NO, okAction: {
            onOK?()
        }, cancelAction: nil)
        
        DispatchQueue.main.async {
            self.present(askConfirmationVC, animated: true, completion: nil)
        }
    }
    
    private func showLongPressMessage() {
        
        messageView.setMessage(LS_LONG_PRESS_PENALTY_CARD_MESSAGE)
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
    
    @objc private func secretTap() {
        
        let vc = TestingVC()
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
        
        let vc = AddCardTimerVC(okAction: { [weak self] (cardType, minutes, team, player) in
            guard let self = self else { return }
            let card = Card(type: cardType)
            self.cardTimerPanel.add(card, minutes: minutes, cardDrawnAtMinute: self.game.currentMinute, team: team, player: player)
            if !UserDefaults.standard.bool(forKey: UserDefaultsKey.DidShowLongPressPenaltyCardMessage) {
                self.showLongPressMessage()
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.DidShowLongPressPenaltyCardMessage)
            }
        }, cancelAction: nil)
        present(vc, animated: true, completion: nil)
    }
}



