//
//  PageVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit
import AudioToolbox


// Set this PageVC as initial viewcontroller in AppDelegate
class PageVC: UIPageViewController {
    
    
    // MARK: - Properties
    
    var game: HockeyGame! {
        didSet {
            gameStatusChanged()
        }
    }
    var existingTimerVC: TimerVC?
    var existingScoreVC: ScoreVC?
    private var mask: Mask?
    private var backgroundMask: UIView!
    private var newGameButton: CircularFABButton!
    private var circularFAB: CircularFAB!
    
    private var messageManager: RemoteMessageManager!
    private var updateManager: UpdateManager!
    private var minimumIOSManager: MinimumIOSVersionManager!
    
    private var askToNotificationsAlreadyShown: Bool = false
    private var haptic: UISelectionFeedbackGenerator?

    
    
    // MARK: - Init

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        checkDarkMode()
        addObservers()
        
        view.backgroundColor = UIColor(named: ColorName.LightYellow_Black)!

        let savedMinutes = UserDefaults.standard.double(forKey: UserDefaultsKey.Minutes)
        let minutes = savedMinutes > 0 ? savedMinutes : HockeyGame.standardTotalMinutes
        let savedPeriods = UserDefaults.standard.double(forKey: UserDefaultsKey.Periods)
        let periods = savedPeriods > 0 ? savedPeriods : HockeyGame.standardPeriods
        game = HockeyGame(minutes: minutes, periods: periods)
        
        let startVC = TimerVC(pageVC: self)
        setViewControllers([startVC], direction: .forward, animated: false, completion: nil)
        
        backgroundMask = UIView()
        backgroundMask.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        backgroundMask.frame = view.bounds
        view.addSubview(backgroundMask)
        view.sendSubviewToBack(backgroundMask)
        hideBackgroundMask()
        
        newGameButton = CircularFABButton.createStandardButton(imageName: "arrow.2.circlepath.circle")
        newGameButton.bgColor = UIColor(named: ColorName.DarkBlue)!
        newGameButton.contentColor = .white
        newGameButton.alpha = 0.0
        newGameButton.addTarget(self, action: #selector(newGameTapped), for: .touchUpInside)
        view.addSubview(newGameButton)
        
        let imageNames = ["timer", "doc.plaintext", "slider.horizontal.3"]
        circularFAB = CircularFAB(inView: view, imageNames: imageNames, delegate: self)
        
        messageManager = RemoteMessageManager(fromViewcontroller: self, messageURL: "https://raw.githubusercontent.com/stevenadons/RemoteJSON/master/hockeyUppMessage")
        updateManager = UpdateManager(fromViewcontroller: self, appURL: "https://itunes.apple.com/app/apple-store/id1464432452?mt=8")
        minimumIOSManager = MinimumIOSVersionManager(fromViewcontroller: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if !askToNotificationsAlreadyShown {
            mask = Mask(color: .systemBackground, inView: view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        
        existingTimerVC = viewControllers?.first as? TimerVC
        
        askToAllowNotifications(then: { [weak self] in
            self?.messageManager.showMessage(then: { [weak self] in
                self?.updateManager.showUpdate(style: .alert, then: { [weak self] in
                    self?.minimumIOSManager.checkIOSVersion(then: nil)
                })
            })
        })
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let buttonDiameter: CGFloat = 54
        let rightInset: CGFloat = 28
        let bottomInset: CGFloat = 26
        
        newGameButton.frame = CGRect(x: 0, y: 0, width: buttonDiameter, height: buttonDiameter)
        let originX = rightInset
        let originY = view.bounds.height - bottomInset - buttonDiameter
        newGameButton.frame.origin = CGPoint(x: originX, y: originY)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        checkDarkMode()
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDarkMode), name: .DarkModeSettingsChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gameStatusChanged), name: .GameStatusChanged, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Private Methods
    
    private func askToAllowNotifications(then handler: (() -> Void)?) {
        
        guard !askToNotificationsAlreadyShown else {
            mask?.removeFromSuperview()
            handler?()
            return
        }
        askToNotificationsAlreadyShown = true
        
        UserNotificationHandler.sharedHandler.ifNotAuthorized(then: {
            
            // User has denied notifications before
            // Allowing notification will not prompt user
            UserNotificationHandler.sharedHandler.ifAuthorizationIsDenied(then: {
                DispatchQueue.main.async {
                    let askPermissionVC = SimpleAlertVC(titleText: LS_ALLOW_NOTIFICATIONS_TITLE, text: LS_ALLOW_NOTIFICATIONS_GO_TO_SETTINGS, okButtonText: LS_BUYPREMIUM_OK)
                    askPermissionVC.modalPresentationStyle = .fullScreen
                    self.present(askPermissionVC, animated: true, completion: {
                        self.mask?.removeFromSuperview()
                        handler?()
                    })
                }
                
            }, else: {
                // User has not denied before
                // Ask for notifications will prompt user
                DispatchQueue.main.async {
                    let askPermissionVC = SimpleAlertVC(titleText: LS_ALLOW_NOTIFICATIONS_TITLE,
                                                        text: LS_ALLOW_NOTIFICATIONS_ALLOW_NOTIFICATIONS,
                                                        okButtonText: LS_ALLOW_NOTIFICATIONS_OK_LET_ME_ALLOW,
                                                        cancelButtonText: LS_ALLOW_NOTIFICATIONS_NOT_NOW,
                                                        okAction: {
                                                            UserNotificationHandler.sharedHandler.initialSetup(then: {
                                                                handler?()
                                                            })
                                                        },
                                                        cancelAction: {
                                                            handler?()
                                                        })
                    askPermissionVC.modalPresentationStyle = .fullScreen
                    self.present(askPermissionVC, animated: true, completion: {
                        self.mask?.removeFromSuperview()
                    })
                }
            })
            
        }, else: {
            // User has authorized before
            DispatchQueue.main.async {
                self.mask?.removeFromSuperview()
                handler?()
            }
        })
    }
    
    private func showAlertNewGame(onOK: (() -> Void)?) {
        
        let askConfirmationVC = SimpleAlertVC(titleText: LS_WARNINGNEWGAME_TITLE, text: LS_WARNING_NEWGAME_GAMERUNNING, okButtonText: LS_BUTTON_YES, cancelButtonText: LS_BUTTON_NO, okAction: {
            onOK?()
        }, cancelAction: nil)
        
        DispatchQueue.main.async {
            self.present(askConfirmationVC, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Public Methods
    
    func scoreDidChange() {
        
        if existingTimerVC == nil, let scoreVC = viewControllers?.first as? ScoreVC {
            let timerVC = TimerVC(pageVC: self)
            timerVC.delegate = scoreVC
            timerVC.game = game
            existingTimerVC = timerVC
        }
        existingTimerVC?.scoreDidChange()
    }
    
    func showBackgroundMask() {
        
        backgroundMask.alpha = 1.0
    }
    
    func hideBackgroundMask() {
        
        backgroundMask.alpha = 0.0
    }
    
    
    // MARK: - Touch
    
    @objc private func newGameTapped() {
        
        guard let existingTimerVC = existingTimerVC, existingTimerVC.game.status != .WaitingToStart else {
            return
        }
        showAlertNewGame(onOK: {
            self.existingTimerVC?.handleConfirmationNewGame()
        })
    }
    
    @objc private func checkDarkMode() {
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings) {
            overrideUserInterfaceStyle = .unspecified
        } else if UserDefaults.standard.bool(forKey: UserDefaultsKey.AlwaysDarkMode) {
            overrideUserInterfaceStyle = .dark
        } else if UserDefaults.standard.bool(forKey: UserDefaultsKey.AlwaysLightMode) {
            overrideUserInterfaceStyle = .light
        }
        view.setNeedsLayout()
    }
        
    @objc private func gameStatusChanged() {
        
        guard newGameButton != nil else {
            return
        }
        let alpha: CGFloat = (game.status == .WaitingToStart) ? 0.0 : 1.0
        UIView.animate(withDuration: 0.2) {
            self.newGameButton.alpha = alpha
        }
    }
}

extension PageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var nextVC: PanArrowVC? = nil
        
        if let timerVC = viewController as? TimerVC {
            existingTimerVC = timerVC
            if existingScoreVC == nil  {
                let scoreVC = ScoreVC(game: game, pageVC: self)
                scoreVC.pageVC = self
                timerVC.delegate = scoreVC
                existingScoreVC = scoreVC
            }
            nextVC = existingScoreVC
            
        }
        
        return nextVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var earlierVC: UIViewController? = nil
        
        if let scoreVC = viewController as? ScoreVC {
            if existingTimerVC == nil {
                let timerVC = TimerVC(pageVC: self)
                timerVC.delegate = scoreVC
                timerVC.game = game
                existingTimerVC = timerVC
            }
            earlierVC = existingTimerVC
        }
        
        return earlierVC
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
    }
    
}


extension PageVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let _ = pageViewController.viewControllers?.first as? TimerVC, let scoreVC = pendingViewControllers.first as? ScoreVC {
            view.backgroundColor = scoreVC.view.backgroundColor
        } else if let _ = pageViewController.viewControllers?.first as? ScoreVC, let timerVC = pendingViewControllers.first as? TimerVC {
            view.backgroundColor = timerVC.view.backgroundColor
        }
        
        prepareHapticIfNeeded()
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        view.backgroundColor = viewControllers?.first?.view.backgroundColor
        
        haptic?.selectionChanged()
        haptic = nil
    }
    
    
    // MARK: - Haptic
    
    private func prepareHapticIfNeeded() {
        
        if haptic == nil {
            haptic = UISelectionFeedbackGenerator()
            haptic!.prepare()
        }
    }
}


extension PageVC: CircularFABDelegate {
    
    func itemButtonTapped(buttonNumber: Int) {
        
        switch buttonNumber {
        case 0:
            gameTimeButtonTapped()
        case 1:
            rulesButtonTapped()
        case 2:
            settingsButtonTapped()
        default:
            fatalError("Trying to handle a circularFAB button exceeding 3 items")
        }
    }
    
    private func gameTimeButtonTapped() {
        
        let currentGameRunning = (game.status != .WaitingToStart)
        let vc = GameTimeVC(currentPeriods: game.periods, currentTotalMinutes: game.totalMinutes, currentGameRunning: currentGameRunning, onDismiss: { (totalMinutes, periods) in
            
            guard totalMinutes != nil || periods != nil else {
                return
            }
            let newMinutes = totalMinutes ?? self.game.totalMinutes
            let newPeriods = periods ?? self.game.periods
            UserDefaults.standard.set(newMinutes, forKey: UserDefaultsKey.Minutes)
            UserDefaults.standard.set(newPeriods, forKey: UserDefaultsKey.Periods)
            self.game = HockeyGame(minutes: newMinutes, periods: newPeriods)
            NotificationCenter.default.post(name: .NewGame, object: nil)
        })
        present(vc, animated: true, completion: nil)
    }
    
    private func rulesButtonTapped() {
        
        let vc = RulesVC(onDismiss: nil)
        present(vc, animated: true, completion: nil)
    }
    
    private func settingsButtonTapped() {
        
        let vc = MenuVC()
        present(vc, animated: true, completion: nil)
    }
}

