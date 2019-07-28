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
    fileprivate var popupMessage: PopupMessageView!
    fileprivate var confirmationButton: ConfirmationButton!
    fileprivate var cancelButton: ConfirmationButton!

    fileprivate var duration: Duration = .TwentyFive
    var game: HockeyGame!
    var delegate: TimerVCDelegate?
    private var scorePanelCenterYConstraint: NSLayoutConstraint!
    private let initialObjectYOffset: CGFloat = UIScreen.main.bounds.height

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

        maskView = UIButton()
        maskView.addTarget(self, action: #selector(maskViewTapped(sender:forEvent:)), for: [.touchUpInside])
        maskView.translatesAutoresizingMaskIntoConstraints = false
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.0
        view.addSubview(maskView)
        
        popupMessage = PopupMessageView(message: LS_WARNINGRESETPOPUP)
        popupMessage.alpha = 0.0
        view.addSubview(popupMessage)
        
        confirmationButton = ConfirmationButton.blueButton(largeFont: true)
        confirmationButton.alpha = 0.0
        confirmationButton.setTitle(LS_BUTTON_BACK, for: .normal)
        confirmationButton.addTarget(self, action: #selector(confirmationButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(confirmationButton)
        
        cancelButton = ConfirmationButton.redButton(largeFont: true)
        cancelButton.alpha = 0.0
        cancelButton.setTitle(LS_BUTTON_CANCEL, for: .normal)
        cancelButton.addTarget(self, action: #selector(maskViewTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(cancelButton)
        
        panArrowUp.color = COLOR.LightYellow
        panArrowDown.color = COLOR.LightYellow
        panArrowUpLabel.text = LS_TITLE_GAMETIME
        panArrowDownLabel.text = "0 - 0"
        panArrowDownLabel.font = UIFont(name: FONTNAME.ThemeBold, size: 20)
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
            
            maskView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            maskView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            maskView.topAnchor.constraint(equalTo: view.topAnchor),
            maskView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            popupMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupMessage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            popupMessage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            popupMessage.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * 0.1),
            
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: ConfirmationButton.fixedWidth),
            cancelButton.heightAnchor.constraint(equalToConstant: ConfirmationButton.fixedHeight),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180),
            
            confirmationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmationButton.widthAnchor.constraint(equalToConstant: ConfirmationButton.fixedWidth),
            confirmationButton.heightAnchor.constraint(equalToConstant: ConfirmationButton.fixedHeight),
            confirmationButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            
            ])
        
        hideIcons()
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateAfterRestoringFromBackground),
                                               name: .AppWillEnterForeground,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNewGame),
                                               name: .NewGame,
                                               object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Drawing and laying out
    
    
    
    // MARK: - Private Methods
    
    fileprivate func showButtons() {
        
        confirmationButton.grow()
        cancelButton.grow()
    }
    
    fileprivate func temporarilyShowPopupWithMask(message: String) {
        
        self.message = message
        showButtons()
        UIView.animate(withDuration: 0.2) {
            self.maskView.alpha = 0.80
            self.popupMessage.alpha = 1.0
        }
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
    
    @objc fileprivate func updateAfterRestoringFromBackground() {
        
        stopWatch.updateAfterRestoringFromBackground()
    }
    
    @objc fileprivate func handleNewGame() {
        
        game = pageVC?.game
        stopWatch?.reset(withGame: game)
        panArrowDownLabel.text = "0 - 0"
        hideIcons()
    }
    
    private func createNewGame() {
        
        if let minutes = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.Duration) as? Int {
            if let enumCase = Duration(rawValue: minutes) {
                duration = enumCase
            }
        }
        game = HockeyGame(duration: duration)
        pageVC?.game = game
        NotificationCenter.default.post(name: .NewGame, object: nil)
    }
    
    private func showBuyPremiumVC(onProgressionEarned: ((Bool) -> Void)?) {
    
        let buyPremiumVC = BuyPremiumVC(title: LS_BUYPREMIUM_TITLE_NEW_GAME, text: LS_BUYPREMIUM_TEXT_NEW_GAME, afterDismiss: onProgressionEarned)
        present(buyPremiumVC, animated: true, completion: nil)
    }
    
    private func handleConfirmationNewGame() {
        
        hidePopup()
        createNewGame()
        if message == LS_WARNINGRESETGAME {
            resetWithNewGame()
        } else if message == LS_WARNINGNEWGAME {
            handleNewGame()
        }
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func resetButtonTapped(sender: NewGameButtonIconOnly, forEvent event: UIEvent) {
        
        temporarilyShowPopupWithMask(message: LS_WARNINGRESETGAME)
    }
    
    @objc private func confirmationButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        
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
    
    @objc private func maskViewTapped(sender: UIView, forEvent event: UIEvent) {
        
        hidePopup()
    }
    
    
    
    // MARK: - Public Methods

    func resetWithNewGame() {
        
        handleNewGame()
        delegate?.resetGame()
    }
    
    func scoreDidChange() {
        
        panArrowDownLabel.text = "\(game.homeScore) - \(game.awayScore)"
    }
    
    @objc func hidePopup() {
        
        guard popupMessage.alpha == 1.0 else { return }
        
        confirmationButton.shrink()
        cancelButton.shrink()
        UIView.animate(withDuration: 0.2) {
            self.maskView.alpha = 0.0
            self.popupMessage.alpha = 0.0
        }
    }
    
}



extension TimerVC: StopWatchDelegate {
    
    func handleTimerStateChange(stopWatchTimer: StopWatchTimer, completionHandler: (() -> Void)?) {
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
        
        temporarilyShowPopupWithMask(message: LS_WARNINGNEWGAME)
    }

}



