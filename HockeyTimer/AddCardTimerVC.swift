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
    private var okButton: UIButton!
    private var cancelButton: UIButton!
    
    private var titleText: String = LS_TITLE_PENALTY_CARD
    private var okButtonText: String = LS_BUYPREMIUM_OK
    private var cancelButtonText: String = LS_BUTTON_CANCEL
    
    private var minutesYOffset: CGFloat {
        return view.bounds.height * 0.1
    }
    private let cardPanelHeight: CGFloat = 100
    private let panelsPadding: CGFloat = UIDevice.whenDeviceIs(small: 20, normal: 40, big: 40)
    
    private var okAction: ((CardType, Int) -> Void)?
    private var cancelAction: (() -> Void)?
    private var haptic: UISelectionFeedbackGenerator?
    
    
    // MARK: - Life Cycle
    
    init(okAction: ((CardType, Int) -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        
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
        
        let okColor = UIColor(named: ColorName.DarkBlue)!
        okButton = createButton(color: okColor)
        okButton.setTitle(okButtonText, for: .normal)
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
            minutesPanel.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -24),
            minutesPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horInset),
            minutesPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horInset),
            
            cardPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horInset),
            cardPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horInset),
            cardPanel.heightAnchor.constraint(equalToConstant: cardPanelHeight),
            cardPanel.bottomAnchor.constraint(equalTo: minutesPanel.topAnchor, constant: -panelsPadding),
            
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
            self.titleLabel.text = "Minutes"
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
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: {
                if let selectedType = self?.cardPanel.selectedType {
                    if selectedType == .red {
                        self?.okAction?(selectedType, 35)
                    } else if let selectedMinutes = self?.minutesPanel.selectedMinutesView?.minutes {
                        self?.okAction?(selectedType, selectedMinutes)
                    }
                }
            })
        }
    }
    
    @objc private func cancelTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.cancelAction?()
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
        
        okButton.alpha = (cardPanel.selectedType == CardType.red) ? 1.0 : 0.0
        
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
        
        prepareHaptic()
    }
}


