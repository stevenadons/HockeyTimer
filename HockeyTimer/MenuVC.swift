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
    
    private var titleText: String?
    
    private let feedbackText: [String] = [LS_MENU_SHARE,
                                          LS_MENU_CONTACT_US,
                                          LS_MENU_REVIEW,
                                          LS_MENU_PRIVACY_POLICY]
    
    private let feedbackDetailText: [String] = [LS_MENU_SHARE_THE_APP,
                                                LS_MENU_WRITE_AN_EMAIL,
                                                LS_MENU_WRITE_A_REVIEW,
                                                LS_MENU_LINK_TO_WEBSITE]
    
    private let feedbackImageNames: [String] = ["square.and.arrow.up",
                                                "envelope",
                                                "square.and.pencil",
                                                "checkmark.shield"]
    
    private let darkModeText: [String] = [LS_MENU_DARK,
                                          LS_MENU_LIGHT,
                                          LS_MENU_PHONE_SETTINGS]
    
    private let darkModeDetailText: [String] = [LS_MENU_ALWAYS_DARK,
                                                LS_MENU_NEVER_DARK,
                                                LS_MENU_FOLLOW_PHONE_SETTINGS]
    
    private let headerTitles: [String] = [LS_MENU_HEADER_FEEDBACK,
                                          LS_MENU_HEADER_DARK_MODE]
    
    private let productURL = URL(string: "https://apps.apple.com/app/id1464432452")!
    private let websiteURLString = "https://stevenadons.wixsite.com/hockeyupp"

   
    
    // MARK: - Life Cycle
    
    init(titleText: String? = nil) {
        
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if !FeatureFlags.darkModeCanBeEnabled {
            overrideUserInterfaceStyle = .light
        }
        
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
        titleLabel.text = titleText ?? ""
        titleLabel.font = UIFont(name: FONTNAME.ThemeBlack, size: 32)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.separatorColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        // Make the viewcontroller dismissable by swiping down
        // Setting isScrollEnabled to false will not work for this
        tableView.panGestureRecognizer.isEnabled = false
        view.addSubview(tableView)
        
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .large)
        let tintColor = UIColor(named: ColorName.DarkBlue)!
        let image = UIImage(systemName: "xmark", withConfiguration: configuration)?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        doneButton.setImage(image, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        view.addSubview(doneButton)
    }
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
            
            ])
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func switchChanged(_ item: UISwitch) {
       
//        if item.tag == feedbackText.firstIndex(of: LS_MENU_DARK_MODE) {
//            // activate dark mode
//
//        } else if item.tag == feedbackText.firstIndex(of: LS_MENU_LIGHT_MODE) {
//            // activate light mode
//        }
    }
    
    @objc private func doneButtonTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
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
    
    
    // MARK: - Private Methods
    
    private func toggleFor(_ actionTitle: String, tag: Int) -> UISwitch? {
        
        let toggle = UISwitch()
        
        toggle.onTintColor = UIColor(named: ColorName.LightYellow)!
        toggle.tag = tag
        toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
//        if actionTitle.contains("Dark mode") {
//            let on = traitCollection.userInterfaceStyle == .dark
//            toggle.setOn(on, animated: false)
//        }
//        if actionTitle.contains("Light mode") {
//            let on = traitCollection.userInterfaceStyle != .dark
//            toggle.setOn(on, animated: false)
//        }
        
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


extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return headerTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if headerTitles[section] == LS_MENU_HEADER_FEEDBACK {
            return feedbackText.count
            
        } else if headerTitles[section] == LS_MENU_HEADER_DARK_MODE {
            return darkModeText.count
        }
        return 9999
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.backgroundColor = .secondarySystemBackground
        cell.textLabel?.textColor = .label
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.selectionStyle = .none
        
        if headerTitles[indexPath.section] == LS_MENU_HEADER_FEEDBACK {
            
            cell.textLabel?.text = feedbackText[indexPath.row]
            cell.detailTextLabel?.text = feedbackDetailText[indexPath.row]
            
            let imageName = feedbackImageNames[indexPath.row]
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)
            if let image = UIImage(systemName: imageName, withConfiguration: config) {
                let imageView = UIImageView(image: image)
                imageView.tintColor = UIColor(named: ColorName.DarkBlue)!
                cell.accessoryView = imageView
            }
            
        } else if headerTitles[indexPath.section] == LS_MENU_HEADER_DARK_MODE {
            
            cell.textLabel?.text = darkModeText[indexPath.row]
            cell.detailTextLabel?.text = darkModeDetailText[indexPath.row]
            cell.accessoryView = toggleFor(feedbackText[indexPath.row], tag: indexPath.row)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if headerTitles[indexPath.section] == LS_MENU_HEADER_FEEDBACK {
            
            switch feedbackText[indexPath.row] {
            case LS_MENU_SHARE:
                shareApp()
            case LS_MENU_CONTACT_US:
                contactUs()
            case LS_MENU_REVIEW:
                writeAReview()
            case LS_MENU_PRIVACY_POLICY:
                linkToPrivacyPolicy()
            default:
                fatalError("Did select menu item which does not exist")
            }
            
        } else if headerTitles[indexPath.section] == LS_MENU_HEADER_DARK_MODE {
            
            switch darkModeText[indexPath.row] {
            case LS_MENU_DARK:
                print("dark mode")
            case LS_MENU_LIGHT:
                print("light mode")
            default:
                fatalError("Did select menu item which does not exist")
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



