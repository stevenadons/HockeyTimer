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

    fileprivate var duration: Duration = .TwentyFive
    fileprivate var numberOfPeriods: NumberOfPeriods = .Halves
    var game: HockeyGame! {
        didSet {
            duration = game.duration
        }
    }
    var delegate: TimerVCDelegate?
    private let initialObjectYOffset: CGFloat = UIScreen.main.bounds.height

    var message: String = "" 
    
    
    // MARK: - Loading
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = COLOR.VeryDarkBlue
        view.clipsToBounds = true
        game = pageVC?.game
        setupViews()
        addObservers()
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

        panArrowUp.color = COLOR.LightYellow
        panArrowDown.color = COLOR.LightYellow
        panArrowUpLabel.text = LS_TITLE_GAMETIME
        panArrowDownLabel.text = "0 - 0"
        panArrowDownLabel.font = UIFont(name: FONTNAME.ThemeBlack, size: 20)
        liftPanArrowDownLabelUp()  
        
        NSLayoutConstraint.activate([
            
            resetButton.widthAnchor.constraint(equalToConstant: 44),
            resetButton.heightAnchor.constraint(equalToConstant: 44),
            resetButton.topAnchor.constraint(equalTo: stopWatch.bottomAnchor, constant: 20),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stopWatchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 240/375), 
            stopWatchContainer.heightAnchor.constraint(equalTo: stopWatchContainer.widthAnchor, multiplier: 1),
            stopWatchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopWatchContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50/2 - 30),
            
            stopWatch.widthAnchor.constraint(equalTo: stopWatchContainer.widthAnchor),
            stopWatch.heightAnchor.constraint(equalTo: stopWatchContainer.heightAnchor),
            stopWatch.centerXAnchor.constraint(equalTo: stopWatchContainer.centerXAnchor),
            stopWatch.centerYAnchor.constraint(equalTo: stopWatchContainer.centerYAnchor),
            
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
    }
    
    @objc fileprivate func handleNewGame() {
        
        game = pageVC?.game
        stopWatch?.reset(withGame: game)
        panArrowDownLabel.text = "0 - 0"
        hideIcons()
    }
    
    @objc private func handleGoToBackground() {
        
        if timerIsRunning {
            stopWatch.hideTimeLabel()
        }
    }
    
    private func createNewGame() {
        
        if let minutes = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.Duration) as? Int {
            if let enumCase = Duration(rawValue: minutes) {
                duration = enumCase
            }
        }
        if let savedNumberOfPeriods = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.NumberOfPeriods) as? Int {
            if let enumCase = NumberOfPeriods(rawValue: savedNumberOfPeriods) {
                numberOfPeriods = enumCase
            }
        }
        game = HockeyGame(duration: duration, numberOfPeriods: numberOfPeriods)
        print("TimerVC.createNewGame created game with numberOfPeriods \(numberOfPeriods)")
        pageVC?.game = game
        NotificationCenter.default.post(name: .NewGame, object: nil)
    }
    
    private func showBuyPremiumVC(onProgressionEarned: ((Bool) -> Void)?) {
    
        let buyPremiumVC = BuyPremiumVC(title: LS_BUYPREMIUM_TITLE_NEW_GAME, text: LS_BUYPREMIUM_TEXT_NEW_GAME, afterDismiss: onProgressionEarned)
        present(buyPremiumVC, animated: true, completion: nil)
    }
    
    private func showAlertNewGame() {
        
        let askConfirmationVC = SimpleAlertVC(titleText: LS_WARNINGNEWGAME_TITLE, text: LS_WARNINGNEWGAME_TEXT, okButtonText: "OK", cancelButtonText: LS_BUTTON_CANCEL, okAction: {
            self.handleRequestNewGameConfirmed()
        }, cancelAction: nil)
        
        DispatchQueue.main.async {
            self.present(askConfirmationVC, animated: true, completion: nil)
        }
    }
    
    private func handleRequestNewGameConfirmed() {
        
        let inPremiumMode = UserDefaults.standard.bool(forKey: USERDEFAULTSKEY.PremiumMode)
        if inPremiumMode {
            handleConfirmationNewGame()
            
        } else {
            showBuyPremiumVC(onProgressionEarned: { earned in
                if earned {
                    self.handleConfirmationNewGame()
                }
            })
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

}



