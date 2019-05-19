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
    private var cancelButton: UIButton!
    
    private var titleText: String!
    private var text: String!
    private var okButtonText: String!
    private var cancelButtonText: String!
    
    private var afterDismiss: ((Bool) -> Void)?
    private var confirmation: Bool = false
    
    
    // MARK: - Life Cycle
    
    init(titleText: String, text: String, okButtonText: String = "OK", cancelButtonText: String = "Cancel", afterDismiss: ((Bool) -> Void)? = nil) {
        
        self.titleText = titleText
        self.text = text
        self.okButtonText = okButtonText
        self.cancelButtonText = cancelButtonText
        self.afterDismiss = afterDismiss
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        addConstraints()
    }
    
    private func setupUI() {
        
        view.backgroundColor = COLOR.VeryDarkBlue
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = titleText // "Allow Notifications"
        titleLabel.font = UIFont(name: FONTNAME.ThemeBold, size: 28)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = COLOR.White
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.text = text // "DimpleBall sends you a notification when the hockey game ends. You should enable Notifications to get warned."
        textLabel.font = UIFont(name: FONTNAME.ThemeRegular, size: 16)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textColor = COLOR.White
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        okButton = ConfirmationButton.yellowButton(largeFont: true)
        okButton.setTitle(okButtonText, for: .normal)
        okButton.addTarget(self, action: #selector(okTapped), for: [.touchUpInside])
        view.addSubview(okButton)
        
        cancelButton = ConfirmationButton.redButton(largeFont: true)
        cancelButton.setTitle(cancelButtonText, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: [.touchUpInside])
        view.addSubview(cancelButton)
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
            textLabel.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -40),
            
            okButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horInset),
            okButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horInset),
            okButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -18),
            okButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            cancelButton.leadingAnchor.constraint(equalTo: okButton.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: okButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalTo: okButton.heightAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        afterDismiss?(confirmation)
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func okTapped() {
        
        confirmation = true
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func cancelTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
}


