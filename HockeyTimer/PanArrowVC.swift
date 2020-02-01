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
    var gameTimeButton: IconButton!
    var rulesButton: IconButton!
    var menuButton: IconButton!
    var resetButton: IconButton!

    
    private var panArrowDownLabelPadding: CGFloat = 2
    
    weak var pageVC: PageVC?
    var iconsAtTop: Bool = false

    
    // MARK: - Life Cycle Methods
    
    convenience init(pageVC: PageVC, iconsAtTop: Bool) {
        
        self.init()
        self.pageVC = pageVC
        self.iconsAtTop = iconsAtTop
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
        
        let iconColor = UIColor.secondaryLabel
        let textColor = UIColor(named: ColorName.IconText)!
        
        gameTimeButton = IconButton(imageName: "timer", text: LS_TITLE_GAMETIME, iconColor: iconColor, textColor: textColor)
        gameTimeButton.addTarget(self, action: #selector(gameTimeButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(gameTimeButton)
        
        rulesButton = IconButton(imageName: "doc.plaintext", text: LS_TITLE_GAME_RULES, iconColor: iconColor, textColor: textColor)
        rulesButton.addTarget(self, action: #selector(rulesButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(rulesButton)
        
        menuButton = IconButton(imageName: "line.horizontal.3", text: LS_TITLE_SETTINGS, iconColor: iconColor, textColor: textColor)
        menuButton.addTarget(self, action: #selector(menuButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(menuButton)
        
        resetButton = IconButton(imageName: "arrow.2.circlepath", text: LS_WARNINGRESETGAME, iconColor: iconColor, textColor: textColor)
        resetButton.alpha = 0.0
        resetButton.addTarget(self, action: #selector(resetButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(resetButton)
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let arrowPaddingTop: CGFloat = 16
        let arrowPaddingBottom: CGFloat = 18
        
        let iconHorInset: CGFloat = UIDevice.whenDeviceIs(small: 22, normal: 26, big: 26)
        let iconBottomInset: CGFloat = UIDevice.whenDeviceIs(small: 8, normal: 22, big: 22)
        let buttonTopInset: CGFloat = UIDevice.whenDeviceIs(small: 0, normal: 6, big: 6)
        
        let iconButtonInterDistance: CGFloat = (view.bounds.width - iconHorInset * 2 - IconButton.standardWidth) / 3
        
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
            
            gameTimeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: iconHorInset),
            gameTimeButton.widthAnchor.constraint(equalToConstant: IconButton.standardWidth),
            gameTimeButton.heightAnchor.constraint(equalToConstant: IconButton.standardHeight),
            
            rulesButton.widthAnchor.constraint(equalToConstant: IconButton.standardWidth),
            rulesButton.heightAnchor.constraint(equalToConstant: IconButton.standardHeight),
            rulesButton.centerXAnchor.constraint(equalTo: gameTimeButton.centerXAnchor, constant: iconButtonInterDistance),
            
            menuButton.widthAnchor.constraint(equalToConstant: IconButton.standardWidth),
            menuButton.heightAnchor.constraint(equalToConstant: IconButton.standardHeight),
            menuButton.centerXAnchor.constraint(equalTo: rulesButton.centerXAnchor, constant: iconButtonInterDistance),
            
            resetButton.widthAnchor.constraint(equalToConstant: IconButton.standardWidth),
            resetButton.heightAnchor.constraint(equalToConstant: IconButton.standardHeight),
            resetButton.centerXAnchor.constraint(equalTo: menuButton.centerXAnchor, constant: iconButtonInterDistance),

            ])
        
        if iconsAtTop {
            
            NSLayoutConstraint.activate([
                
                gameTimeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: buttonTopInset),
                rulesButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: buttonTopInset),
                menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: buttonTopInset),
                resetButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: buttonTopInset),
            
            ])
            
        } else {
            
            NSLayoutConstraint.activate([
                
                gameTimeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -iconBottomInset),
                rulesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -iconBottomInset),
                menuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -iconBottomInset),
                resetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -iconBottomInset),

            ])
            
        }
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
    
    @objc func gameTimeButtonTapped(sender: IconButton, forEvent event: UIEvent) {
        
        let currentGameRunning = (pageVC?.game.status != .WaitingToStart)
        let vc = GameTimeVC(currentPeriods: (pageVC?.game.periods)!, currentTotalMinutes: (pageVC?.game.totalMinutes)!, currentGameRunning: currentGameRunning, onDismiss: nil)
        present(vc, animated: true, completion: nil)
    }
    
    @objc func menuButtonTapped(sender: IconButton, forEvent event: UIEvent) {
        
        let vc = MenuVC()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func rulesButtonTapped(sender: IconButton, forEvent event: UIEvent) {
        
        let vc = RulesVC(onDismiss: nil)
        present(vc, animated: true, completion: nil)
    }
    
    @objc func resetButtonTapped(sender: IconButton, forEvent event: UIEvent) {
        
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
