//
//  ChooseCardPanel.swift
//  HockeyTimer
//
//  Created by Steven Adons on 01/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class ChooseCardPanel: UIView {
    
    
    // MARK: - Properties
    
    private var greenCard: ChooseCardView!
    private var yellowCard: ChooseCardView!
    private var redCard: ChooseCardView!
    
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        greenCard = ChooseCardView(card: .green)
        greenCard.addTarget(self, action: #selector(greenCardTapped), for: .touchUpInside)
        addSubview(greenCard)
        
        yellowCard = ChooseCardView(card: .yellow)
        yellowCard.addTarget(self, action: #selector(yellowCardTapped), for: .touchUpInside)
        addSubview(yellowCard)
        
        redCard = ChooseCardView(card: .red)
        redCard.addTarget(self, action: #selector(redCardTapped), for: .touchUpInside)
        addSubview(redCard)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let cardSize: CGFloat = (260 / 3) * bounds.width / 375
        let padding: CGFloat = (bounds.width - cardSize * 3) / 5
        
        NSLayoutConstraint.activate([
            
            greenCard.widthAnchor.constraint(equalToConstant: cardSize),
            greenCard.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -cardSize / 2 - padding),
            greenCard.heightAnchor.constraint(equalToConstant: cardSize),
            greenCard.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            yellowCard.widthAnchor.constraint(equalToConstant: cardSize),
            yellowCard.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -cardSize / 2),
            yellowCard.heightAnchor.constraint(equalToConstant: cardSize),
            yellowCard.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            redCard.widthAnchor.constraint(equalToConstant: cardSize),
            redCard.leadingAnchor.constraint(equalTo: centerXAnchor, constant: cardSize / 2 + padding),
            redCard.heightAnchor.constraint(equalToConstant: cardSize),
            redCard.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            ])
    }
    
    
    
    // MARK: - Touch
    
    @objc private func greenCardTapped() {
        
        greenCard.highlightBackground(true)
        yellowCard.highlightBackground(false)
        redCard.highlightBackground(false)
    }
    
    @objc private func yellowCardTapped() {
        
        greenCard.highlightBackground(false)
        yellowCard.highlightBackground(true)
        redCard.highlightBackground(false)
    }
    
    @objc private func redCardTapped() {
        
        greenCard.highlightBackground(false)
        yellowCard.highlightBackground(false)
        redCard.highlightBackground(true)
    }
    
    
}
