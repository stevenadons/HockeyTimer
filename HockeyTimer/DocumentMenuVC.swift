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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        countryMenu.hideButtons(animated: false)
        super.viewWillAppear(animated)
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
        panArrowUpLabel.text = LS_TITLE_SCORE
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
                               labelNames: ["Review", "Share", "Contact"])
    }
    
    
    
    
    // MARK: - Public Methods
    
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
}


extension DocumentMenuVC: DotMenuDelegate {
    
    func handleDotMenuMainButtonTapped() {
        
        if let settingsIndex = view.subviews.firstIndex(of: settingsMenu), let countryIndex = view.subviews.firstIndex(of: countryMenu), settingsIndex < countryIndex {
            view.exchangeSubview(at: settingsIndex, withSubviewAt: countryIndex)
        }
    }
    
    func handleDotMenuOtherButtonTapped(buttonNumber: Int) {
        
        print("number \(buttonNumber) tapped")
    }
}
