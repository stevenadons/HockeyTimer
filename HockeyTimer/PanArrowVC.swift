//
//  PanArrowVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PanArrowVC: UIViewController {

    
    // MARK: - Properties

    var panArrowUp: PanArrow!
    var panArrowDown: PanArrow!
    var panArrowUpLabel: UILabel!
    var panArrowDownLabel: UILabel!
    var menuButton: TopButton!
    
    private var panArrowDownLabelPadding: CGFloat = 2
    
    weak var pageVC: PageVC?

    
    // MARK: - Life Cycle Methods
    
    convenience init(pageVC: PageVC) {
        
        self.init()
        self.pageVC = pageVC
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if !FeatureFlags.darkModeCanBeEnabled {
            overrideUserInterfaceStyle = .light
        }
        
        panArrowUp = PanArrow()
        view.addSubview(panArrowUp)
        
        panArrowDown = PanArrow()
        panArrowDown.transform = CGAffineTransform(rotationAngle: .pi)
        view.addSubview(panArrowDown)
        
        panArrowUpLabel = PanArrowLabelFactory.standardLabel(text: "Foo",
                                                             textColor: UIColor(named: ColorName.OliveText)!,
                                                             fontStyle: .headline,
                                                             textAlignment: .center,
                                                             sizeToFit: false,
                                                             adjustsFontSizeToFitWidth: true)
        view.addSubview(panArrowUpLabel)
        
        panArrowDownLabel = PanArrowLabelFactory.standardLabel(text: "Foo",
                                                               textColor: UIColor(named: ColorName.OliveText)!,
                                                               fontStyle: .headline,
                                                               textAlignment: .center,
                                                               sizeToFit: false,
                                                               adjustsFontSizeToFitWidth: true)
        view.addSubview(panArrowDownLabel)
        
        panArrowUp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(upTapped(sender:))))
        panArrowUpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(upTapped(sender:))))
        
        panArrowDown.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(downTapped(sender:))))
        panArrowDownLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(downTapped(sender:))))
        
        menuButton = TopButton(imageName: "line.horizontal.3", tintColor: .white)
        menuButton.addTarget(self, action: #selector(menuButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(menuButton)
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let arrowPaddingTop: CGFloat = 16
        let arrowPaddingBottom: CGFloat = 18
        
        let menuButtonHorInset: CGFloat = UIDevice.whenDeviceIs(small: 28, normal: 32, big: 32)
        let menuButtonBottomInset: CGFloat = UIDevice.whenDeviceIs(small: 8, normal: 22, big: 22)
        
        NSLayoutConstraint.activate([
            
            panArrowUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panArrowUp.widthAnchor.constraint(equalToConstant: 44),
            panArrowUp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: arrowPaddingTop),
            panArrowUp.heightAnchor.constraint(equalToConstant: 22),
            
            panArrowUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panArrowUpLabel.widthAnchor.constraint(equalToConstant: 100),
            panArrowUpLabel.topAnchor.constraint(equalTo: panArrowUp.bottomAnchor),
            panArrowUpLabel.heightAnchor.constraint(equalToConstant: 20),
            
            panArrowDown.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panArrowDown.widthAnchor.constraint(equalToConstant: 44),
            panArrowDown.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -arrowPaddingBottom),
            panArrowDown.heightAnchor.constraint(equalToConstant: 22),
            
            panArrowDownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panArrowDownLabel.widthAnchor.constraint(equalToConstant: 100),
            panArrowDownLabel.bottomAnchor.constraint(equalTo: panArrowDown.topAnchor, constant: -panArrowDownLabelPadding),
            panArrowDownLabel.heightAnchor.constraint(equalToConstant: 20),
            
            menuButton.widthAnchor.constraint(equalToConstant: menuButton.standardWidth),
            menuButton.heightAnchor.constraint(equalToConstant: menuButton.standardHeight),
            menuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -menuButtonBottomInset),
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -menuButtonHorInset),
            
            ])
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func upTapped(sender: UITapGestureRecognizer) {
        
        guard let pageVC = pageVC, let upVC = pageVC.pageViewController(pageVC, viewControllerBefore: self) else { return }
        pageVC.pageViewController(pageVC, willTransitionTo: [upVC])
        pageVC.setViewControllers([upVC], direction: .reverse, animated: true, completion: nil)
    }
    
    @objc private func downTapped(sender: UITapGestureRecognizer) {

        guard let pageVC = pageVC, let downVC = pageVC.pageViewController(pageVC, viewControllerAfter: self) else { return }
        pageVC.pageViewController(pageVC, willTransitionTo: [downVC])
        pageVC.setViewControllers([downVC], direction: .forward, animated: true, completion: nil)
    }
    
    @objc private func menuButtonTapped(sender: TopButton, forEvent event: UIEvent) {
        
        let vc = MenuVC(titleText: "Settings")
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Public Methods
    
    func liftPanArrowDownLabelUp() {
        
        panArrowDownLabelPadding = 8
        
    }

}
