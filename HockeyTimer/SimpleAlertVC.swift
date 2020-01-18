//
//  SimpleAlertVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 19/05/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class SimpleAlertVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var titleLabel: UILabel!
    private var textLabel: UILabel!
    private var okButton: UIButton!
    private var cancelButton: UIButton?
    
    private var titleText: String?
    private var text: String!
    private var okButtonText: String?
    private var cancelButtonText: String?
    
    private var okAction: (() -> Void)?
    private var cancelAction: (() -> Void)?
    
    
    // MARK: - Life Cycle
    
    init(titleText: String? = nil,
         text: String,
         okButtonText: String? = "OK",
         cancelButtonText: String? = nil,
         okAction: (() -> Void)? = nil,
         cancelAction: (() -> Void)? = nil) {
        
        self.titleText = titleText
        self.text = text
        self.okButtonText = okButtonText
        self.cancelButtonText = cancelButtonText
        self.okAction = okAction
        self.cancelAction = cancelAction
        
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
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.systemBackground
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = titleText ?? ""
        titleLabel.font = UIFont(name: FONTNAME.ThemeBlack, size: 32)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.text = text
        textLabel.font = UIFont(name: FONTNAME.ThemeRegular, size: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textColor = UIColor.label
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: text.count)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        textLabel.attributedText = attributedString
        
        okButton = ConfirmationButton.blueButton(largeFont: true)
        let okButtonTitle = okButtonText ?? "OK"
        okButton.setTitle(okButtonTitle, for: .normal)
        okButton.addTarget(self, action: #selector(okTapped), for: [.touchUpInside])
        view.addSubview(okButton)
        
        if cancelButtonText != nil {
            
            cancelButton = ConfirmationButton.redButton(largeFont: true)
            cancelButton!.setTitle(cancelButtonText, for: .normal)
            cancelButton!.addTarget(self, action: #selector(cancelTapped), for: [.touchUpInside])
            view.addSubview(cancelButton!)
        }
    }
    
    private func addConstraints() {
        
        let buttonHeight: CGFloat = 54
        let horInset: CGFloat = 35
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horInset * 1.5),
            textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horInset * 1.5),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textLabel.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -60),
            
            ])
        
        if cancelButton != nil {
            
            NSLayoutConstraint.activate([
                
                okButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horInset),
                okButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horInset),
                okButton.bottomAnchor.constraint(equalTo: cancelButton!.topAnchor, constant: -16),
                okButton.heightAnchor.constraint(equalToConstant: buttonHeight),
                
                cancelButton!.leadingAnchor.constraint(equalTo: okButton.leadingAnchor),
                cancelButton!.trailingAnchor.constraint(equalTo: okButton.trailingAnchor),
                cancelButton!.heightAnchor.constraint(equalTo: okButton.heightAnchor),
                cancelButton!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -horInset),
                
                ])
        
        } else {
            
            NSLayoutConstraint.activate([
                
                okButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horInset),
                okButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horInset),
                okButton.heightAnchor.constraint(equalToConstant: buttonHeight),
                okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -horInset),
                
                ])
        }
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func okTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.okAction?()
            })
        }
    }
    
    @objc private func cancelTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.cancelAction?()
            })
        }
    }
}


