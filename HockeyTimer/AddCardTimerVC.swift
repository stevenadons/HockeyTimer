//
//  AddCardTimerVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 01/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class AddCardTimerVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var titleLabel: UILabel!
    
    private var cardPanel: ChooseCardPanel!
    
    private var okButton: UIButton!
    private var cancelButton: UIButton!
    
    private var titleText: String = ""
    private var okButtonText: String = "OK"
    private var cancelButtonText: String = "Cancel"
    
    private var okAction: (() -> Void)?
    private var cancelAction: (() -> Void)?
    
    
    // MARK: - Life Cycle
    
    init(title: String, okAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        
        self.titleText = title
        self.okAction = okAction
        self.cancelAction = cancelAction
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        
        setupUI()
        addConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        animateOnIntro()
    }
    
    private func setupUI() {
        
        view.backgroundColor = UIColor(named: "VeryDarkBlue")!
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = titleText
        titleLabel.font = UIFont(name: FONTNAME.ThemeBlack, size: 28)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = COLOR.White
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        cardPanel = ChooseCardPanel()
        view.addSubview(cardPanel)
        
        okButton = ConfirmationButton.blueButton(largeFont: true)
        okButton.setTitle(okButtonText, for: .normal)
        okButton.addTarget(self, action: #selector(okTapped), for: [.touchUpInside])
        view.addSubview(okButton)
        
        cancelButton = ConfirmationButton.redButton(largeFont: true)
        cancelButton.setTitle(cancelButtonText, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: [.touchUpInside])
        view.addSubview(cancelButton!)
        
        windUp()
    }
    
    private func addConstraints() {
        
        let buttonHeight: CGFloat = 54
        let horInset: CGFloat = 35
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            cardPanel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            cardPanel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            cardPanel.heightAnchor.constraint(equalTo: cardPanel.widthAnchor, multiplier: 0.35),
            cardPanel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            okButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horInset),
            okButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -horInset / 2),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            okButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: horInset / 2),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horInset),
            cancelButton.heightAnchor.constraint(equalTo: okButton.heightAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: okButton.bottomAnchor),
            
            ])
        
    }
    
    // MARK: - Private Methods
    
    private func windUp() {
        
        cardPanel.alpha = 0.0
        cardPanel.transform = CGAffineTransform(translationX: 0, y: 20)
    }
    
    private func animateOnIntro() {
        
        guard cardPanel.transform != .identity else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.cardPanel.alpha = 1.0
            self.cardPanel.transform = .identity
        })
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


