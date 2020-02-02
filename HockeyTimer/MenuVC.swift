//
//  MenuVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 18/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit
import LinkPresentation
import MessageUI


class MenuVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var titleLabel: UILabel!
    private var tableView: UITableView!
    private var doneButton: UIButton!
    
    private let headerTitles: [String] = [LS_MENU_HEADER_USER_SETTINGS,
                                          LS_MENU_HEADER_DARK_MODE,
                                          LS_MENU_HEADER_FEEDBACK]
       
    private let userSettingsText: [String] = [LS_MENU_CHANGE_APP_ICON]
    
    private let darkModeText: [String] = [LS_MENU_ALWAYS_DARK,
                                           LS_MENU_NEVER_DARK,
                                           LS_MENU_WHEN_PHONE_IN_DARK]

    private let feedbackText: [String] = [LS_MENU_SHARE,
                                          LS_MENU_CONTACT_US,
                                          LS_MENU_REVIEW,
                                          LS_MENU_PRIVACY_POLICY]
    
    private let feedbackImageNames: [String] = ["square.and.arrow.up",
                                                "envelope",
                                                "square.and.pencil",
                                                "checkmark.shield"]
    
    private let productURL = URL(string: "https://apps.apple.com/app/id1464432452")!
    private let websiteURLString = "https://stevenadons.wixsite.com/hockeyupp"

   
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        checkToggles()
        checkDarkMode()
        addObservers()
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .coverVertical
        
        setupUI()
        addConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = LS_TITLE_SETTINGS
        titleLabel.font = UIFont(name: FONTNAME.ThemeBlack, size: 28)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.separatorColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        // Make the viewcontroller dismissable by swiping down
        // Setting isScrollEnabled to false will not work for this
        tableView.panGestureRecognizer.isEnabled = false
        view.addSubview(tableView)
        
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle(LS_BUTTON_DONE, for: .normal)
        doneButton.addTarget(self, action: #selector(doneTapped), for: [.touchUpInside])
        doneButton.setTitleColor(UIColor(named: ColorName.DarkBlueText)!, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 16)
        view.addSubview(doneButton)
    }
    
    private func addConstraints() {
        
        let tableViewHorInset: CGFloat = 9
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tableViewHorInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tableViewHorInset),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        checkDarkMode()
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDarkMode), name: .DarkModeSettingsChanged, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func doneTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func switchChanged(_ item: UISwitch) {
        
        guard UserDefaults.standard.bool(forKey: UserDefaultsKey.PremiumMode) else {
            
            item.setOn(!item.isOn, animated: true)
            
            let buyPremiumVC = BuyPremiumVC(title: LS_BUYPREMIUM_TITLE_DARK_MODE, text: LS_BUYPREMIUM_TEXT_DARK_MODE, showFirstButton: false, afterDismiss: { earned in
                if earned {
                    item.setOn(!item.isOn, animated: true)
                }
            })
            present(buyPremiumVC, animated: true, completion: nil)
            
            return
        }
        
        if item.isOn {
            
            switch darkModeText[item.tag] {
            case LS_MENU_ALWAYS_DARK:
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.AlwaysDarkMode)
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.AlwaysLightMode)
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings)

            case LS_MENU_NEVER_DARK:
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.AlwaysDarkMode)
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.AlwaysLightMode)
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings)

            case LS_MENU_WHEN_PHONE_IN_DARK:
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.AlwaysDarkMode)
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.AlwaysLightMode)
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings)
                
            default:
                fatalError("Did select menu item which does not exist")
            }
            
        } else {
            
            switch darkModeText[item.tag] {
            case LS_MENU_ALWAYS_DARK:
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.AlwaysDarkMode)
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.AlwaysLightMode)
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings)

            case LS_MENU_NEVER_DARK:
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.AlwaysDarkMode)
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.AlwaysLightMode)
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings)

            case LS_MENU_WHEN_PHONE_IN_DARK:
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.AlwaysDarkMode)
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.AlwaysLightMode)
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings)
                
            default:
                fatalError("Did select menu item which does not exist")
            }
        }
        setToggles()
        NotificationCenter.default.post(name: .DarkModeSettingsChanged, object: nil)
    }
    
    
    // MARK: - Actions

    private func shareApp() {
        
        // Conform to UIActivityItemSource for custom activityItems
        let activityItem = "Share HockeyUpp"
        let activityViewController = UIActivityViewController(activityItems: [activityItem, self], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func contactUs() {
        
        if MFMailComposeViewController.canSendMail() {
            let body = emailBody(withAddedString: emailString())
            presentEmail(body: body)
            
        } else {
            showEmailAlert()
        }
    }

    private func writeAReview() {
        
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
        guard let writeReviewURL = components?.url else { return }
        
        UIApplication.shared.open(writeReviewURL)
    }
    
    private func linkToPrivacyPolicy() {
        
        if let url = URL(string: websiteURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func changeAppIcon() {
        
        let vc = AppIconVC()
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func setToggles() {
        
        checkToggles()
        
        guard let section = headerTitles.firstIndex(of: LS_MENU_HEADER_DARK_MODE) else {
            return
        }
        
        for index in 0 ..< darkModeText.count {
            
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: section)), let accessoryView = cell.accessoryView, accessoryView.isKind(of: UISwitch.self) else {
                return
            }
            
            let toggle = accessoryView as! UISwitch
            
            switch darkModeText[index] {
            case LS_MENU_ALWAYS_DARK:
                let on = UserDefaults.standard.bool(forKey: UserDefaultsKey.AlwaysDarkMode)
                toggle.setOn(on, animated: false)
            case LS_MENU_NEVER_DARK:
                let on = UserDefaults.standard.bool(forKey: UserDefaultsKey.AlwaysLightMode)
                toggle.setOn(on, animated: false)
            case LS_MENU_WHEN_PHONE_IN_DARK:
                let on = UserDefaults.standard.bool(forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings)
                toggle.setOn(on, animated: false)
            default:
                fatalError("Did select menu item which does not exist")
            }
        }
    }
    
    private func checkToggles() {
        
        let darkMode = UserDefaults.standard.bool(forKey: UserDefaultsKey.AlwaysDarkMode) ? 1 : 0
        let lightMode = UserDefaults.standard.bool(forKey: UserDefaultsKey.AlwaysLightMode) ? 1 : 0
        let phoneMode = UserDefaults.standard.bool(forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings) ? 1 : 0
        if darkMode + lightMode + phoneMode != 1 {
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.AlwaysDarkMode)
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.AlwaysLightMode)
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings)
        }
    }
    
    private func toggleForMinimalisticLookCell() -> UISwitch? {
        
        let toggle = UISwitch()
        
        toggle.onTintColor = UIColor(named: ColorName.LightYellow)!
        toggle.tag = 999
        toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        let on = UserDefaults.standard.bool(forKey: UserDefaultsKey.MinimalisticLook)
        toggle.setOn(on, animated: false)

        return toggle
    }
    
    private func toggleForDarkModeCell(_ actionTitle: String, tag: Int) -> UISwitch? {
        
        let toggle = UISwitch()
        
        toggle.onTintColor = UIColor(named: ColorName.LightYellow)!
        toggle.tag = tag
        toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        switch darkModeText[tag] {
        case LS_MENU_ALWAYS_DARK:
            let on = UserDefaults.standard.bool(forKey: UserDefaultsKey.AlwaysDarkMode)
            toggle.setOn(on, animated: false)
        case LS_MENU_NEVER_DARK:
            let on = UserDefaults.standard.bool(forKey: UserDefaultsKey.AlwaysLightMode)
            toggle.setOn(on, animated: false)
        case LS_MENU_WHEN_PHONE_IN_DARK:
            let on = UserDefaults.standard.bool(forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings)
            toggle.setOn(on, animated: false)
        default:
            fatalError("Did select menu item which does not exist")
        }

        return toggle
    }
    
    private func emailBody(withAddedString added: String) -> String {
        
        var body = "<p>" + "We welcome your remark or suggestion, which could improve HockeyUpp for you and for all users." + "</p><br><br><br><br>"
        body += added
        return body
    }
    
    private func emailString() -> String {
        
        var result = "<hr>"
        
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "*.*"
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "*"
        let premium = UserDefaults.standard.bool(forKey: UserDefaultsKey.PremiumMode) ? "P" : ""
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
}


extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return headerTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch headerTitles[section] {
        case LS_MENU_HEADER_USER_SETTINGS:
            return userSettingsText.count
        case LS_MENU_HEADER_DARK_MODE:
            return darkModeText.count
        case LS_MENU_HEADER_FEEDBACK:
            return feedbackText.count
        default:
            fatalError("Trying to get header title for non existing header")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let fontSize = UIDevice.whenDeviceIs(small: 15, normal: 17, big: 17)

        cell.backgroundColor = .secondarySystemBackground
        cell.textLabel?.textColor = .label
        cell.textLabel?.font = UIFont(name: FONTNAME.ThemeRegular, size: fontSize)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.selectionStyle = .none
        
        if headerTitles[indexPath.section] == LS_MENU_HEADER_USER_SETTINGS {
            
            cell.textLabel?.text = userSettingsText[indexPath.row]

            if userSettingsText[indexPath.row] == LS_MENU_CHANGE_APP_ICON {
                cell.accessoryType = .disclosureIndicator
            }
            
        } else if headerTitles[indexPath.section] == LS_MENU_HEADER_DARK_MODE {
            
            cell.textLabel?.text = darkModeText[indexPath.row]
            cell.accessoryView = toggleForDarkModeCell(feedbackText[indexPath.row], tag: indexPath.row)
            
        } else if headerTitles[indexPath.section] == LS_MENU_HEADER_FEEDBACK {
            
            cell.textLabel?.text = feedbackText[indexPath.row]
            
            let imageName = feedbackImageNames[indexPath.row]
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)
            if let image = UIImage(systemName: imageName, withConfiguration: config) {
                let imageView = UIImageView(image: image)
                imageView.tintColor = UIColor(named: ColorName.DarkBlue)!
                cell.accessoryView = imageView
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 52
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // A short delay to avoid long delays (didSelectRow can be a slow method)
        // https://stackoverflow.com/questions/27203324/unpredictable-delay-before-uipopovercontroller-appears-under-ios-8-1/27227446#27227446
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [unowned self] in
            
            if self.headerTitles[indexPath.section] == LS_MENU_HEADER_USER_SETTINGS {
                if self.userSettingsText[indexPath.row] == LS_MENU_CHANGE_APP_ICON {
                    self.changeAppIcon()
                }
                
            } else if self.headerTitles[indexPath.section] == LS_MENU_HEADER_FEEDBACK {
                
                switch self.feedbackText[indexPath.row] {
                case LS_MENU_SHARE:
                    self.shareApp()
                case LS_MENU_CONTACT_US:
                    self.contactUs()
                case LS_MENU_REVIEW:
                    self.writeAReview()
                case LS_MENU_PRIVACY_POLICY:
                    self.linkToPrivacyPolicy()
                default:
                    fatalError("Did select menu item which does not exist")
                }
            }
        }
    }
}


extension MenuVC: UIActivityItemSource {

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

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        
        let metadata = LPLinkMetadata()
        metadata.originalURL = productURL
        metadata.url = metadata.originalURL
        metadata.title = "Share HockeyUpp"
        metadata.imageProvider = NSItemProvider.init(contentsOf: Bundle.main.url(forResource: "Icon-Spotlight-40@3x", withExtension: "png"))
        return metadata
    }
}


// MARK: - MFMailComposeViewControllerDelegate

extension MenuVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
    }
}



