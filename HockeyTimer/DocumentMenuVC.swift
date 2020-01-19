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


class DocumentMenuVC: PanArrowVC {

    
    // MARK: - Properties
    
    private var rulesList: RulesList!
    private var countryButton: OvalCountryButton!
    private var reportButton: UIButton!
    
    private let productURL = URL(string: "https://apps.apple.com/app/id1464432452")!

    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
        view.backgroundColor = UIColor(named: ColorName.Olive_Black)!
        
        rulesList = RulesList(delegate: self, country: SELECTED_COUNTRY)
        rulesList.backgroundColor = UIColor.clear
        view.addSubview(rulesList)
        view.sendSubviewToBack(rulesList)
        
        panArrowUp.color = .white
        panArrowDown.alpha = 0.0
        panArrowUpLabel.alpha = 0.0
        panArrowDownLabel.alpha = 0.0
        panArrowUpLabel.textColor = UIColor(named: ColorName.VeryDarkBlue)!
        
        countryButton = OvalCountryButton(capitals: SELECTED_COUNTRY.capitals, color: .white, crossColor: .white)
        countryButton.translatesAutoresizingMaskIntoConstraints = false
        countryButton.addTarget(self, action: #selector(countryButtonTapped), for: .touchUpInside)
        view.addSubview(countryButton)
        
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
        let buttonWidth: CGFloat = 44
        let buttonHeight: CGFloat = 44
        let buttonHorInset: CGFloat = UIDevice.whenDeviceIs(small: 37, normal: 42, big: 42)
        let buttonTopInset: CGFloat = UIDevice.whenDeviceIs(small: 30, normal: 45, big: 45)

        NSLayoutConstraint.activate([
            
            rulesList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rulesList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rulesList.topAnchor.constraint(equalTo: view.topAnchor),
            rulesList.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            reportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reportButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -reportConstant),
            
            countryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: buttonHorInset),
            countryButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            countryButton.topAnchor.constraint(equalTo: view.topAnchor, constant: buttonTopInset),
            countryButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            ])
    }
    
    
    
    // MARK: - Public Methods
    
    func animateFlyIn() {
        
        rulesList.animateFlyIn()
    }
    
    
    // MARK: - Touch
    
    @objc private func reportButtonTapped() {
        
        if MFMailComposeViewController.canSendMail() {
            let body = emailBody(withAddedString: emailString())
            presentEmail(body: body)
            
        } else {
            showEmailAlert()
        }
    }
    
    @objc private func countryButtonTapped() {
        
        let vc = CountryVC(titleText: "Country", onDismiss: {
            self.rulesList.setCountry(SELECTED_COUNTRY)
            self.countryButton.setCapitals(SELECTED_COUNTRY.capitals)
        })
        present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - Private Methods
    
    private func emailBody(withAddedString added: String) -> String {
        
        var body = "<p>" + "We welcome your remark or suggestion, which could improve HockeyUpp for you and for all users." + "</p><br><br><br><br>"
        body += added
        return body
    }
    
    private func emailString() -> String {
        
        var result = "<hr>"
        
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "*.*"
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "*"
        let premium = ""
        #warning("add next line")
            // UserDefaults.standard.bool(forKey: UserDefaultKey.PremiumMode) ? "P" : ""
        result += "Version " + appVersion + premium + " - Build " + buildNumber
        
        let iosVersion = UIDevice.current.systemVersion
        let add = result.count > 4 ? " - iOS " + iosVersion : "iOS " + iosVersion
        result += add
        
        let country = Products.store.appStoreCountry ?? "Unknown country"
        result += result.count > 4 ? " - Country " + country : "Country " + country
        
        return result
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


// MARK: - MFMailComposeViewControllerDelegate

extension DocumentMenuVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
    }
}



