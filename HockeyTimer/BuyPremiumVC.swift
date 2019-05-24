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
    
    init(afterDismiss: ((Bool) -> Void)? = nil) {
        
        self.afterDismiss = afterDismiss
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        products = appStoreProducts
        
        setupUI()
        addConstraints()
        addNetworkMonitor()
        addObservers()
    }
    
    private func setupUI() {
        
        view.backgroundColor = COLOR.VeryDarkBlue
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = LS_BUYPREMIUM_TITLE
        titleLabel.font = UIFont(name: FONTNAME.ThemeBold, size: 28)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = COLOR.White
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.text = LS_BUYPREMIUM_TEXT
        textLabel.font = UIFont(name: FONTNAME.ThemeRegular, size: 16)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textColor = COLOR.White
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        buyPremiumButton = ConfirmationButton.blueButton(largeFont: true)
        buyPremiumButton.setTitle(LS_BUYPREMIUM_BUYBUTTON, for: .normal)
        buyPremiumButton.addTarget(self, action: #selector(buyPremiumTapped), for: [.touchUpInside])
        if products.count > 0 {
            let priceString = products[0].formattedPrice()
            let titleString = LS_BUYPREMIUM_BUYBUTTON + " (" + priceString + ")"
            buyPremiumButton.setTitle(titleString, for: .normal)
        }
        view.addSubview(buyPremiumButton)
        
        watchAdButton = ConfirmationButton.yellowButton(largeFont: true)
        watchAdButton.setTitle(LS_BUYPREMIUM_WATCHADBUTTON, for: .normal)
        watchAdButton.addTarget(self, action: #selector(watchAdTapped), for: [.touchUpInside])
        view.addSubview(watchAdButton)
        
        cancelButton = ConfirmationButton.invertedYellowButton(largeFont: true)
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
        attributedTitle.addAttribute(.font, value: UIFont(name: FONTNAME.ThemeBold, size: 13)!, range: lastRange)
        let fullRange = NSRange(location: 0, length: plainTitle.count)
        attributedTitle.addAttribute(.foregroundColor, value: UIColor.lightGray.lighter(), range: fullRange)
        restorePurchaseButton.setAttributedTitle(attributedTitle, for: .normal)
        
        view.addSubview(restorePurchaseButton)
    }
    
    private func addConstraints() {
        
        let buttonHeight: CGFloat = UIScreen.main.bounds.height >= 600 ? 54 : 44
        let horInset: CGFloat = UIScreen.main.bounds.height >= 600 ? 35 : 20
        let topInset: CGFloat = UIScreen.main.bounds.height >= 600 ? 40 : 20
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topInset),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),

            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horInset * 1.5),
            textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horInset * 1.5),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textLabel.bottomAnchor.constraint(equalTo: buyPremiumButton.topAnchor, constant: -40),
            
            buyPremiumButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horInset),
            buyPremiumButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horInset),
            buyPremiumButton.bottomAnchor.constraint(equalTo: watchAdButton.topAnchor, constant: -18),
            buyPremiumButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            watchAdButton.leadingAnchor.constraint(equalTo: buyPremiumButton.leadingAnchor),
            watchAdButton.trailingAnchor.constraint(equalTo: buyPremiumButton.trailingAnchor),
            watchAdButton.heightAnchor.constraint(equalTo: buyPremiumButton.heightAnchor),
            watchAdButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -18),
            
            cancelButton.leadingAnchor.constraint(equalTo: buyPremiumButton.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: buyPremiumButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalTo: buyPremiumButton.heightAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: restorePurchaseButton.topAnchor, constant: -44),
            
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
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        afterDismiss?(rewardEarned)
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
        
        print("Displaying ad")
        DispatchQueue.main.async { [weak self] in
            self?.rewardEarned = true
            self?.dismiss(animated: true, completion: nil)
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
