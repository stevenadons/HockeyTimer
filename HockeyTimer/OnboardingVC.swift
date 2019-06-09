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
    fileprivate var slide3: OnboardScreen!
    fileprivate var stopWatch: StopWatch!
    fileprivate var pitch: Pitch!
    fileprivate var phoneView: PhoneView!
    fileprivate var previousPage: Int = 0
    fileprivate let numberOfPages: Int = 3
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
        dismissButton.titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 16)
        dismissButton.setTitleColor(COLOR.DarkBlue, for: .normal)
        dismissButton.setTitle(LS_BUTTON_ONBOARDDISMISS, for: .normal)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dismissButton)
        
        let dismissButtonConstant = UIDevice.whenDeviceIs(small: 10, normal: 30, big: 30)
        
        NSLayoutConstraint.activate([
            
            pageControl.widthAnchor.constraint(equalToConstant: 50),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 35),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            dismissButton.widthAnchor.constraint(equalToConstant: 130),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 35),
            dismissButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -dismissButtonConstant),
            
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
        
        slide3 = OnboardScreen()
        slide3.backgroundColor = COLOR.White
        slide3.title.text = LS_TITLE_ONBOARDINGSLIDE3
        slide3.body.text = LS_BODY_ONBOARDINGSLIDE3
        scrollView.addSubview(slide3)
        
        phoneView = PhoneView()
        slide3.graphics.addSubview(phoneView)
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: SCREENWIDTH * CGFloat(numberOfPages), height: scrollView.frame.size.height)
        slide1.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        setStopWatchFrame()
        slide2.frame = CGRect(x: SCREENWIDTH, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        setPitchFrame()
        slide3.frame = CGRect(x: SCREENWIDTH * 2, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        setPhoneViewFrame()
        view.bringSubviewToFront(pageControl)
        view.bringSubviewToFront(dismissButton)
    }
    
    private func setStopWatchFrame() {
        
        let graphicsSide = min(slide1.graphics.bounds.width, slide1.graphics.bounds.height)
        let stopWatchSide = min(graphicsSide, 180)
        let xInset = (slide1.graphics.bounds.width - stopWatchSide) / 2.0
        let yInset = (slide1.graphics.bounds.height - stopWatchSide) / 2.0
        let insets = UIEdgeInsets(top: yInset * 0.75, left: xInset, bottom: yInset * 1.25, right: xInset)
        stopWatch.frame = slide1.graphics.bounds.inset(by: insets)
    }
    
    private func setPitchFrame() {
        
        NSLayoutConstraint.activate([
            pitch.widthAnchor.constraint(equalToConstant: 275),
            pitch.heightAnchor.constraint(equalToConstant: 180),
            pitch.centerXAnchor.constraint(equalTo: slide2.graphics.centerXAnchor),
            pitch.centerYAnchor.constraint(equalTo: slide2.graphics.centerYAnchor, constant: -20),
            ])
    }
    
    private func setPhoneViewFrame() {
        
        NSLayoutConstraint.activate([
            phoneView.widthAnchor.constraint(equalTo: slide3.graphics.widthAnchor),
            phoneView.heightAnchor.constraint(equalTo: slide3.graphics.heightAnchor),
            phoneView.centerXAnchor.constraint(equalTo: slide3.graphics.centerXAnchor),
            phoneView.centerYAnchor.constraint(equalTo: slide3.graphics.centerYAnchor, constant: -20),
            ])
    }
    
    
    // MARK: - Touch methods
    
    @objc private func handleDismiss(sender: UIButton) {
        
        UserDefaults.standard.set(USERDEFAULTSKEY.ShouldNotOnboard, forKey: USERDEFAULTSKEY.ShouldNotOnboard)
        
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
            pitch.animateScoreOnboarding(completion: nil)
        } else if scrollView.contentOffset.x != 1 {
            pitch.simplifyForOnboarding()
        }
        if scrollView.contentOffset.x == pageWidth * 2 {
            showButton()
        }
    }
    
    
    func pageChanged(page: Int) {
        
        guard pageControl.currentPage != previousPage else { return }
        
        switch pageControl.currentPage {
        case 0:
            hideButton()
        case 1:
            hideButton()
        case 2:
            print("no action")
        default:
            print("Error - Flipped to other page")
        }
        
        previousPage = pageControl.currentPage
    }
    
    
    func showButton() {
        
        shouldShowButton = true
        UIView.animate(withDuration: 0.15, delay: 0.15, options: [.curveEaseIn], animations: {
            guard self.shouldShowButton else { return }
            self.dismissButton.alpha = 1.0
        })
    }
    
    
    func hideButton() {
        
        shouldShowButton = false
        dismissButton.alpha = 0.0
    }
}
