//
//  DocumentMenuVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


class DocumentMenuVC: PanArrowVC {

    
    // MARK: - Properties
    
    private var rulesList: RulesList!
    private var countryMenu: CountryMenu!
    private var settingsMenu: DotMenu!
    
    
    
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
        
        view.backgroundColor = COLOR.Olive
        
        rulesList = RulesList(delegate: self, country: SELECTED_COUNTRY)
        rulesList.backgroundColor = UIColor.clear
        view.addSubview(rulesList)
        view.sendSubviewToBack(rulesList)
        
        panArrowUp.color = UIColor.white
        panArrowDown.alpha = 0.0
        panArrowUpLabel.alpha = 0.0
        panArrowDownLabel.alpha = 0.0
        panArrowUpLabel.textColor = COLOR.VeryDarkBlue
        
        NSLayoutConstraint.activate([
            
            rulesList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rulesList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rulesList.topAnchor.constraint(equalTo: view.topAnchor),
            rulesList.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            ])
        
        countryMenu = CountryMenu(inView: view,
                                  delegate: self,
                                  labelNames: Country.allNames(),
                                  capitalsStrings: Country.allCapitals(),
                                  selected: countries.firstIndex(of: SELECTED_COUNTRY))
        
        settingsMenu = DotMenu(inView: view,
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
        
        guard countries[buttonNumber] != SELECTED_COUNTRY else { return }
        
        SELECTED_COUNTRY = countries[buttonNumber]
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
            // Write a review
            guard let productURL = URL(string: "https://apps.apple.com/app/id1464432452") else { return }
            var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
            guard let writeReviewURL = components?.url else { return }
            UIApplication.shared.open(writeReviewURL)
            
        case 1:
            // Share the app
            // Conform to UIActivityItemSource for custom activityItems
            let activityViewController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        
        case 2:
            print("2")
        
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
        
        guard let productURL = URL(string: "https://apps.apple.com/app/id1464432452") else { return "" }
        return productURL

    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        if activityType == .postToTwitter {
            return "Download #HockeyUpp on the App Store"
        }
        
        guard let productURL = URL(string: "https://apps.apple.com/app/id1464432452") else { return nil }
        return productURL
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        
        return "HockeyUpp - Your field hockey companion"
    }
    
    
    
}
