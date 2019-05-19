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
    
    var game: HockeyGame!
    var existingTimerVC: TimerVC?
    var existingScoreVC: ScoreVC?
    fileprivate var haptic: UISelectionFeedbackGenerator?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = COLOR.White // should be same color as onboarding screens
        
        var duration: MINUTESINHALF = MINUTESINHALF.allCases.randomElement()!
        if UserDefaults.standard.bool(forKey: USERDEFAULTSKEY.PremiumMode), let minutes = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.Duration) as? Int {
            if let enumCase = MINUTESINHALF(rawValue: minutes) {
                duration = enumCase
            }
        }
        game = HockeyGame(duration: duration)
        
        let startVC = TimerVC(pageVC: self)
        setViewControllers([startVC], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.value(forKey: USERDEFAULTSKEY.PermissionGrantedNotifications) == nil {
            
            let askPermissionVC = SimpleAlertVC(titleText: "Allow Notifications",
                                                text: "DimpleBall will send you a notification when the hockey game ends. You should enable Notifications to get this warning.",
                                                okButtonText: "OK, allow",
                                                cancelButtonText: "Not now") { (confirmed) in
                                                    if confirmed {
                                                        UserNotificationHandler.sharedHandler.initialSetup()
                                                    }
            }
            askPermissionVC.modalPresentationStyle = .overCurrentContext
            askPermissionVC.modalTransitionStyle = .crossDissolve
            present(askPermissionVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Public Methods
    
    func scoreDidChange() {
        
        print("PageVC.scoreDidChange")
        
        if existingTimerVC == nil, let scoreVC = viewControllers?.first as? ScoreVC {
            let timerVC = TimerVC(pageVC: self)
            timerVC.delegate = scoreVC
            timerVC.game = game
            existingTimerVC = timerVC
        }
        existingTimerVC?.scoreDidChange()
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
        
        if let durationVC = pendingViewControllers.first as? DurationVC, let timerVC = pageViewController.viewControllers?.first as? TimerVC {
            durationVC.currentDuration = timerVC.game.duration
            durationVC.selectedDuration = nil
            
        } else if let timerVC = pendingViewControllers.first as? TimerVC, let durationVC = pageViewController.viewControllers?.first as? DurationVC {
            if durationVC.selectedDuration != nil && timerVC.game.duration != durationVC.selectedDuration {
                UserDefaults.standard.set(durationVC.selectedDuration!.rawValue, forKey: USERDEFAULTSKEY.Duration)
                game = HockeyGame(duration: durationVC.selectedDuration!)
                NotificationCenter.default.post(name: .NewGame, object: nil)
            }
        }
        prepareHapticIfNeeded()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if #available(iOS 10.0, *) {
            haptic?.selectionChanged()
            haptic = nil
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(1519))
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

