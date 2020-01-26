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
    
    var selectedMinutes: Int?
    var selectedPeriods: Int?
    
    private var cancelView: UIButton!
    private var pauseAtQuarterSwitch: UISwitch!
    private var pauseAtQuarterLabel: UILabel!
    private var countryButton: OvalCountryButton!
    
    private var cards: [DurationCard] = []
    
    private var skipAnimations: Bool = false
    private var pauseSwitchLeadingConstraint: NSLayoutConstraint!

    private var padding: CGFloat {
        return (UIDevice.deviceSize != .small && cards.count > 4) ? 18 : 12
    }
    private  var cardWidth: CGFloat {
        return view.bounds.width * 140 / 375
    }
    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground

        setupViews()
        
        let testTap = UITapGestureRecognizer(target: self, action: #selector(showTestSettings))
        testTap.numberOfTouchesRequired = 3
        testTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(testTap)
    }
    
    
    @objc private func showTestSettings() {
        
        if FeatureFlags.secretGestureToTestingVC {
            let testingVC = TestingVC()
            present(testingVC, animated: true)
        }
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
        
        menuButton.setColor(UIColor(named: ColorName.OliveText)!)
        rulesButton.setColor(UIColor(named: ColorName.OliveText)!)

        cancelView = UIButton()
        cancelView.addTarget(self, action: #selector(cancelViewTapped(sender:forEvent:)), for: [.touchUpInside])
        cancelView.translatesAutoresizingMaskIntoConstraints = false
        cancelView.backgroundColor = UIColor.clear
        cancelView.isUserInteractionEnabled = false
        view.insertSubview(cancelView, at: 0)
        
        countryButton = OvalCountryButton(capitals: SELECTED_COUNTRY.capitals, color: UIColor(named: ColorName.OliveText)!, crossColor: .white)
        countryButton.translatesAutoresizingMaskIntoConstraints = false
        countryButton.addTarget(self, action: #selector(countryButtonTapped), for: .touchUpInside)
        view.addSubview(countryButton)
        
        panArrowUp.alpha = 0.0
        panArrowDown.color = UIColor(named: ColorName.LightYellow)!
        panArrowUpLabel.alpha = 0.0
        panArrowDownLabel.alpha = 0.0
        panArrowDownLabel.textColor = UIColor(named: ColorName.VeryDarkBlue_White)!
        
        pauseAtQuarterSwitch = UISwitch()
        pauseAtQuarterSwitch.translatesAutoresizingMaskIntoConstraints = false
        setPauseAtQuarterSwitch()
        pauseAtQuarterSwitch.addTarget(self, action: #selector(handleSwitch(pauseSwitch:)), for: [.valueChanged])
        pauseAtQuarterSwitch.tintColor = UIColor(named: ColorName.OliveText)!
        pauseAtQuarterSwitch.thumbTintColor = UIColor(named: ColorName.OliveText)!
        pauseAtQuarterSwitch.onTintColor = UIColor(named: ColorName.LightYellow)!
        view.addSubview(pauseAtQuarterSwitch)
        
        pauseAtQuarterLabel = UILabel()
        pauseAtQuarterLabel.translatesAutoresizingMaskIntoConstraints = false
        pauseAtQuarterLabel.textColor = UIColor(named: ColorName.OliveText)
        pauseAtQuarterLabel.font = UIFont(name: FONTNAME.ThemeRegular, size: 15)
        pauseAtQuarterLabel.text = LS_GAME_IN_QUARTERS
        pauseAtQuarterLabel.numberOfLines = 0
        pauseAtQuarterLabel.textAlignment = .right
        view.addSubview(pauseAtQuarterLabel)
        
        for index in 0 ..< SELECTED_COUNTRY.minutes.count {
            let card = DurationCard(minutes: SELECTED_COUNTRY.minutes[index])
            cards.append(card)
            card.addTarget(self, action: #selector(handleCardTapped(sender:forEvent:)), for: [.touchUpInside])
            view.addSubview(card)
        }
        
        pauseSwitchLeadingConstraint = NSLayoutConstraint(item: pauseAtQuarterSwitch as Any, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -42)
        
        let buttonWidth: CGFloat = 44
        let buttonHeight: CGFloat = 44
        let buttonHorInset: CGFloat = UIDevice.whenDeviceIs(small: 37, normal: 42, big: 42)
        let buttonTopInset: CGFloat = UIDevice.whenDeviceIs(small: 0, normal: 12, big: 12)
        let switchTopInset: CGFloat = buttonTopInset + 6

        
        NSLayoutConstraint.activate([
            
            countryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: buttonHorInset),
            countryButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            countryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: buttonTopInset),
            countryButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            cancelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cancelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cancelView.topAnchor.constraint(equalTo: view.topAnchor),
            cancelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pauseAtQuarterSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: switchTopInset),
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
        selectedMinutes = nil
    }
    
    

    
    // MARK: - Private Methods
    
    private func setPauseAtQuarterSwitch() {
        
        let nop = selectedPeriods ?? pageVC?.game.periods
        if nop == 4 {
            pauseAtQuarterSwitch.setOn(true, animated: false)
        } else {
            pauseAtQuarterSwitch.setOn(false, animated: false)
        }

    }
    
    private func handleSelection(card: DurationCard) {
        
        self.cancelView.isUserInteractionEnabled = true
        selectedMinutes = card.minutes
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
        
        selectedPeriods = pauseSwitch.isOn ? 4 : 2
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
            self.selectedPeriods = nil
            self.skipAnimations = false
        })
        
        DispatchQueue.main.async {
            self.present(askConfirmationVC, animated: true, completion: nil)
        }
    }
    
    private func buildCards() {
        
        for card in cards {
            card.removeFromSuperview()
        }
        
        cards = []
        
        for index in 0..<SELECTED_COUNTRY.minutes.count {
            let minutes = SELECTED_COUNTRY.minutes[index]
            let card = DurationCard(minutes: minutes)
            cards.append(card)
            card.addTarget(self, action: #selector(handleCardTapped(sender:forEvent:)), for: [.touchUpInside])
            card.setMinutes(minutes, minutesString: SELECTED_COUNTRY.minutesStrings[index], animated: true, delay: 0.1 * Double(index))
            view.addSubview(card)
        }
        
        addCardConstraints()
    }
   
    
    // MARK: - Touch Methods
    
    @objc private func handleCardTapped(sender: DurationCard, forEvent event: UIEvent) {
        
        if sender.minutes == selectedMinutes { // sender.duration == selectedDuration
            // user tapped twice on same card
            clearSelectedDuration()
            return
        }
        handleSelection(card: sender)
    }
    
    @objc private func cancelViewTapped(sender: UIButton, forEvent event: UIEvent) {
        
        cancelView.isUserInteractionEnabled = false
        cards.forEach { $0.alpha = 1.0 }
        selectedMinutes = nil
    }
    
    @objc private func countryButtonTapped() {
        
        let vc = CountryVC(titleText: "Country", onDismiss: {
            self.buildCards()
            self.countryButton.setCapitals(SELECTED_COUNTRY.capitals)
        })
        present(vc, animated: true, completion: nil)
    }
}
