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
    
    var game: HockeyGame!
    var existingTimerVC: TimerVC?
    var existingScoreVC: ScoreVC?
    private var mask: Mask?
    private var backgroundMask: UIView!
    
    private var messageManager: RemoteMessageManager!
    private var updateManager: UpdateManager!
    private var minimumIOSManager: MinimumIOSVersionManager!
    
    fileprivate var askToNotificationsAlreadyShown: Bool = false
    fileprivate var haptic: UISelectionFeedbackGenerator?
    
    
    // MARK: - Init

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if UserDefaults.standard.bool(forKey: USERDEFAULTSKEY.ShouldNotOnboard) {
            view.backgroundColor = UIColor(named: "VeryDarkBlue")!
        } else {
            view.backgroundColor = UIColor.white // should be same color as underlying onboarding screens
        }
        
        var duration: Duration = SELECTED_COUNTRY.durations.randomElement()!
        if UserDefaults.standard.bool(forKey: USERDEFAULTSKEY.PremiumMode), let minutes = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.Duration) as? Int {
            if let enumCase = Duration(rawValue: minutes) {
                duration = enumCase
            }
        }
        var numberOfPeriods: NumberOfPeriods = .Halves
        if let savedNumberOfPeriods = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.NumberOfPeriods) as? Int {
            if let enumCase = NumberOfPeriods(rawValue: savedNumberOfPeriods) {
                numberOfPeriods = enumCase
            }
        }
        game = HockeyGame(duration: duration, numberOfPeriods: numberOfPeriods)
        print("PageVC did set game with numberOfPeriods: \(numberOfPeriods)")
        
        let startVC = TimerVC(pageVC: self)
        setViewControllers([startVC], direction: .forward, animated: false, completion: nil)
        
        backgroundMask = UIView()
        backgroundMask.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        backgroundMask.frame = view.bounds
        view.addSubview(backgroundMask)
        view.sendSubviewToBack(backgroundMask)
        hideBackgroundMask()
        
        messageManager = RemoteMessageManager(fromViewcontroller: self, messageURL: "https://raw.githubusercontent.com/stevenadons/RemoteJSON/master/hockeyUppMessage")
        updateManager = UpdateManager(fromViewcontroller: self, appURL: "https://itunes.apple.com/app/apple-store/id1464432452?mt=8")
        minimumIOSManager = MinimumIOSVersionManager(fromViewcontroller: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if !askToNotificationsAlreadyShown {
            mask = Mask(color: UIColor(named: "VeryDarkBlue")!, inView: view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        
        askToAllowNotifications(then: { [weak self] in
            self?.messageManager.showMessage(then: { [weak self] in
                self?.updateManager.showUpdate(style: .alert, then: { [weak self] in
                    self?.minimumIOSManager.checkIOSVersion(then: nil)
                })
            })
        })
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
}

extension PageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var nextVC: PanArrowVC? = nil
        
        if let _ = viewController as? DurationVC {
            if existingTimerVC == nil {
                existingTimerVC = TimerVC(pageVC: self)
            }
            nextVC = existingTimerVC
            
        } else if let timerVC = viewController as? TimerVC {
            existingTimerVC = timerVC
            if existingScoreVC == nil  {
                let scoreVC = ScoreVC(game: game)
                scoreVC.pageVC = self
                timerVC.delegate = scoreVC
                existingScoreVC = scoreVC
            }
            nextVC = existingScoreVC
            
        } else if let scoreVC = viewController as? ScoreVC {
            existingScoreVC = scoreVC
            nextVC = DocumentMenuVC(pageVC: self)
        }
        
        return nextVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var earlierVC: UIViewController? = nil
        
        if let _ = viewController as? TimerVC {
            let durationVC = DurationVC(pageVC: self)
            earlierVC = durationVC
            
        } else if let scoreVC = viewController as? ScoreVC {
            if existingTimerVC == nil {
                let timerVC = TimerVC(pageVC: self)
                timerVC.delegate = scoreVC
                timerVC.game = game
                existingTimerVC = timerVC
            }
            earlierVC = existingTimerVC
            
        } else if let _ = viewController as? DocumentMenuVC {
            if existingScoreVC == nil {
                let scoreVC = ScoreVC(game: game)
                scoreVC.pageVC = self
                scoreVC.game = game
                existingScoreVC = scoreVC
            }
            earlierVC = existingScoreVC
        }
        
        return earlierVC
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return 4
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
    }
    
}


extension PageVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let documentVC = pageViewController.viewControllers?.first as? DocumentMenuVC {
            documentVC.hideMenus()
        }
        
        if let _ = pageViewController.viewControllers?.first as? TimerVC, let durationVC = pendingViewControllers.first as? DurationVC {
            
            // From TimerVC to DurationVC
            view.backgroundColor = UIColor.white
            durationVC.selectedDuration = nil
            durationVC.selectedNumberOfPeriods = nil
            
        } else if let durationVC = pageViewController.viewControllers?.first as? DurationVC, let timerVC = pendingViewControllers.first as? TimerVC {
            
            // From DurationVC to TimerVC
            if durationVC.selectedDuration != nil && timerVC.game.duration != durationVC.selectedDuration {
                // Duration changed
                UserDefaults.standard.set(durationVC.selectedDuration!.rawValue, forKey: USERDEFAULTSKEY.Duration)
                if durationVC.selectedNumberOfPeriods != nil && timerVC.game.numberOfPeriods != durationVC.selectedNumberOfPeriods {
                    // Number of Periods also changed
                    UserDefaults.standard.set(durationVC.selectedNumberOfPeriods!.rawValue, forKey: USERDEFAULTSKEY.NumberOfPeriods)
                    game = HockeyGame(duration: durationVC.selectedDuration!, numberOfPeriods: durationVC.selectedNumberOfPeriods!)
                } else {
                    // Only Duration changed
                    game = HockeyGame(duration: durationVC.selectedDuration!, numberOfPeriods: game.numberOfPeriods)
                }
                NotificationCenter.default.post(name: .NewGame, object: nil)
            } else if durationVC.selectedNumberOfPeriods != nil && timerVC.game.numberOfPeriods != durationVC.selectedNumberOfPeriods {
                // Only Number of Periods changed
                UserDefaults.standard.set(durationVC.selectedNumberOfPeriods!.rawValue, forKey: USERDEFAULTSKEY.NumberOfPeriods)
                game = HockeyGame(duration: timerVC.game.duration, numberOfPeriods: durationVC.selectedNumberOfPeriods!)
                NotificationCenter.default.post(name: .NewGame, object: nil)
            }
            
        } else if let _ = pageViewController.viewControllers?.first as? ScoreVC, let _ = pendingViewControllers.first as? DocumentMenuVC {
            view.backgroundColor = UIColor(named: "Olive")
        }
        
        prepareHapticIfNeeded()
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        haptic?.selectionChanged()
        haptic = nil
        
        // To DocumentMenuVC
        if let viewControllers = viewControllers, !viewControllers.isEmpty, let documentVC = viewControllers[0] as? DocumentMenuVC {
            documentVC.animateFlyIn()
        }
        
        // Away from DurationVC
        if !previousViewControllers.isEmpty, let durationVC = previousViewControllers[0] as? DurationVC {
            durationVC.clearSelectedDuration()
        }
        
    }
    
    
    // MARK: - Haptic
    
    private func prepareHapticIfNeeded() {
        
        guard #available(iOS 10.0, *) else { return }
        if haptic == nil {
            haptic = UISelectionFeedbackGenerator()
            haptic!.prepare()
        }
    }
}

