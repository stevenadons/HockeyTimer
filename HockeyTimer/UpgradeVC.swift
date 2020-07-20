//
//  UpgradeVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 19/07/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit
import StoreKit
import Network


class UpgradeVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var titleLabel: UILabel!
    private var scrollView: UIScrollView!
    private var slides: [FeatureView] = []
    private var pageControl: UIPageControl!
    private var buyPremiumButton: UIButton!
    private var cancelButton: UIButton!
    private var restorePurchaseButton: UIButton!
    private var maskWithActivityIndicator: MaskWithActivityIndicator?
    
    private var features: [PremiumFeature] = []
    private var afterDismiss: ((Bool) -> Void)?
    private var purchased: Bool = false
    private var products: [SKProduct] = []
    private var titleText: String = "Premium Mode"
    private let numberOfSlides: Int = 4
    
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
    
    init(features: [PremiumFeature], afterDismiss: ((Bool) -> Void)? = nil) {
        
        self.features = features
        self.afterDismiss = afterDismiss
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
            print("not in premium mode")
        })
        
        setupUI()
        addConstraints()
        setupSlides()
        addNetworkMonitor()
        addObservers()
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
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = numberOfSlides
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(named: ColorName.DarkBlueText)!
        pageControl.currentPageIndicatorTintColor = UIColor(named: ColorName.LightYellow)!
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
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
        
        let buttonHeight = UIDevice.whenDeviceIs(small: 44, normal: 50, big: 54)
        let buttonPadding: CGFloat = UIDevice.whenDeviceIs(small: 10, normal: 12, big: 16)
        let horInset = UIDevice.whenDeviceIs(small: 20, normal: 35, big: 35)
        
        // Referring to view.safeAreaLayoutGuide will cause glitch for titleLabel
        // When newVC is being presented
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),

            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 26),
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -6),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            pageControl.widthAnchor.constraint(equalToConstant: 50),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: buyPremiumButton.topAnchor, constant: -12),
            
            buyPremiumButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horInset),
            buyPremiumButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horInset),
            buyPremiumButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -buttonPadding),
            buyPremiumButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            cancelButton.leadingAnchor.constraint(equalTo: buyPremiumButton.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: buyPremiumButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalTo: buyPremiumButton.heightAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: restorePurchaseButton.topAnchor, constant: -8),
            
            restorePurchaseButton.leadingAnchor.constraint(equalTo: buyPremiumButton.leadingAnchor),
            restorePurchaseButton.trailingAnchor.constraint(equalTo: buyPremiumButton.trailingAnchor),
            restorePurchaseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            ])
    }
    
    private func setupSlides() {
        
        for feature in features {
            let slide = FeatureView(feature: feature)
            slides.append(slide)
            scrollView.addSubview(slide)
        }
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
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let slideWidth = scrollView.frame.size.width
        let slideHeight = scrollView.frame.size.height
        
        scrollView.contentSize = CGSize(width: slideWidth * CGFloat(numberOfSlides), height: slideHeight)
        for index in 0..<slides.count {
            slides[index].frame = CGRect(x: slideWidth * CGFloat(index), y: 0, width: slideWidth, height: slideHeight)
        }
        view.bringSubviewToFront(pageControl)
        
        pageControl.pageIndicatorTintColor = UIColor(named: ColorName.DarkBlueText)!
        pageControl.currentPageIndicatorTintColor = UIColor(named: ColorName.LightYellow)!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        afterDismiss?(purchased)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        checkDarkMode()
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func buyPremiumTapped() {
        
        guard !products.isEmpty else { return }
        
        if networkMonitor.currentPath.status == .unsatisfied {
            
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

    
    // MARK: - Notification Methods
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        
        purchased = true
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleTransactionEndedNotification() {
        
        maskWithActivityIndicator?.removeFromSuperview()
    }
}


extension UpgradeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Update page when more than 50% of next or previous page is visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth)) + 1
        pageControl.currentPage = page
    }
}

