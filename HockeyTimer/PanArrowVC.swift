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
    var gameTimeButton: TopButton!
    var menuButton: TopButton!
    var rulesButton: TopButton!
    
    private var panArrowDownLabelPadding: CGFloat = 2
    
    weak var pageVC: PageVC?

    
    // MARK: - Life Cycle Methods
    
    convenience init(pageVC: PageVC) {
        
        self.init()
        self.pageVC = pageVC
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        checkDarkMode()
        addObservers()
        
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
        
        gameTimeButton = TopButton(imageName: "timer", tintColor: .white)
        gameTimeButton.addTarget(self, action: #selector(gameTimeButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(gameTimeButton)
        
        menuButton = TopButton(imageName: "line.horizontal.3", tintColor: .white)
        menuButton.addTarget(self, action: #selector(menuButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(menuButton)
        
        rulesButton = TopButton(imageName: "doc.plaintext", tintColor: .white)
        rulesButton.addTarget(self, action: #selector(rulesButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(rulesButton)
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let arrowPaddingTop: CGFloat = 16
        let arrowPaddingBottom: CGFloat = 18
        
        let iconHorInset: CGFloat = UIDevice.whenDeviceIs(small: 24, normal: 28, big: 28)
        let iconBottomInset: CGFloat = UIDevice.whenDeviceIs(small: 8, normal: 22, big: 22)
        let buttonWidth: CGFloat = 44
        let buttonHeight: CGFloat = 44
        let buttonTopInset: CGFloat = UIDevice.whenDeviceIs(small: 0, normal: 12, big: 12)
        
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
            
            gameTimeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: iconHorInset),
            gameTimeButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            gameTimeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: buttonTopInset),
            gameTimeButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            menuButton.widthAnchor.constraint(equalToConstant: menuButton.standardWidth),
            menuButton.heightAnchor.constraint(equalToConstant: menuButton.standardHeight),
            menuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -iconBottomInset),
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -iconHorInset),
            
            rulesButton.widthAnchor.constraint(equalToConstant: rulesButton.standardWidth),
            rulesButton.heightAnchor.constraint(equalToConstant: rulesButton.standardHeight),
            rulesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -iconBottomInset),
            rulesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: iconHorInset),
            
            ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        checkDarkMode()
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDarkMode), name: .DarkModeSettingsChanged, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
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
    
    @objc func gameTimeButtonTapped(sender: TopButton, forEvent event: UIEvent) {
        
        let vc = GameTimeVC(titleText: LS_TITLE_GAMETIME, currentGamePeriods: (pageVC?.game.periods)!, currentGameMinutes: (pageVC?.game.minutes)!, onDismiss: nil)
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func menuButtonTapped(sender: TopButton, forEvent event: UIEvent) {
        
        #warning("to translate")
        let vc = MenuVC(titleText: "Settings")
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func rulesButtonTapped(sender: TopButton, forEvent event: UIEvent) {
        
        #warning("to translate")
        let vc = RulesVC(titleText: "Game Rules") {
            print("rules VC dismissed")
        }
        present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - Public Methods
    
    func liftPanArrowDownLabelUp() {
        
        panArrowDownLabelPadding = 8
        
    }
    
    
    // MARK: - Private Methods
    
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
}
