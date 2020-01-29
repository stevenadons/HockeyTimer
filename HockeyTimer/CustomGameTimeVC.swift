//
//  CustomGameTimeVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


class CustomGameTimeVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var titleLabel: UILabel!
    private var okButton: UIButton!
    private var cancelButton: UIButton!
    private var doneButton: UIButton!
    private var pickers: GameTimePickers!

    private var shouldPassSelection: Bool = false
    private var periods: Double!
    private var minutesPerPeriod: Double!
    private var totalMinutes: Double!
    
    private var titleText: String?
    private var onDismiss: ((Bool, Double?, Double?) -> Void)?
    private var haptic: UISelectionFeedbackGenerator?

    
    // MARK: - Life Cycle
    
    init(titleText: String? = nil, periods: Double, totalMinutes: Double, onDismiss: ((Bool, Double?, Double?) -> Void)? = nil) {
        
        self.titleText = titleText
        self.periods = periods
        self.totalMinutes = totalMinutes
        self.minutesPerPeriod = Double.maxOneDecimalDividing(totalMinutes, by: periods)
        self.onDismiss = onDismiss
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
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = titleText ?? ""
        titleLabel.font = UIFont(name: FONTNAME.ThemeBlack, size: 28)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let okColor = UIColor(named: ColorName.DarkBlue)!
        okButton = createButton(color: okColor)
        okButton.setTitle(LS_BUYPREMIUM_OK, for: .normal)
        okButton.addTarget(self, action: #selector(okTapped), for: [.touchUpInside])
        view.addSubview(okButton)
        
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
        
        pickers = GameTimePickers()
        pickers.translatesAutoresizingMaskIntoConstraints = false
        pickers.setPickersTo(periods, second: minutesPerPeriod, animated: false)
//        pickers.decimalButtonTapped()
        view.addSubview(pickers)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        checkDarkMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        okButton.alpha = 0.0
        isModalInPresentation = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
                
        super.viewDidAppear(animated)
        prepareHaptic()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        print("Will perform onDismiss with periods \(periods)")
        onDismiss?(shouldPassSelection, totalMinutes, periods)
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDarkMode), name: .DarkModeSettingsChanged, object: nil)
        
        NotificationCenter.default.addObserver(forName: .CustomTimeSelectionOccurred, object: nil, queue: nil) { [weak self] (notification) in
            
            guard let self = self else {
                return
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.okButton.alpha = 1.0
            }, completion: { (finished) in
                self.isModalInPresentation = true
            })
            guard let userInfo = notification.userInfo as? [String: Any] else {
                return
            }
            print("Evaluating userInfo \(userInfo)")
            if let receivedPeriods = userInfo[GameTimePickersUserInfoKey.Periods] as? Double {
                self.periods = receivedPeriods
                self.minutesPerPeriod = Double.maxOneDecimalDividing(self.totalMinutes, by: self.periods)
                print("Did set periods to \(self.periods)")
            }
            if let receivedMinutesPerPeriod = userInfo[GameTimePickersUserInfoKey.Minutes] as? Double {
                self.minutesPerPeriod = receivedMinutesPerPeriod
                self.totalMinutes = self.periods * self.minutesPerPeriod
            }
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let buttonHeight = UIDevice.whenDeviceIs(small: 44, normal: 50, big: 54)
        let buttonHorInset = UIDevice.whenDeviceIs(small: 20, normal: 35, big: 35)
        let buttonBottomInset: CGFloat = UIDevice.whenDeviceIs(small: 12, normal: 16, big: 20)
        let buttonPadding: CGFloat = UIDevice.whenDeviceIs(small: 10, normal: 12, big: 16)
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            okButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: buttonHorInset),
            okButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -buttonHorInset),
            okButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -buttonPadding),
            okButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            cancelButton.leadingAnchor.constraint(equalTo: okButton.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: okButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalTo: okButton.heightAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -buttonBottomInset),
            
            pickers.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
            pickers.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonHorInset),
            pickers.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonHorInset),
            pickers.heightAnchor.constraint(equalTo: pickers.widthAnchor, multiplier: 1),

            ])
    }
    


    // MARK: - Public Methods
    
    
    
    
    // MARK: - Touch Methods
    
    @objc private func okTapped() {
        
        shouldPassSelection = true
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func cancelTapped() {
        
        shouldPassSelection = false
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func doneTapped() {
        
        shouldPassSelection = true
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
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
    
    private func showAlertNewGame() {
        
        let askConfirmationVC = SimpleAlertVC(titleText: LS_WARNINGNEWGAME_TITLE, text: LS_WARNINGGAMERUNNING, okButtonText: LS_BUYPREMIUM_OK, cancelButtonText: LS_BUTTON_CANCEL, okAction: nil, cancelAction: {
            #warning("to test")
            self.shouldPassSelection = false
        })
        
        DispatchQueue.main.async {
            self.present(askConfirmationVC, animated: true, completion: nil)
        }
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
    
    @objc private func customTimeSelectionOccurred() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.okButton.alpha = 1.0
        }, completion: { (finished) in
            self.isModalInPresentation = true
        })
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

