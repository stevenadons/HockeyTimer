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
    
//    fileprivate var documentList: DocumentList!
    private var rulesList: RulesList!
    
    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        rulesList.windUp()
    }
    
    private func setup() {
        
        view.backgroundColor = COLOR.White
        
        rulesList = RulesList(delegate: self, country: SELECTED_COUNTRY)
        rulesList.backgroundColor = UIColor.clear
        view.addSubview(rulesList)
        view.sendSubviewToBack(rulesList)
        
        panArrowUp.color = COLOR.LightYellow
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
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        rulesList.animateFlyIn()
    }
    
    
    
    // MARK: - Private Methods
    
    
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
