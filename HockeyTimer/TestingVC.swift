//
//  TestingVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 05/08/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class TestingVC: UIViewController {
    
    // MARK: - Properties
    
    private var premiumLabel: UILabel!
    private var premiumSwitch: UISwitch!
    private var dismissButton: UIButton!
    

    // MARK: - Life Cycle 

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if !FeatureFlags.darkModeCanBeEnabled {
            overrideUserInterfaceStyle = .light
        }
        
        view.backgroundColor = UIColor.black
        
        premiumLabel = createLabel("Premium Mode")
        view.addSubview(premiumLabel)
        
        premiumSwitch = createSwitch(#selector(handlePremiumMode(swtch:)))
        view.addSubview(premiumSwitch)
        
        dismissButton = createButton(title: "Back", selector: #selector(back))
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            
            premiumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            premiumLabel.trailingAnchor.constraint(equalTo: premiumSwitch.leadingAnchor),
            premiumLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            premiumSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            premiumSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            dismissButton.heightAnchor.constraint(equalToConstant: 50),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let premiumMode = UserDefaults.standard.bool(forKey: UserDefaultsKey.PremiumMode)
        premiumSwitch.setOn(premiumMode, animated: false)
    }
    
    
    // MARK: - Actions
    
    @objc private func handlePremiumMode(swtch: UISwitch) {
        
        UserDefaults.standard.set(swtch.isOn, forKey: UserDefaultsKey.PremiumMode)
    }
    
    @objc private func back() {
        
        dismiss(animated: true)
    }

    
    
    // MARK: - Private Methods

    private func createLabel(_ text: String) -> UILabel {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = text
        label.numberOfLines = 0
        
        return label
    }
    
    
    private func createSwitch(_ selector: Selector) -> UISwitch {
        
        let swtch = UISwitch()
        
        swtch.translatesAutoresizingMaskIntoConstraints = false
        swtch.addTarget(self, action: selector, for: [.valueChanged])
        
        return swtch
    }
    
    
    private func createButton(title: String, selector: Selector) -> UIButton {
        
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.layer.cornerRadius = 25
        
        return button
    }

    
}
