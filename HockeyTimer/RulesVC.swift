//
//  RulesVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 25/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit
import MessageUI


class RulesVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var titleLabel: UILabel!
    private var tableView: UITableView!
    private var reportButton: UIButton!
    private var doneButton: UIButton!
    private var countryButton: OvalCountryButton!
    private var topStripe: UIView!
    private var bottomStripe: UIView!

    private var dataSource: RulesDataSource!

    private var onDismiss: (() -> Void)?
    
    private var showTopStripe: Bool = false {
        didSet {
            topStripe.alpha = showTopStripe ? 1.0 : 0.0
        }
    }
    private var showBottomStripe: Bool = false {
        didSet {
            bottomStripe.alpha = showBottomStripe ? 1.0 : 0.0
        }
    }

   
    
    // MARK: - Life Cycle
    
    init(onDismiss: (() -> Void)? = nil) {
        
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
        titleLabel.text = LS_TITLE_GAME_RULES
        titleLabel.font = UIFont(name: FONTNAME.ThemeBlack, size: 28)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RulesCell.self, forCellReuseIdentifier: "RulesCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
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
        
        countryButton = OvalCountryButton(capitals: SELECTED_COUNTRY.capitals, color: UIColor(named: ColorName.DarkBlueText)!, crossColor: .white)
        countryButton.translatesAutoresizingMaskIntoConstraints = false
        countryButton.addTarget(self, action: #selector(countryButtonTapped), for: .touchUpInside)
        view.addSubview(countryButton)
        
        dataSource = RulesDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, rules) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "RulesCell", for: indexPath) as! RulesCell
            let textColor = self.dataSource.textColorAt(indexPath)
            let bgColor = self.dataSource.bgColorAt(indexPath)
            let alignment = self.dataSource.alignmentAt(indexPath)
            cell.configureWith(rules: rules, textColor: textColor, bgColor: bgColor, alignment: alignment)
            return cell
        })
        dataSource.configure(SELECTED_COUNTRY)
        dataSource.takeSnapShot()
        
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
        attributedTitle.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: fullRange)
        reportButton.setAttributedTitle(attributedTitle, for: .normal)
        
        view.addSubview(reportButton)
        
        topStripe = UIView()
        topStripe.translatesAutoresizingMaskIntoConstraints = false
        topStripe.backgroundColor = .systemGray5
        topStripe.alpha = 0.0
        view.addSubview(topStripe)
        
        bottomStripe = UIView()
        bottomStripe.translatesAutoresizingMaskIntoConstraints = false
        bottomStripe.backgroundColor = .systemGray5
        bottomStripe.alpha = 0.0
        view.addSubview(bottomStripe)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        checkDarkMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        checkTopStripe()
        checkBottomStripe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        onDismiss?()
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDarkMode), name: .DarkModeSettingsChanged, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let tableViewHorInset: CGFloat = 9
        let padding: CGFloat = UIDevice.whenDeviceIs(small: 15, normal: 30, big: 30)
        let reportConstant: CGFloat = UIDevice.whenDeviceIs(small: 7, normal: 9, big: 15)
        let countryWidth: CGFloat = 44
        let countryHeight: CGFloat = 44
        let countryTopInset: CGFloat = UIDevice.whenDeviceIs(small: 0, normal: 12, big: 12)
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tableViewHorInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tableViewHorInset),
            tableView.bottomAnchor.constraint(equalTo: reportButton.topAnchor, constant: -8),
            
            reportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reportButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -reportConstant),
            
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            countryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            countryButton.widthAnchor.constraint(equalToConstant: countryWidth),
            countryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: countryTopInset),
            countryButton.heightAnchor.constraint(equalToConstant: countryHeight),
            
            topStripe.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topStripe.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0),
            topStripe.heightAnchor.constraint(equalToConstant: 1),
            topStripe.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            
            bottomStripe.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStripe.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0),
            bottomStripe.heightAnchor.constraint(equalToConstant: 1),
            bottomStripe.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            
            ])
        
        dataSource.takeSnapShot()
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func cancelTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func doneTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func countryButtonTapped() {
        
        let vc = CountryVC(titleText: LS_TITLE_COUNTRY, onDismiss: {
            self.dataSource.configureToZero()
            self.dataSource.takeSnapShot()
            self.dataSource.configure(SELECTED_COUNTRY)
            self.dataSource.takeSnapShot()
            self.countryButton.setCapitals(SELECTED_COUNTRY.capitals)
        })
        present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - Actions

    
    
    
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
    
    @objc private func reportButtonTapped() {
        
        if MFMailComposeViewController.canSendMail() {
            let body = emailBody(withAddedString: emailString())
            presentEmail(body: body)
            
        } else {
            showEmailAlert()
        }
    }
    
    
    // MARK: - Email Methods
    
    private func emailBody(withAddedString added: String) -> String {
        
        var body = "<p>" + LS_EMAIL_SENTENCE + "</p><br><br><br><br>"
        body += added
        return body
    }
    
    private func emailString() -> String {
        
        var result = "<hr>"
        
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "*.*"
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "*"
        let premium = UserDefaults.standard.bool(forKey: UserDefaultsKey.PremiumMode) ? "P" : ""
        result += LS_EMAIL_VERSION + appVersion + premium + " - " + LS_EMAIL_BUILD + buildNumber
        
        let iosVersion = UIDevice.current.systemVersion
        let add = result.count > 4 ? " - iOS " + iosVersion : "iOS " + iosVersion
        result += add
        
        let country = Products.store.appStoreCountry ?? "Unknown country"
        result += result.count > 4 ? " - " + LS_EMAIL_COUNTRY + country : LS_EMAIL_COUNTRY + country
        
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


// MARK: - Table View

extension RulesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return RulesButton.fixedHeight * 1.2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0 // (section == 0) ? 0 : RulesButton.fixedHeight * 0.25
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // A short delay to avoid long delays (didSelectRow can be a slow method)
        // https://stackoverflow.com/questions/27203324/unpredictable-delay-before-uipopovercontroller-appears-under-ios-8-1/27227446#27227446
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            
            guard let cell = tableView.cellForRow(at: indexPath) as? RulesCell else {
                return
            }
            var url: URL? = cell.rules.url
            if let specificUrls = cell.rules.specificLocaleUrls, let currentLanguage = Locale.current.languageCode, let specificUrl = specificUrls[currentLanguage] as? URL {
                url = specificUrl
            }
            if url != nil {
                UIApplication.shared.open(url!)
            }
        }
    }
}


// MARK: - UIScrollViewDelegate

extension RulesVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        checkTopStripe()
        checkBottomStripe()
    }
    
    private func checkTopStripe() {
        
        guard let firstCell = tableView.visibleCells.first else {
            return
        }
        showTopStripe = !(checkVisibilityOf(firstCell, inScrollView: tableView))
    }
    
    private func checkBottomStripe() {
        
        guard let lastCell = tableView.visibleCells.last else {
            return
        }
        showBottomStripe = !(checkVisibilityOf(lastCell, inScrollView: tableView))
    }
    
    private func checkVisibilityOf(_ cell: UITableViewCell, inScrollView: UIScrollView) -> Bool {
        
        let cellRect = inScrollView.convert(cell.frame, to: inScrollView.superview)
        return inScrollView.frame.contains(cellRect)
    }
}


// MARK: - MFMailComposeViewControllerDelegate

extension RulesVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
    }
}





