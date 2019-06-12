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
    
    fileprivate var askToNotificationsAlreadyShown: Bool = false
    fileprivate var haptic: UISelectionFeedbackGenerator?
    
    
    // MARK: - Init

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if UserDefaults.standard.bool(forKey: USERDEFAULTSKEY.ShouldNotOnboard) {
            view.backgroundColor = COLOR.VeryDarkBlue
        } else {
            view.backgroundColor = COLOR.White // should be same color as underlying onboarding screens
        }
        
        var duration: Duration = SELECTED_COUNTRY.durations.randomElement()!
        if UserDefaults.standard.bool(forKey: USERDEFAULTSKEY.PremiumMode), let minutes = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.Duration) as? Int {
            if let enumCase = Duration(rawValue: minutes) {
                duration = enumCase
            }
        }
        game = HockeyGame(duration: duration)
        
        let startVC = TimerVC(pageVC: self)
        setViewControllers([startVC], direction: .forward, animated: false, completion: nil)
        
        backgroundMask = UIView()
        backgroundMask.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        backgroundMask.frame = view.bounds
        view.addSubview(backgroundMask)
        view.sendSubviewToBack(backgroundMask)
        hideBackgroundMask()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if !askToNotificationsAlreadyShown {
            mask = Mask(color: COLOR.VeryDarkBlue, inView: view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        askToAllowNotifications()
    }
    
    
    // MARK: - Private Methods
    
    private func askToAllowNotifications() {
        
        guard !askToNotificationsAlreadyShown else {
            mask?.removeFromSuperview()
            return
        }
        askToNotificationsAlreadyShown = true
        
        UserNotificationHandler.sharedHandler.ifNotAuthorized(then: {
            
            // User has denied notifications before
            // Allowing notification will not prompt user
            UserNotificationHandler.sharedHandler.ifAuthorizationIsDenied(then: {
                let askPermissionVC = SimpleAlertVC(titleText: LS_ALLOW_NOTIFICATIONS_TITLE,
                                                    text: LS_ALLOW_NOTIFICATIONS_GO_TO_SETTINGS,
                                                    okButtonText: LS_BUYPREMIUM_OK)
                DispatchQueue.main.async {
                    self.present(askPermissionVC, animated: true, completion: {
                        self.mask?.removeFromSuperview()
                    })
                }
                
            }, else: {
                // User has not denied before
                // Ask for notifications will prompt user
                let askPermissionVC = SimpleAlertVC(titleText: LS_ALLOW_NOTIFICATIONS_TITLE,
                                                    text: LS_ALLOW_NOTIFICATIONS_ALLOW_NOTIFICATIONS,
                                                    okButtonText: LS_ALLOW_NOTIFICATIONS_OK_LET_ME_ALLOW,
                                                    cancelButtonText: LS_ALLOW_NOTIFICATIONS_NOT_NOW,
                                                    okAction: {
                                                        UserNotificationHandler.sharedHandler.initialSetup()
                })
                DispatchQueue.main.async {
                    self.present(askPermissionVC, animated: true, completion: {
                        self.mask?.removeFromSuperview()
                    })
                }
            })
            
        }, else: {
            // User has authorized before
            DispatchQueue.main.async {
                self.mask?.removeFromSuperview()
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
        
        if let timerVC = viewController as? TimerVC {
            let durationVC = DurationVC(pageVC: self)
            durationVC.currentDuration = timerVC.game.duration
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
        
        if let timerVC = pageViewController.viewControllers?.first as? TimerVC, let durationVC = pendingViewControllers.first as? DurationVC {
            view.backgroundColor = COLOR.White
            durationVC.currentDuration = timerVC.game.duration
            durationVC.selectedDuration = nil
            
        } else if let durationVC = pageViewController.viewControllers?.first as? DurationVC, let timerVC = pendingViewControllers.first as? TimerVC {
            if durationVC.selectedDuration != nil && timerVC.game.duration != durationVC.selectedDuration {
                UserDefaults.standard.set(durationVC.selectedDuration!.rawValue, forKey: USERDEFAULTSKEY.Duration)
                game = HockeyGame(duration: durationVC.selectedDuration!)
                NotificationCenter.default.post(name: .NewGame, object: nil)
            }
            
        } else if let _ = pageViewController.viewControllers?.first as? ScoreVC, let _ = pendingViewControllers.first as? DocumentMenuVC {
            view.backgroundColor = COLOR.Olive
        }
        
        if let documentVC = pageViewController.viewControllers?.first as? DocumentMenuVC {
            documentVC.hideMenus()
        }
        
        prepareHapticIfNeeded()
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        haptic?.selectionChanged()
        haptic = nil
        
        if let viewControllers = viewControllers, !viewControllers.isEmpty, let documentVC = viewControllers[0] as? DocumentMenuVC {
            documentVC.animateFlyIn()
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

