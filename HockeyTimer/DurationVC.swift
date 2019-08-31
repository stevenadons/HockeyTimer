//
//  DurationVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DurationVC: PanArrowVC {

    
    // MARK: - Properties
    
    var selectedDuration: Duration?
    var selectedNumberOfPeriods: NumberOfPeriods?
    
    fileprivate var cancelView: UIButton!
    fileprivate var countryMenu: CountryMenu!
    fileprivate var pauseAtQuarterSwitch: UISwitch!
    fileprivate var pauseAtQuarterLabel: UILabel!
    fileprivate var cards: [DurationCard] = []
    
    fileprivate var skipAnimations: Bool = false
    fileprivate var pauseSwitchLeadingConstraint: NSLayoutConstraint!

    fileprivate var padding: CGFloat {
        return (UIDevice.deviceSize != .small && cards.count > 4) ? 18 : 12
    }
    fileprivate  var cardWidth: CGFloat {
        return view.bounds.width * 140 / 375
    }
    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = COLOR.White
        setupViews()
        
        let testTap = UITapGestureRecognizer(target: self, action: #selector(showTestSettings))
        testTap.numberOfTouchesRequired = 3
        testTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(testTap)
    }
    
    
    @objc private func showTestSettings() {
        
//        #warning("testing")
//        let testingVC = TestingVC()
//        present(testingVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        setPauseAtQuarterSwitch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
                
        super.viewDidAppear(animated)
        
        guard !skipAnimations else { return }
        for card in self.cards {
            if let index = self.cards.firstIndex(of: card) {
                card.popup(delay: 0.1 * Double(index))
            } else {
                card.popup(delay: 1.0)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        countryMenu.hideButtons(animated: false)
        pageVC?.hideBackgroundMask()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        guard !skipAnimations else { return }
        for card in self.cards {
            card.windUp()
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        pauseSwitchLeadingConstraint.constant = -(view.bounds.width / 2 - cardWidth - (padding / 2))
    }
    
    private func setupViews() {
        
        cancelView = UIButton()
        cancelView.addTarget(self, action: #selector(cancelViewTapped(sender:forEvent:)), for: [.touchUpInside])
        cancelView.translatesAutoresizingMaskIntoConstraints = false
        cancelView.backgroundColor = UIColor.clear
        cancelView.isUserInteractionEnabled = false
        view.insertSubview(cancelView, at: 0)
        
        panArrowUp.alpha = 0.0
        panArrowDown.color = COLOR.LightYellow
        panArrowUpLabel.alpha = 0.0
        panArrowDownLabel.alpha = 0.0
        panArrowDownLabel.textColor = COLOR.VeryDarkBlue
        
        countryMenu = CountryMenu(inView: view,
                                  delegate: self,
                                  labelNames: Country.allNames(),
                                  capitalsStrings: Country.allCapitals(),
                                  hasBorder: true,
                                  leftSide: true,
                                  selected: countries.firstIndex(of: SELECTED_COUNTRY))
        countryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        pauseAtQuarterSwitch = UISwitch()
        pauseAtQuarterSwitch.translatesAutoresizingMaskIntoConstraints = false
        setPauseAtQuarterSwitch()
        pauseAtQuarterSwitch.addTarget(self, action: #selector(handleSwitch(pauseSwitch:)), for: [.valueChanged])
        pauseAtQuarterSwitch.tintColor = COLOR.Olive
        pauseAtQuarterSwitch.thumbTintColor = COLOR.Olive
        pauseAtQuarterSwitch.onTintColor = COLOR.LightYellow
        view.insertSubview(pauseAtQuarterSwitch, belowSubview: countryMenu)
        
        pauseAtQuarterLabel = UILabel()
        pauseAtQuarterLabel.translatesAutoresizingMaskIntoConstraints = false
        pauseAtQuarterLabel.textColor = COLOR.Olive.darker(by: 40)
        pauseAtQuarterLabel.font = UIFont(name: FONTNAME.ThemeRegular, size: 15)
        pauseAtQuarterLabel.text = LS_GAME_IN_QUARTERS
        pauseAtQuarterLabel.numberOfLines = 0
        pauseAtQuarterLabel.textAlignment = .right
        view.insertSubview(pauseAtQuarterLabel, belowSubview: countryMenu)
        
        for index in 0..<SELECTED_COUNTRY.durations.count {
            let card = DurationCard(duration: SELECTED_COUNTRY.durations[index])
            cards.append(card)
            card.addTarget(self, action: #selector(handleCardTapped(sender:forEvent:)), for: [.touchUpInside])
            view.insertSubview(card, belowSubview: countryMenu)
        }
        
        pauseSwitchLeadingConstraint = NSLayoutConstraint(item: pauseAtQuarterSwitch as Any, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -42)
        let switchTopInset: CGFloat = UIDevice.whenDeviceIs(small: 36, normal: 51, big: 51)
        
        NSLayoutConstraint.activate([
            
            countryMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countryMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countryMenu.topAnchor.constraint(equalTo: view.topAnchor),
            countryMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cancelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cancelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cancelView.topAnchor.constraint(equalTo: view.topAnchor),
            cancelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pauseAtQuarterSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: switchTopInset),
            pauseSwitchLeadingConstraint,
            
            pauseAtQuarterLabel.trailingAnchor.constraint(equalTo: pauseAtQuarterSwitch.leadingAnchor, constant: -11),
            pauseAtQuarterLabel.centerYAnchor.constraint(equalTo: pauseAtQuarterSwitch.centerYAnchor, constant: 0),
            
            ])
        
        addCardConstraints()
    }
    
    private func addCardConstraints() {
        
        var topInset = UIDevice.whenDeviceIs(small: 130, normal: 150, big: 190)
        if cards.count > 4 {
            topInset = UIDevice.whenDeviceIs(small: 85, normal: 95, big: 140)
        }
                
        for index in 0..<cards.count {
            
            cards[index].widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
            cards[index].heightAnchor.constraint(equalToConstant: cardWidth).isActive = true
            
            // Horizontal
            if index == cards.count - 1 && index % 2 == 0 { // Last card in the middle
                cards[index].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            } else if index % 2 == 0 { // Left column
                cards[index].trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -padding / 2).isActive = true
            } else { // Right column
                cards[index].leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: padding / 2).isActive = true
            }
            
            // Vertical
            if index == 0 || index == 1 { // Top row
                cards[index].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topInset).isActive = true
            } else { // Other rows
                cards[index].topAnchor.constraint(equalTo: cards[index - 2].bottomAnchor, constant: padding).isActive = true
            }
        }
    }
    
    // MARK: - Public Methods
    
    func clearSelectedDuration() {
        
        cards.forEach { $0.alpha = 1.0 }
        selectedDuration = nil
    }
    
    

    
    // MARK: - Private Methods
    
    private func setPauseAtQuarterSwitch() {
        
        let nop = selectedNumberOfPeriods ?? pageVC?.game.numberOfPeriods
        
        if nop == NumberOfPeriods.Quarters {
            pauseAtQuarterSwitch.setOn(true, animated: false)
        } else {
            pauseAtQuarterSwitch.setOn(false, animated: false)
        }
    }
    
    private func handleSelection(card: DurationCard) {
        
        self.cancelView.isUserInteractionEnabled = true
        selectedDuration = card.duration
        card.alpha = 1.0
        UIView.animate(withDuration: 0.2, animations: {
            self.cards.forEach {
                if !($0.isEqual(card)) {
                    $0.alpha = 0.3
                }
            }
        })
    }
    
    @objc private func handleSwitch(pauseSwitch: UISwitch) {
        
        selectedNumberOfPeriods = pauseSwitch.isOn ? .Quarters : .Halves
        if pageVC?.game.status != HockeyGameStatus.WaitingToStart {
            showAlertNewGame()
        }
    }
    
    private func showAlertNewGame() {
        
        skipAnimations = true
        let askConfirmationVC = SimpleAlertVC(titleText: LS_WARNINGNEWGAME_TITLE, text: LS_WARNINGGAMERUNNING, okButtonText: "OK", cancelButtonText: LS_BUTTON_CANCEL, okAction: {
            self.skipAnimations = false
        }, cancelAction: {
            let newSwitchPosition = self.pauseAtQuarterSwitch.isOn
            self.pauseAtQuarterSwitch.setOn(!newSwitchPosition, animated: true)
            self.selectedNumberOfPeriods = nil
            self.skipAnimations = false
        })
        
        DispatchQueue.main.async {
            self.present(askConfirmationVC, animated: true, completion: nil)
        }
    }
   
    
    // MARK: - Touch Methods
    
    @objc private func handleCardTapped(sender: DurationCard, forEvent event: UIEvent) {
        
        if sender.duration == selectedDuration {
            // user tapped twice on same card
            clearSelectedDuration()
            return
        }
        
        let inPremiumMode = UserDefaults.standard.bool(forKey: USERDEFAULTSKEY.PremiumMode)
        guard !inPremiumMode else {
            handleSelection(card: sender)
            return
        }
        
        // App in Basic Mode: present option to buy premium or watch ad
        let actions: (Bool) -> Void = { [sender] rewardEarned in
            if rewardEarned {
                self.handleSelection(card: sender)
                self.skipAnimations = false
            }
        }
        
        skipAnimations = true
        let buyPremiumVC = BuyPremiumVC(title: LS_BUYPREMIUM_TITLE_CHANGE_GAME_TIME , text: LS_BUYPREMIUM_TEXT_CHANGE_GAME_TIME, afterDismiss: actions)
        present(buyPremiumVC, animated: true, completion: nil)
    }
    
    @objc private func cancelViewTapped(sender: UIButton, forEvent event: UIEvent) {
        
        cancelView.isUserInteractionEnabled = false
        cards.forEach { $0.alpha = 1.0 }
        selectedDuration = nil
    }
    
}


extension DurationVC: CountryMenuDelegate {
    
    func handleCountryMenuMainButtonTapped() { }
    
    func handleCountryMenuOtherButtonTapped(buttonNumber: Int) {
        
        guard countries[buttonNumber] != SELECTED_COUNTRY else { return }
        SELECTED_COUNTRY = countries[buttonNumber]
        
        for card in cards {
            card.removeFromSuperview()
        }
        
        cards = []
        
        for index in 0..<SELECTED_COUNTRY.durations.count {
            let card = DurationCard(duration: SELECTED_COUNTRY.durations[index])
            cards.append(card)
            card.addTarget(self, action: #selector(handleCardTapped(sender:forEvent:)), for: [.touchUpInside])
            card.setDuration(SELECTED_COUNTRY.durations[index], durationString: SELECTED_COUNTRY.durationStrings[index], animated: true, delay: 0.1 * Double(index))
            view.insertSubview(card, belowSubview: countryMenu)
        }
        
        addCardConstraints()
    }
    
    func didShowButtons() {
        
        pageVC?.showBackgroundMask()
    }
    
    func willHideButtons() {
        
        pageVC?.hideBackgroundMask()
    }
}


