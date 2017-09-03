//
//  PageVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


// Set this PageVC as initial viewcontroller in AppDelegate
class PageVC: UIPageViewController {

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
        
        if viewController.isKind(of: DurationVC.self) {
            nextVC = TimerVC(pageVC: self)
        } else if viewController.isKind(of: TimerVC.self) {
            if let timerVC = viewController as? TimerVC {
                nextVC = ScoreVC(game: timerVC.game)
                nextVC?.pageVC = self
                timerVC.delegate = nextVC as! TimerVCDelegate?
            }
        } else if viewController.isKind(of: ScoreVC.self) {
            nextVC = DocumentMenuVC(pageVC: self)
        }
        return nextVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var earlierVC: UIViewController? = nil
        if viewController.isKind(of: TimerVC.self) {
            if let timerVC = viewController as? TimerVC {
                earlierVC = DurationVC(pageVC: self)
                if let durationVC = earlierVC as? DurationVC {
                    durationVC.onCardTapped = { timerVC.resetWithNewGame() }
                }
            }
        } else if viewController.isKind(of: ScoreVC.self) {
            earlierVC = TimerVC(pageVC: self)
        } else if viewController.isKind(of: DocumentMenuVC.self) {
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
    
}

