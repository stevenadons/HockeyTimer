//
//  AddCardTimerVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 01/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class AddCardTimerVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var titleLabel: UILabel!
    private var cardPanel: ChooseCardPanel!
    private var minutesPanel: ChooseMinutesPanel!
    private var logPlayerButton: UIButton!
    private var okButton: UIButton!
    private var cancelButton: UIButton!
    
    private var team: Team?
    private var player: String?
    
    private var titleText: String = LS_TITLE_PENALTY_CARD
    private var logPlayerButtonText: String = LS_BUTTON_LOG_PLAYER
    private var okButtonText: String = LS_BUYPREMIUM_OK
    private var cancelButtonText: String = LS_BUTTON_CANCEL
    
    private var minutesYOffset: CGFloat {
        return view.bounds.height * 0.1
    }
    private let cardPanelHeight: CGFloat = 100
    private let panelsPadding: CGFloat = UIDevice.whenDeviceIs(small: 16, normal: 32, big: 32)
    
    private var okAction: ((CardType, Int, Team?, String?) -> Void)?
    private var cancelAction: (() -> Void)?
    private var haptic: UISelectionFeedbackGenerator?
    
    
    // MARK: - Life Cycle
    
    init(okAction: ((CardType, Int, Team?, String?) -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        
        self.okAction = okAction
        self.cancelAction = cancelAction
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        checkDarkMode()
        addObservers()
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .coverVertical
        
        setupUI()
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        windUp(animated: false)
        okButton.alpha = 0.0
        logPlayerButton.alpha = 0.0
        isModalInPresentation = false
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = titleText
        titleLabel.font = UIFont(name: FONTNAME.ThemeBlack, size: 28)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        cardPanel = ChooseCardPanel()
        cardPanel.delegate = self
        view.addSubview(cardPanel)
        
        minutesPanel = ChooseMinutesPanel()
        minutesPanel.delegate = self
        view.addSubview(minutesPanel)
        
        logPlayerButton = UIButton()
        logPlayerButton.translatesAutoresizingMaskIntoConstraints = false
        logPlayerButton.titleLabel?.numberOfLines = 1
        logPlayerButton.titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 14)!
        logPlayerButton.setTitleColor(.secondaryLabel, for: .normal)
        logPlayerButton.addTarget(self, action: #selector(logPlayerTapped), for: .touchUpInside)
        logPlayerButton.setTitle(logPlayerButtonText, for: .normal)
        view.addSubview(logPlayerButton)
        
        let okColor = UIColor(named: ColorName.PantoneYellow)!
        okButton = createButton(color: okColor)
        okButton.setTitle(okButtonText, for: .normal)
        okButton.setTitleColor(UIColor(named: ColorName.VeryDarkBlue)!, for: .normal)
        okButton.addTarget(self, action: #selector(okTapped), for: [.touchUpInside])
        view.addSubview(okButton)
        
        let cancelColor = UIColor(named: ColorName.PantoneRed)!
        cancelButton = createButton(color: cancelColor)
        cancelButton.setTitle(cancelButtonText, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: [.touchUpInside])
        view.addSubview(cancelButton!)
    }
    
    private func addConstraints() {
        
        let buttonHeight = UIDevice.whenDeviceIs(small: 44, normal: 50, big: 54)
        let buttonHorInset = UIDevice.whenDeviceIs(small: 20, normal: 35, big: 35)
        let buttonBottomInset: CGFloat = UIDevice.whenDeviceIs(small: 12, normal: 16, big: 20)
        let buttonPadding: CGFloat = UIDevice.whenDeviceIs(small: 10, normal: 12, big: 16)
        let horInset: CGFloat = 50
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            minutesPanel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -minutesYOffset),
            minutesPanel.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -56),
            minutesPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horInset),
            minutesPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horInset),
            
            cardPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horInset),
            cardPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horInset),
            cardPanel.heightAnchor.constraint(equalToConstant: cardPanelHeight),
            cardPanel.bottomAnchor.constraint(equalTo: minutesPanel.topAnchor, constant: -panelsPadding),
            
            logPlayerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logPlayerButton.bottomAnchor.constraint(equalTo: okButton!.topAnchor, constant: -buttonPadding * 1.5),
            
            okButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: buttonHorInset),
            okButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -buttonHorInset),
            okButton.bottomAnchor.constraint(equalTo: cancelButton!.topAnchor, constant: -buttonPadding),
            okButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            cancelButton!.leadingAnchor.constraint(equalTo: okButton.leadingAnchor),
            cancelButton!.trailingAnchor.constraint(equalTo: okButton.trailingAnchor),
            cancelButton!.heightAnchor.constraint(equalTo: okButton.heightAnchor),
            cancelButton!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -buttonBottomInset),
            
            ])
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDarkMode), name: .DarkModeSettingsChanged, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    private func windUp(animated: Bool) {
        
        if animated {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
                self.windUpActions()
            }, completion: nil)
            
            
        } else {
            windUpActions()
        }
    }
    
    private func windUpActions() {
        
        let cardPanelY = minutesYOffset + panelsPadding + cardPanelHeight / 2 - 60
        let minutesPanelY = view.bounds.height
        
        cardPanel.transform = CGAffineTransform(translationX: 0, y: cardPanelY)
        minutesPanel.transform = CGAffineTransform(translationX: 0, y: minutesPanelY)
        minutesPanel.alpha = 0.0
    }
    
    private func animateMinutesFlyIn() {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.cardPanel.transform = .identity
            self.minutesPanel.transform = .identity
            
        }, completion: { _ in
            self.titleLabel.text = LS_TITLE_MINUTES
        })
       
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
            self.minutesPanel.alpha = 1.0
            
        }, completion: nil)
    }
    
    private func createButton(color: UIColor) -> UIButton {
        
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.layer.cornerRadius = 8
        
        return button
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
    
    
    // MARK: - Touch Methods
    
    @objc private func okTapped() {
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.PremiumMode) {
            performAddCardAction()
            
        } else {
            let buyPremiumVC = BuyPremiumVC(title: LS_BUYPREMIUM_TITLE_CARD, text: LS_BUYPREMIUM_TEXT_CARD, showFirstButton: false, afterDismiss: { earned in
                if earned {
                    self.performAddCardAction()
                } 
            })
            present(buyPremiumVC, animated: true, completion: nil)
        }
    }
    
    @objc private func cancelTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.cancelAction?()
            })
        }
    }
    
    @objc private func logPlayerTapped() {
        
        let vc = LogPlayerVC(okAction: { [weak self] (team, player) in
            self?.team = team
            self?.player = player
            guard let team = team, let player = player else { return }
            let buttonTitle = LS_ADDING_CARD_FOR + ": " + team.teamString() + " " + player
            self?.logPlayerButton.setTitle(buttonTitle, for: .normal)
        }, cancelAction: nil)
        present(vc, animated: true, completion: nil)
    }
    
    private func performAddCardAction() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: {
                if let selectedType = self?.cardPanel.selectedType {
                    if selectedType == .red {
                        self?.okAction?(selectedType, 35, self?.team, self?.player)
                    } else if let selectedMinutes = self?.minutesPanel.selectedMinutesView?.minutes {
                        self?.okAction?(selectedType, selectedMinutes, self?.team, self?.player)
                    }
                }
            })
        }
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


extension AddCardTimerVC: ChooseCardPanelDelegate {
    
    func didSelectCard() {
        
        doHaptic()
        
        if let selectedType = cardPanel.selectedType {
            let fakeCard = Card(type: selectedType)
            minutesPanel.setHighlightColor(fakeCard.color())
        }
        
        if cardPanel.selectedType == CardType.red {
            okButton.alpha = 1.0
            logPlayerButton.alpha = 1.0
            isModalInPresentation = true
        } else {
            okButton.alpha = 0.0
            logPlayerButton.alpha = 0.0
            isModalInPresentation = false
        }
        
        
        prepareHaptic()
        
        switch cardPanel.selectedType {
        case .red:
            minutesPanel.dehighlightAll()
            windUp(animated: true)
            titleLabel.text = LS_TITLE_PENALTY_CARD
            return
        case .yellow:
            minutesPanel.highlight(5)
        default: // .green
            minutesPanel.highlight(2)
        }
        
        if cardPanel.transform != .identity {
            animateMinutesFlyIn()
        }
    }
}


extension AddCardTimerVC: ChooseMinutesPanelDelegate {
    
    func didSelectMinutes() {
        
        doHaptic()
        
        okButton.alpha = 1.0
        logPlayerButton.alpha = 1.0
        isModalInPresentation = true
        
        prepareHaptic()
    }
}


