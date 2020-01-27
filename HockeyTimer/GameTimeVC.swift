//
//  GameTimeVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 25/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


class GameTimeVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var cancelView: UIButton!
    private var titleLabel: UILabel!
    private var okButton: UIButton!
    private var otherTimeButton: UIButton!
    private var cancelButton: UIButton!
    private var countryButton: OvalCountryButton!
    private var doneButton: UIButton!

    var selectedMinutes: Int?
    var selectedPeriods: Int?
    private var shouldPassSelection: Bool = false
    private var currentGameMinutes: Int!
    private var currentGamePeriods: Int!

    private var titleText: String?
    private var onDismiss: ((Bool, Int?, Int?) -> Void)?
    private var cards: [DurationCard] = []
    private var skipAnimations: Bool = false
    private var haptic: UISelectionFeedbackGenerator?

    private let buttonHorInset = UIDevice.whenDeviceIs(small: 20, normal: 35, big: 35)
    private var padding: CGFloat {
        return (UIDevice.deviceSize != .small && cards.count > 4) ? 18 : 12
    }
    private var cardWidth: CGFloat {
        return view.bounds.width * 0.35
    }
    
    
    // MARK: - Life Cycle
    
    init(titleText: String? = nil, currentGamePeriods: Int, currentGameMinutes: Int, onDismiss: ((Bool, Int?, Int?) -> Void)? = nil) {
        
        self.titleText = titleText
        self.currentGamePeriods = currentGamePeriods
        self.currentGameMinutes = currentGameMinutes
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
        
        cancelView = UIButton()
        cancelView.addTarget(self, action: #selector(cancelViewTapped(sender:forEvent:)), for: [.touchUpInside])
        cancelView.translatesAutoresizingMaskIntoConstraints = false
        cancelView.backgroundColor = UIColor.clear
        cancelView.isUserInteractionEnabled = false
        view.insertSubview(cancelView, at: 0)
        
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
        
        let otherTimeColor = UIColor(named: ColorName.PantoneYellow)!
        otherTimeButton = createButton(color: otherTimeColor)
        otherTimeButton.setTitleColor(UIColor(named: ColorName.VeryDarkBlue)!, for: .normal)
        otherTimeButton.setTitle(LS_BUTTON_OTHER_TIME, for: .normal)
        otherTimeButton.addTarget(self, action: #selector(otherTimeTapped), for: [.touchUpInside])
        view.addSubview(otherTimeButton)
        
        let cancelColor = UIColor(named: ColorName.PantoneRed)!
        cancelButton = createButton(color: cancelColor)
        cancelButton.setTitle(LS_BUTTON_CANCEL, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: [.touchUpInside])
        view.addSubview(cancelButton!)
        
        countryButton = OvalCountryButton(capitals: SELECTED_COUNTRY.capitals, color: UIColor(named: ColorName.DarkBlueText)!, crossColor: .white)
        countryButton.translatesAutoresizingMaskIntoConstraints = false
        countryButton.addTarget(self, action: #selector(countryButtonTapped), for: .touchUpInside)
        view.addSubview(countryButton)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        okButton.alpha = 0.0
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
        
        prepareHaptic()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        onDismiss?(shouldPassSelection, selectedMinutes, selectedPeriods)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        guard !skipAnimations else { return }
        for card in self.cards {
            card.windUp()
        }
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDarkMode), name: .DarkModeSettingsChanged, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let countryWidth: CGFloat = 44
        let countryHeight: CGFloat = 44
        let buttonHeight = UIDevice.whenDeviceIs(small: 44, normal: 50, big: 54)
        let buttonBottomInset: CGFloat = UIDevice.whenDeviceIs(small: 12, normal: 16, big: 20)
        let buttonPadding: CGFloat = UIDevice.whenDeviceIs(small: 10, normal: 12, big: 16)
        let countryTopInset: CGFloat = UIDevice.whenDeviceIs(small: 0, normal: 12, big: 12)
        
        NSLayoutConstraint.activate([
            
            cancelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cancelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cancelView.topAnchor.constraint(equalTo: view.topAnchor),
            cancelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            countryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            countryButton.widthAnchor.constraint(equalToConstant: countryWidth),
            countryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: countryTopInset),
            countryButton.heightAnchor.constraint(equalToConstant: countryHeight),
            
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            okButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: buttonHorInset),
            okButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -buttonHorInset),
            okButton.bottomAnchor.constraint(equalTo: otherTimeButton.topAnchor, constant: -buttonPadding),
            okButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            otherTimeButton.leadingAnchor.constraint(equalTo: okButton.leadingAnchor),
            otherTimeButton.trailingAnchor.constraint(equalTo: okButton.trailingAnchor),
            otherTimeButton.bottomAnchor.constraint(equalTo: cancelButton!.topAnchor, constant: -buttonPadding),
            otherTimeButton.heightAnchor.constraint(equalTo: okButton.heightAnchor),
                       
            cancelButton.leadingAnchor.constraint(equalTo: okButton.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: okButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalTo: okButton.heightAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -buttonBottomInset),

            ])
        
        addCardConstraints()
    }
    
    private func addCardConstraints() {
        
        let topInset = UIDevice.whenDeviceIs(small: 20, normal: 40, big: 60)
                
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
    
    func clearSelectedDuration() {
        
        cards.forEach {
            $0.alpha = 1.0
        }
        selectedMinutes = nil
        selectedPeriods = nil
        UIView.animate(withDuration: 0.2, animations: {
            self.okButton.alpha = 0.0
        })
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func okTapped() {
        
        shouldPassSelection = true
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func otherTimeTapped() {
        
        clearSelectedDuration()
        
        let vc = CustomGameTimeVC(titleText: LS_TITLE_CUSTOM_TIME, currentGamePeriods: currentGamePeriods, currentGameMinutes: currentGameMinutes) { (shouldPassSelection, selectedMinutes, selectedPeriods) in
            
            if shouldPassSelection {
                self.selectedMinutes = selectedMinutes
                self.selectedPeriods = selectedPeriods
                self.shouldPassSelection = true
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        present(vc, animated: true, completion: nil)
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
    
    @objc private func handleCardTapped(sender: DurationCard, forEvent event: UIEvent) {
        
        doHaptic()
        
        if sender.minutes == selectedMinutes && sender.periods == selectedPeriods {
            // user tapped twice on same card
            clearSelectedDuration()
            prepareHaptic()
            return
        }
        
        handleSelection(card: sender)
        prepareHaptic()
    }
    
    @objc private func cancelViewTapped(sender: UIButton, forEvent event: UIEvent) {
        
        cancelView.isUserInteractionEnabled = false
        cards.forEach {
            $0.alpha = 1.0
        }
        selectedMinutes = nil
        selectedPeriods = nil
        UIView.animate(withDuration: 0.2, animations: {
            self.okButton.alpha = 0.0
        })
    }
    
    @objc private func countryButtonTapped() {
        
        let vc = CountryVC(titleText: LS_TITLE_COUNTRY, onDismiss: {
            self.buildCards()
            self.countryButton.setCapitals(SELECTED_COUNTRY.capitals)
        })
        present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - Actions

    
    
    
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
        
        let numberOfCards = min(SELECTED_COUNTRY.minutes.count, 4)
        for index in 0 ..< numberOfCards {
            
            let minutes = SELECTED_COUNTRY.minutes[index]
            let periods = SELECTED_COUNTRY.periods[index]
            let card = DurationCard(minutes: minutes, periods: periods)
            cards.append(card)
            card.addTarget(self, action: #selector(handleCardTapped(sender:forEvent:)), for: [.touchUpInside])
            card.setMinutes(minutes, minutesString: SELECTED_COUNTRY.minutesStrings[index], periods: periods, animated: true, delay: 0.1 * Double(index))
            
            switch index % 4 {
            case 0:
                card.updateColor(UIColor(named: ColorName.Olive)!)
            case 1:
                card.updateColor(UIColor(named: ColorName.VeryDarkBlue_Red)!)
            case 2:
                card.updateColor(UIColor(named: ColorName.LightYellow)!)
            case 3:
                card.updateColor(UIColor(named: ColorName.LightBlue)!)
            default:
                fatalError("Trying to update card color with wrong index")
            }
            
            view.addSubview(card)
        }
        
        addCardConstraints()
    }
    
    private func handleSelection(card: DurationCard) {
        
        self.cancelView.isUserInteractionEnabled = true
        selectedMinutes = card.minutes
        selectedPeriods = card.periods
        card.alpha = 1.0
        UIView.animate(withDuration: 0.2, animations: {
            self.cards.forEach {
                if !($0.isEqual(card)) {
                    $0.alpha = 0.3
                }
            }
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.okButton.alpha = 1.0
        })
    }
    
    private func showAlertNewGame() {
        
        skipAnimations = true
        let askConfirmationVC = SimpleAlertVC(titleText: LS_WARNINGNEWGAME_TITLE, text: LS_WARNINGGAMERUNNING, okButtonText: "OK", cancelButtonText: LS_BUTTON_CANCEL, okAction: {
            self.skipAnimations = false
        }, cancelAction: {
            self.selectedPeriods = nil
            self.skipAnimations = false
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


