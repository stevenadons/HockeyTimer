//
//  BuyPremiumVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 19/05/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit
import StoreKit
import Network
import GoogleMobileAds


class BuyPremiumVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var titleLabel: UILabel!
    private var textLabel: UILabel!
    private var buyPremiumButton: UIButton!
    private var watchAdButton: UIButton!
    private var cancelButton: UIButton!
    private var restorePurchaseButton: UIButton!
    private var maskWithActivityIndicator: MaskWithActivityIndicator?
    
    private var afterDismiss: ((Bool) -> Void)?
    private var rewardEarned: Bool = false
    private var products: [SKProduct] = []
    private var titleText: String!
    private var text: String!
    private var shouldShowFirstButton: Bool = true
    
    private var interstitial: GADInterstitial?
    private var isShowingInterstitial: Bool = false

    
    @available(iOS 12,*)
    var networkMonitor: NWPathMonitor! {
        get {
            return _networkMonitor as? NWPathMonitor
        }
        set {
            _networkMonitor = newValue
        }
    }
    private var _networkMonitor: AnyObject!


    // MARK: - Life Cycle
    
    init(title: String, text: String, showFirstButton: Bool, afterDismiss: ((Bool) -> Void)? = nil) {
        
        self.afterDismiss = afterDismiss
        self.titleText = title
        self.text = text
        self.shouldShowFirstButton = showFirstButton
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
        
        products = appStoreProducts
        
        AppDelegate.checkIfInPremiumMode(ifNot: {
            self.interstitial = self.createAndLoadInterstitial()
        })
        
        setupUI()
        addConstraints()
        addNetworkMonitor()
        addObservers()
    }
    
    private func createAndLoadInterstitial() -> GADInterstitial {
        
        // For testing
//        #warning("interstitial in test mode")
//        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        // For real
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2043391878522550/9706444069")
        
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = titleText
        titleLabel.font = UIFont(name: FONTNAME.ThemeBlack, size: 32)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.text = text
        textLabel.font = UIFont(name: FONTNAME.ThemeRegular, size: 16)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textColor = .label
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        watchAdButton = ConfirmationButton.yellowButton(largeFont: true)
        let price: NSNumber = 0.0
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .behavior10_4
        let formattedPrice = formatter.string(from: price) ?? "\(price)"
        let buttonTitle = LS_BUYPREMIUM_WATCHADBUTTON + " (" + formattedPrice + ")"
        watchAdButton.setTitle(buttonTitle, for: .normal)
        watchAdButton.addTarget(self, action: #selector(watchAdTapped), for: [.touchUpInside])
        watchAdButton.alpha = shouldShowFirstButton ? 1.0 : 0.0
        view.addSubview(watchAdButton)
        
        buyPremiumButton = ConfirmationButton.blueButton(largeFont: true)
        buyPremiumButton.setTitle(LS_BUYPREMIUM_BUYBUTTON, for: .normal)
        buyPremiumButton.addTarget(self, action: #selector(buyPremiumTapped), for: [.touchUpInside])
        if products.count > 0 {
            let priceString = products[0].formattedPrice()
            let titleString = LS_BUYPREMIUM_BUYBUTTON + " (" + priceString + ")"
            buyPremiumButton.setTitle(titleString, for: .normal)
        }
        view.addSubview(buyPremiumButton)
        
        cancelButton = ConfirmationButton.redButton(largeFont: true)
        cancelButton.setTitle(LS_BUYPREMIUM_CANCELBUTTON, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: [.touchUpInside])
        view.addSubview(cancelButton)
        
        restorePurchaseButton = UIButton()
        restorePurchaseButton.translatesAutoresizingMaskIntoConstraints = false
        restorePurchaseButton.titleLabel?.numberOfLines = 0
        restorePurchaseButton.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        
        let plainTitle = LS_BUYPREMIUM_RESTORELABEL
        var lengthOfFirstRange = 26
        if Locale.current.languageCode == "nl" {
            lengthOfFirstRange = 24
        }
        let attributedTitle = NSMutableAttributedString(string: plainTitle)
        let firstRange = NSRange(location: 0, length: lengthOfFirstRange)
        attributedTitle.addAttribute(.font, value: UIFont(name: FONTNAME.ThemeRegular, size: 13)!, range: firstRange)
        let lastRange = NSRange(location: firstRange.length, length: plainTitle.count - firstRange.length)
        attributedTitle.addAttribute(.font, value: UIFont(name: FONTNAME.ThemeBlack, size: 13)!, range: lastRange)
        let fullRange = NSRange(location: 0, length: plainTitle.count)
        attributedTitle.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: fullRange)
        restorePurchaseButton.setAttributedTitle(attributedTitle, for: .normal)
        
        view.addSubview(restorePurchaseButton)
    }
    
    private func addConstraints() {
        
        let buttonHeight = UIDevice.whenDeviceIs(small: 44, normal: 54, big: 54)
        let horInset = UIDevice.whenDeviceIs(small: 20, normal: 35, big: 35)
        let topInset = UIDevice.whenDeviceIs(small: 30, normal: 50, big: 75)
        
        // Referring to view.safeAreaLayoutGuide will cause glitch for titleLabel
        // When newVC is being presented
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topInset),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),

            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horInset * 1.5),
            textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horInset * 1.5),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textLabel.bottomAnchor.constraint(equalTo: watchAdButton.topAnchor, constant: -40),

            watchAdButton.leadingAnchor.constraint(equalTo: buyPremiumButton.leadingAnchor),
            watchAdButton.trailingAnchor.constraint(equalTo: buyPremiumButton.trailingAnchor),
            watchAdButton.heightAnchor.constraint(equalTo: buyPremiumButton.heightAnchor),
            watchAdButton.bottomAnchor.constraint(equalTo: buyPremiumButton.topAnchor, constant: -16),
            
            buyPremiumButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horInset),
            buyPremiumButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horInset),
            buyPremiumButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16),
            buyPremiumButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            cancelButton.leadingAnchor.constraint(equalTo: buyPremiumButton.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: buyPremiumButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalTo: buyPremiumButton.heightAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: restorePurchaseButton.topAnchor, constant: -20),
            
            restorePurchaseButton.leadingAnchor.constraint(equalTo: buyPremiumButton.leadingAnchor),
            restorePurchaseButton.trailingAnchor.constraint(equalTo: buyPremiumButton.trailingAnchor),
            restorePurchaseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            ])
    }
    
    private func addNetworkMonitor() {
        
        if #available(iOS 12, *) {
            networkMonitor = NWPathMonitor()
            let networkQueue = DispatchQueue(label: "networking")
            networkMonitor.start(queue: networkQueue)
        }
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePurchaseNotification(_:)),
                                               name: .PurchaseNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleTransactionEndedNotification),
                                               name: .TransactionEndedNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkDarkMode),
                                               name: .DarkModeSettingsChanged, object:
            nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)

        if !isShowingInterstitial {
            afterDismiss?(rewardEarned)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        checkDarkMode()
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func buyPremiumTapped() {
        
        guard !products.isEmpty else { return }
        
        if #available(iOS 12, *), networkMonitor.currentPath.status == .unsatisfied {
            
            let alert = UIAlertController(title: LS_BUYPREMIUM_NOINTERNET_TITLE,
                                          message: LS_BUYPREMIUM_CHECKCONNECTION_TITLE,
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: LS_BUYPREMIUM_OK,
                                   style: .default,
                                   handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            
        } else {
            
            maskWithActivityIndicator = MaskWithActivityIndicator.init(inView: view)
            Products.store.buy(products[0])
        }
    }
    
    @objc private func watchAdTapped() {
        
        rewardEarned = true
        DispatchQueue.main.async {
            self.showInterstitial()
        }
    }
    
    @objc private func restoreTapped() {
        
        Products.store.restorePurchases()
    }
    
    @objc private func cancelTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
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

    
    
    // MARK: - GAD Interstitial
    
    private func showInterstitial() {
        
        if let interstitial = interstitial, interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    
    
    // MARK: - Notification Methods
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        
        print("handlePurchaseNotification")
        rewardEarned = true
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleTransactionEndedNotification() {
        
        print("handleTransactionEndedNotification")
        
        maskWithActivityIndicator?.removeFromSuperview()
    }
}



extension BuyPremiumVC: GADInterstitialDelegate {
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        
        isShowingInterstitial = true
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {

        isShowingInterstitial = false

        // Most use cases: load a new interstitial here
//        interstitial = createAndLoadInterstitial()

        dismiss(animated: true, completion: nil)
    }
}


