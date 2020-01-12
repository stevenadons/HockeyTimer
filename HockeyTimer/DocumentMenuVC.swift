//
//  DocumentMenuVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit
import MessageUI
import LinkPresentation
//import PDFKit


class DocumentMenuVC: PanArrowVC {

    
    // MARK: - Properties
    
    private var rulesList: RulesList!
    private var countryMenu: CountryMenu!
    private var settingsMenu: DotMenu!
    private var reportButton: UIButton!
    
    private let productURL = URL(string: "https://apps.apple.com/app/id1464432452")!

    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if !FeatureFlags.darkModeCanBeEnabled {
            overrideUserInterfaceStyle = .light
        }
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        animateFlyIn()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        
        rulesList.windUp()
        super.viewDidDisappear(animated)
    }
    
    private func setup() {
        
        view.backgroundColor = UIColor(named: ColorName.Olive)!
        
        rulesList = RulesList(delegate: self, country: SELECTED_COUNTRY)
        rulesList.backgroundColor = UIColor.clear
        view.addSubview(rulesList)
        view.sendSubviewToBack(rulesList)
        
        panArrowUp.color = UIColor.white
        panArrowDown.alpha = 0.0
        panArrowUpLabel.alpha = 0.0
        panArrowDownLabel.alpha = 0.0
        panArrowUpLabel.textColor = UIColor(named: ColorName.VeryDarkBlue)!
        
        reportButton = UIButton()
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.titleLabel?.numberOfLines = 0
        reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
        
        let plainTitle = LS_REPORT_ERROR
        var lengthOfFirstRange = 6
        if Locale.current.languageCode == "nl" {
            lengthOfFirstRange = 4
        }
        let attributedTitle = NSMutableAttributedString(string: plainTitle)
        let firstRange = NSRange(location: 0, length: lengthOfFirstRange)
        attributedTitle.addAttribute(.font, value: UIFont(name: FONTNAME.ThemeBlack, size: 13)!, range: firstRange)
        let lastRange = NSRange(location: firstRange.length, length: plainTitle.count - firstRange.length)
        attributedTitle.addAttribute(.font, value: UIFont(name: FONTNAME.ThemeRegular, size: 13)!, range: lastRange)
        let fullRange = NSRange(location: 0, length: plainTitle.count)
        attributedTitle.addAttribute(.foregroundColor, value: UIColor.white, range: fullRange)
        reportButton.setAttributedTitle(attributedTitle, for: .normal)
        
        view.addSubview(reportButton)
        
        let reportConstant: CGFloat = UIDevice.whenDeviceIs(small: 10, normal: 12, big: 18)
        
        NSLayoutConstraint.activate([
            
            rulesList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rulesList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rulesList.topAnchor.constraint(equalTo: view.topAnchor),
            rulesList.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            reportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reportButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -reportConstant),
            
            ])
        
        countryMenu = CountryMenu(inView: view,
                                  condensedColor: .white,
                                  foldOutColor: UIColor(named: ColorName.OliveText)!,
                                  delegate: self,
                                  labelNames: Country.allNames(),
                                  capitalsStrings: Country.allCapitals(),
                                  selected: CountryDataManager.shared.countries.firstIndex(of: SELECTED_COUNTRY))
        
        settingsMenu = DotMenu(inView: view,
                               condensedColor: .white,
                               foldOutColor: UIColor(named: ColorName.OliveText)!,
                               delegate: self,
                               labelNames: [LS_SETTINGS_WRITE_A_REVIEW, LS_SETTINGS_SHARE, LS_SETTINGS_CONTACT])
    }
    
    
    
    // MARK: - Public Methods
    
    func hideMenus() {
        
        countryMenu.hideButtons(animated: false)
        settingsMenu.hideButtons(animated: false)
    }
    
    func animateFlyIn() {
        
        rulesList.animateFlyIn()
    }
    
    
    // MARK: - Touch
    
    @objc private func reportButtonTapped() {
        
        sendEmail()
    }

    
    
}


extension DocumentMenuVC: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        
        if MFMailComposeViewController.canSendMail() {
            let body = emailBody()
            presentEmail(body: body)

        } else {
            showEmailAlert()
        }
    }
    
    private func emailBody() -> String {
        
        let sentence = "<p>" + LS_EMAIL_SENTENCE + "</p><br><br><br><br><hr>"
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0"
        let version = LS_EMAIL_VERSION + appVersion
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
        let build = " - " + LS_EMAIL_BUILD + buildNumber
        let premiumSuffix = UserDefaults.standard.bool(forKey: UserDefaultsKey.PremiumMode) ? "P" : ""
        let country = " - " + SELECTED_COUNTRY.capitals
        let iOS = " - " + LS_EMAIL_IOS + UIDevice.current.systemVersion
        let dataStatus = "<br>" + CountryDataManager.shared.statusString()
        
        return sentence + version + build + premiumSuffix + country + iOS + dataStatus
    }
    
    private func presentEmail(body: String) {
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["tocommit.appbuilders@gmail.com"])
        mail.setSubject(LS_EMAIL_SUBJECT)
        mail.setMessageBody(body, isHTML: true)
        
        present(mail, animated: true)
    }
    
    private func showEmailAlert() {
        
        let alert = UIAlertController(title: LS_EMAIL_EMAILERROR_TITLE, message: LS_EMAIL_EMAILERROR_TEXT, preferredStyle: .alert)
        let ok = UIAlertAction(title: LS_BUYPREMIUM_OK, style: .default, handler: nil)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
    }
}


extension DocumentMenuVC: RulesListDelegate {
    
    func handleButtonTapped(sender: RulesButton) {
        
        var url: URL? = sender.rules.url
        
        if let specificUrls = sender.rules.specificLocaleUrls, let currentLanguage = Locale.current.languageCode, let specificUrl = specificUrls[currentLanguage] as? URL {
            url = specificUrl
        }
        
        if url != nil {
            UIApplication.shared.open(url!)
        }
    }
}



extension DocumentMenuVC: CountryMenuDelegate {
    
    func handleCountryMenuMainButtonTapped() {
        
        if let settingsIndex = view.subviews.firstIndex(of: settingsMenu), let countryIndex = view.subviews.firstIndex(of: countryMenu), settingsIndex > countryIndex {
            view.exchangeSubview(at: settingsIndex, withSubviewAt: countryIndex)
        }
        
    }
    
    func handleCountryMenuOtherButtonTapped(buttonNumber: Int) {
        
        guard CountryDataManager.shared.countries[buttonNumber] != SELECTED_COUNTRY else { return }
        
        SELECTED_COUNTRY = CountryDataManager.shared.countries[buttonNumber]
        rulesList.setCountry(SELECTED_COUNTRY)
    }
    
    func didShowButtons() {
        
        pageVC?.showBackgroundMask()
        
    }
    
    func willHideButtons() {
        
        pageVC?.hideBackgroundMask()
    }
}


extension DocumentMenuVC: DotMenuDelegate {
    
    func handleDotMenuMainButtonTapped() {
        
        if let settingsIndex = view.subviews.firstIndex(of: settingsMenu), let countryIndex = view.subviews.firstIndex(of: countryMenu), settingsIndex < countryIndex {
            view.exchangeSubview(at: settingsIndex, withSubviewAt: countryIndex)
        }
    }
    
    func handleDotMenuOtherButtonTapped(buttonNumber: Int) {
        
        switch buttonNumber {
        case 0:
            // Write review
            var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
            guard let writeReviewURL = components?.url else { return }
            UIApplication.shared.open(writeReviewURL)
            
        case 1:
            // Share app
            // Conform to UIActivityItemSource for custom activityItems
            let activityViewController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        
        case 2:
            // Send email
            sendEmail()
        
        default:
            print("default")
        }
    }
    
    func dotMenuDidShowButtons() {
        
        pageVC?.showBackgroundMask()
        
    }
    
    func dotMenuWillHideButtons() {
        
        pageVC?.hideBackgroundMask()
    }
}


extension DocumentMenuVC: UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        
        return productURL

    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        if activityType == .postToTwitter {
            return "Download #HockeyUpp on the App Store"
        }
        return productURL
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        
        return "HockeyUpp - Your field hockey companion"
    }
    
    @available(iOS 13.0, *)
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        
        let metadata = LPLinkMetadata()
        metadata.originalURL = productURL
        metadata.url = metadata.originalURL
        metadata.title = "Share HockeyUpp"
        metadata.imageProvider = NSItemProvider.init(contentsOf: Bundle.main.url(forResource: "Icon-Spotlight-40@3x", withExtension: "png"))
        return metadata
    }
    
    
    
}
