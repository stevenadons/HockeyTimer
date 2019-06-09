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
    
    var currentDuration: Duration?
    var selectedDuration: Duration?
    
    fileprivate var cancelView: UIButton!
    fileprivate var cards: [DurationCard] = []
    fileprivate var dotMenu: DotMenu!
    
    fileprivate var skipAnimations: Bool = false
    
    fileprivate var padding: CGFloat {
        return (UIDevice.deviceSize != .small && cards.count > 4) ? 18 : 12
    }
    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = COLOR.White
        setupViews()
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
        
        dotMenu.hideButtons(animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        guard !skipAnimations else { return }
        for card in self.cards {
            card.windUp()
        }
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
        panArrowDownLabel.text = LS_TITLE_STOPWATCH
        panArrowDownLabel.textColor = COLOR.VeryDarkBlue
        
        dotMenu = DotMenu(inView: view, delegate: self, labelNames: Country.allNames(), capitalsStrings: Country.allCapitals(), selected: countries.firstIndex(of: SELECTED_COUNTRY))
        
        for index in 0..<SELECTED_COUNTRY.durations.count {
            let card = DurationCard(duration: SELECTED_COUNTRY.durations[index])
            cards.append(card)
            card.addTarget(self, action: #selector(handleCardTapped(sender:forEvent:)), for: [.touchUpInside])
            view.insertSubview(card, belowSubview: dotMenu)
        }
        
        NSLayoutConstraint.activate([
            
            cancelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cancelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cancelView.topAnchor.constraint(equalTo: view.topAnchor),
            cancelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            ])
        
        addCardConstraints()
    }
    
    private func addCardConstraints() {
        
        var topInset = UIDevice.whenDeviceIs(small: 100, normal: 130, big: 140)
        if cards.count > 4 {
            topInset = UIDevice.whenDeviceIs(small: 75, normal: 85, big: 140)
        }
                
        for index in 0..<cards.count {
            
            cards[index].widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 140 / 375).isActive = true
            cards[index].heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 140 / 375).isActive = true
            
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
    
    

    
    // MARK: - Private Methods
    
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
    
    
    // MARK: - Touch Methods
    
    @objc private func handleCardTapped(sender: DurationCard, forEvent event: UIEvent) {
        
        if sender.duration == selectedDuration {
            // user tapped twice on same card
            cards.forEach { $0.alpha = 1.0 }
            selectedDuration = nil
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


extension DurationVC: DotMenuDelegate {
    
    func handleDotMenuButtonTapped(buttonNumber: Int) {
        
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
            view.insertSubview(card, belowSubview: dotMenu)
        }
        
        addCardConstraints()
    }
}


