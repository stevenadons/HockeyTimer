//
//  AppIconVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 02/02/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


class AppIconVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var titleLabel: UILabel!
    private var cancelButton: UIButton!
    private var doneButton: UIButton!

    private var titleText: String?
    private var cards: [AppIconCard] = []
    private var haptic: UISelectionFeedbackGenerator?

    private let buttonHorInset = UIDevice.whenDeviceIs(small: 20, normal: 35, big: 35)
    private var padding: CGFloat {
        return (UIDevice.deviceSize != .small && cards.count > 4) ? 24 : 18
    }
    private let cardWidth: CGFloat = 100
    
    private var standardIconImageName: String {
        return "AppIconAlt2"
    }
    private var imageNames: [String] {
        return [standardIconImageName, "AppIconAlt6", "AppIconAlt1", "AppIconAlt3", "AppIconAlt4", "AppIconAlt5"]
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        checkDarkMode()
        addObservers()
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .coverVertical
        
        setupUI()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = LS_TITLE_APP_ICON
        titleLabel.font = UIFont(name: FONTNAME.ThemeBlack, size: 28)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let cancelColor = UIColor(named: ColorName.PantoneRed)!
        cancelButton = createButton(color: cancelColor)
        cancelButton.setTitle(LS_BUTTON_CANCEL, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: [.touchUpInside])
        view.addSubview(cancelButton!)
        
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle(LS_BUTTON_DONE, for: .normal)
        doneButton.addTarget(self, action: #selector(doneTapped), for: [.touchUpInside])
        doneButton.setTitleColor(UIColor(named: ColorName.DarkBlueText)!, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 16)
        view.addSubview(doneButton)
        
        buildCards()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        checkDarkMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
                
        super.viewDidAppear(animated)
        prepareHaptic()
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDarkMode), name: .DarkModeSettingsChanged, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let buttonHeight = UIDevice.whenDeviceIs(small: 44, normal: 50, big: 54)
        let buttonBottomInset: CGFloat = UIDevice.whenDeviceIs(small: 12, normal: 16, big: 20)
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: buttonHorInset),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -buttonHorInset),
            cancelButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -buttonBottomInset),

            ])
        
        addCardConstraints()
    }
    
    private func addCardConstraints() {
        
        let topInset = UIDevice.whenDeviceIs(small: 35, normal: 55, big: 75)
                
        for index in 0..<cards.count {
            
            cards[index].widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
            cards[index].heightAnchor.constraint(equalToConstant: cardWidth).isActive = true
            
            // Horizontal
            if index % 2 == 0 { // Left column
                cards[index].trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -padding / 2).isActive = true
            } else { // Right column
                cards[index].leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: padding / 2).isActive = true
            }
            
            // Vertical
            if index == 0 || index == 1 { // Top row
                cards[index].topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topInset).isActive = true
            } else { // Other rows
                cards[index].topAnchor.constraint(equalTo: cards[index - 2].bottomAnchor, constant: padding).isActive = true
            }
        }
    }


    // MARK: - Public Methods

    
    
    // MARK: - Touch Methods
   
    @objc private func cancelTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func doneTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func cardTapped(tappedCard: AppIconCard, forEvent event: UIEvent) {
        
        guard UserDefaults.standard.bool(forKey: UserDefaultsKey.PremiumMode) else {
            
            let buyPremiumVC = BuyPremiumVC(title: LS_BUYPREMIUM_TITLE_CHANGE_APP_ICON, text: LS_BUYPREMIUM_TEXT_CHANGE_APP_ICON, showFirstButton: false, afterDismiss: { earned in
                if earned {
                    self.performChangeFor(tappedCard)
                } 
            })
            present(buyPremiumVC, animated: true, completion: nil)
            return
        }
        performChangeFor(tappedCard)
    }
    
    private func performChangeFor(_ tappedCard: AppIconCard) {
        
        doHaptic()
        
        if tappedCard.imageName == standardIconImageName {
            UIApplication.shared.setAlternateIconName(nil, completionHandler: nil)
        } else {
            UIApplication.shared.setAlternateIconName(tappedCard.imageName, completionHandler: nil)
        }
        for card in cards {
            let highlight = (card == tappedCard)
            card.highlight(highlight)
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.cancelButton.alpha = 0.0
        })
        
        prepareHaptic()
    }
    
    
    // MARK: - Private Methods
    
    private func createButton(color: UIColor) -> UIButton {
        
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.layer.cornerRadius = 8
        
        return button
    }
    
    private func buildCards() {
        
        for card in cards {
            card.removeFromSuperview()
        }
        
        cards = []
        let numberOfCards = imageNames.count
        for index in 0 ..< numberOfCards {
            
            let card = AppIconCard(imageName: imageNames[index])
            cards.append(card)
            card.addTarget(self, action: #selector(cardTapped(tappedCard:forEvent:)), for: [.touchUpInside])
            view.addSubview(card)
            
            if UIApplication.shared.alternateIconName == nil && index == 0 {
                card.highlight(true)
            }
            if let alternativeName = UIApplication.shared.alternateIconName, alternativeName == imageNames[index] {
                card.highlight(true)
            } 
        }
        addCardConstraints()
    }
    
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
    
    
    // MARK: - Haptic
    
    private func prepareHaptic() {
        
        if haptic == nil {
            haptic = UISelectionFeedbackGenerator()
            haptic!.prepare()
        }
    }
    
    private func doHaptic() {
        
        haptic?.selectionChanged()
        haptic = nil
    }
}


