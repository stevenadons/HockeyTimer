//
//  OnboardingVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 10/09/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController {

    
    // MARK: - Properties
    
    fileprivate var pageControl: UIPageControl!
    fileprivate var dismissButton: UIButton!
    fileprivate var scrollView: UIScrollView!
    fileprivate var slide1: OnboardScreen!
    fileprivate var slide2: OnboardScreen!
    fileprivate var stopWatch: StopWatch!
    fileprivate var pitch: Pitch!
    fileprivate var previousPage: Int = 0
    fileprivate let numberOfPages: Int = 2
    fileprivate var shouldShowButton: Bool = false
    
    fileprivate let SCREENWIDTH = UIScreen.main.bounds.size.width
    fileprivate let SCREENHEIGHT = UIScreen.main.bounds.size.height
    
    
    // MARK: - Public methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setup()
        setupSlides()
    }
    
    private func setup() {
        
        view.backgroundColor = COLOR.White
        
        scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.backgroundColor = UIColor.clear
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = previousPage
        pageControl.pageIndicatorTintColor = COLOR.DarkBlue
        pageControl.currentPageIndicatorTintColor = COLOR.LightYellow
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        dismissButton = UIButton()
        dismissButton.backgroundColor = UIColor.orange
        dismissButton.addTarget(self, action: #selector(handleDismiss(sender:)), for: [.touchUpInside])
        dismissButton.alpha = 0.0
        dismissButton.backgroundColor = UIColor.clear
        dismissButton.titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 14)
        dismissButton.setTitleColor(COLOR.VeryDarkBlue, for: .normal)
        dismissButton.setTitle(LS_BUTTON_ONBOARDDISMISS, for: .normal)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            
            pageControl.widthAnchor.constraint(equalToConstant: 50),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 35),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            dismissButton.widthAnchor.constraint(equalToConstant: 130),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 35),
            dismissButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -10),
            
            ])
        
    }
    
    private func setupSlides() {
        
        slide1 = OnboardScreen()
        slide1.backgroundColor = COLOR.White
        slide1.title.text = LS_TITLE_ONBOARDINGSLIDE1
        slide1.body.text = LS_BODY_ONBOARDINGSLIDE1
        scrollView.addSubview(slide1)
        
        stopWatch = StopWatch()
        stopWatch.simplifyForOnboarding(bgColor: COLOR.White, iconColor: COLOR.LightYellow, timeColor: COLOR.VeryDarkBlue, progressZoneColor: COLOR.DarkBlue)
        slide1.graphics.addSubview(stopWatch)
        
        slide2 = OnboardScreen()
        slide2.backgroundColor = COLOR.White
        slide2.title.text = LS_TITLE_ONBOARDINGSLIDE2
        slide2.body.text = LS_BODY_ONBOARDINGSLIDE2
        scrollView.addSubview(slide2)
        
        pitch = Pitch()
        pitch.simplifyForOnboarding()
        slide2.graphics.addSubview(pitch)
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: SCREENWIDTH * CGFloat(numberOfPages), height: scrollView.frame.size.height)
        slide1.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        setStopWatchFrame()
        slide2.frame = CGRect(x: SCREENWIDTH, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        setPitchFrame()
        view.bringSubview(toFront: pageControl)
        view.bringSubview(toFront: dismissButton)
    }
    
    private func setStopWatchFrame() {
        
        let graphicsSide = min(slide1.graphics.bounds.width, slide1.graphics.bounds.height)
        let stopWatchSide = min(graphicsSide, 180)
        let xInset = (slide1.graphics.bounds.width - stopWatchSide) / 2.0
        let yInset = (slide1.graphics.bounds.height - stopWatchSide) / 2.0
        stopWatch.frame = slide1.graphics.bounds.insetBy(dx: xInset, dy: yInset)
    }
    
    private func setPitchFrame() {
        
        NSLayoutConstraint.activate([
            
            pitch.widthAnchor.constraint(equalTo: slide2.widthAnchor, constant: -100),
            pitch.heightAnchor.constraint(equalToConstant: 180),
            pitch.centerXAnchor.constraint(equalTo: slide2.centerXAnchor),
            pitch.bottomAnchor.constraint(equalTo: slide2.centerYAnchor),
            
            ])
    }
    
    
    // MARK: - Touch methods
    
    @objc private func handleDismiss(sender: UIButton) {
        
        UserDefaults.standard.set("AppWasLaunchedBefore", forKey: USERDEFAULTSKEY.StartViewController)
        
        let startViewController = PageVC(transitionStyle: .scroll, navigationOrientation: .vertical)
        startViewController.modalTransitionStyle = .crossDissolve
        present(startViewController, animated: true, completion: nil)
    }

}


extension OnboardingVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Update page when more than 50% of next or previous page is visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth)) + 1
        pageControl.currentPage = page
        pageChanged(page: page)
        
        // When new page is full screen or no screen
        if scrollView.contentOffset.x == pageWidth {
            pitch.animateScoreOnboarding(completion: {
                self.showButton()
            })
        } else if scrollView.contentOffset.x == 0 {
            pitch.simplifyForOnboarding()
        }
    }
    
    
    func pageChanged(page: Int) {
        
        guard pageControl.currentPage != previousPage else { return }
        
        switch pageControl.currentPage {
        case 0:
            hideButton()
        case 1:
            print("no action")
        default:
            print("Error - Flipped to other page")
        }
        
        previousPage = pageControl.currentPage
    }
    
    
    func showButton() {
        
        shouldShowButton = true
        UIView.animate(withDuration: 0.4, delay: 0.3, options: [.curveEaseIn], animations: {
            guard self.shouldShowButton else { return }
            self.dismissButton.alpha = 1.0
        })
    }
    
    
    func hideButton() {
        
        shouldShowButton = false
        dismissButton.alpha = 0.0
    }
}
