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
    
    fileprivate var haptic: UISelectionFeedbackGenerator?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = COLOR.White // should be same color as onboarding screens
        
        let startVC = TimerVC(pageVC: self)
        setViewControllers([startVC], direction: .forward, animated: false, completion: nil)
    }

}

extension PageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var nextVC: PanArrowVC? = nil
        if let _ = viewController as? DurationVC {
            nextVC = TimerVC(pageVC: self)
        } else if let timerVC = viewController as? TimerVC {
            let scoreVC = ScoreVC(game: timerVC.game)
            scoreVC.pageVC = self
            timerVC.delegate = scoreVC
            nextVC = scoreVC
        } else if let _ = viewController as? ScoreVC {
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
        } else if let _ = viewController as? ScoreVC {
            earlierVC = TimerVC(pageVC: self)
        } else if let _ = viewController as? DocumentMenuVC {
            earlierVC = ScoreVC(pageVC: self)
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
        
        if let durationVC = pendingViewControllers.first as? DurationVC, let timerVC = pageViewController.viewControllers?.first as? TimerVC { durationVC.currentDuration = timerVC.game.duration
        } else if let timerVC = pendingViewControllers.first as? TimerVC, let durationVC = pageViewController.viewControllers?.first as? DurationVC {
            if durationVC.selectedDuration != nil {
                UserDefaults.standard.set(durationVC.selectedDuration!.rawValue, forKey: USERDEFAULTSKEY.Duration)
                timerVC.resetWithNewGame()
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

