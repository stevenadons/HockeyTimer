//
//  ChooseCardPanel.swift
//  HockeyTimer
//
//  Created by Steven Adons on 01/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

protocol ChooseCardPanelDelegate: class {
    
    func didSelectCard()
}


class ChooseCardPanel: UIView {
    
    
    // MARK: - Properties
    
    private var greenCard: CardView!
    private var yellowCard: CardView!
    private var redCard: CardView!
    
    weak var delegate: ChooseCardPanelDelegate?
    private (set) var selectedType: CardType?
    
    
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
        
        let green = Card(type: .green)
        greenCard = CardView(card: green)
        greenCard.addTarget(self, action: #selector(greenCardTapped), for: .touchUpInside)
        addSubview(greenCard)
        
        let yellow = Card(type: .yellow)
        yellowCard = CardView(card: yellow)
        yellowCard.addTarget(self, action: #selector(yellowCardTapped), for: .touchUpInside)
        addSubview(yellowCard)
        
        let red = Card(type: .red)
        redCard = CardView(card: red)
        redCard.addTarget(self, action: #selector(redCardTapped), for: .touchUpInside)
        addSubview(redCard)
    }
    
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let minPadding: CGFloat = 18
        let cardSize: CGFloat = min((bounds.width - minPadding * 2) / 3, bounds.height)
        let padding = (bounds.width - cardSize * 3) / 2

        NSLayoutConstraint.activate([
            
            greenCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            greenCard.widthAnchor.constraint(equalToConstant: cardSize),
            greenCard.bottomAnchor.constraint(equalTo: bottomAnchor),
            greenCard.heightAnchor.constraint(equalToConstant: cardSize),
            
            yellowCard.leadingAnchor.constraint(equalTo: greenCard.trailingAnchor, constant: padding),
            yellowCard.widthAnchor.constraint(equalToConstant: cardSize),
            yellowCard.bottomAnchor.constraint(equalTo: bottomAnchor),
            yellowCard.heightAnchor.constraint(equalToConstant: cardSize),
            
            redCard.leadingAnchor.constraint(equalTo: yellowCard.trailingAnchor, constant: padding),
            redCard.widthAnchor.constraint(equalToConstant: cardSize),
            redCard.bottomAnchor.constraint(equalTo: bottomAnchor),
            redCard.heightAnchor.constraint(equalToConstant: cardSize),
            
            ])
    }
    
    
    
    // MARK: - Touch
    
    @objc private func greenCardTapped() {
        
        guard selectedType != .green else {
            return
        }
        
        greenCard.highlightBackground(true)
        yellowCard.highlightBackground(false)
        redCard.highlightBackground(false)
        
        selectedType = .green
        delegate?.didSelectCard()
    }
    
    @objc private func yellowCardTapped() {
        
        guard selectedType != .yellow else {
            return
        }
        
        greenCard.highlightBackground(false)
        yellowCard.highlightBackground(true)
        redCard.highlightBackground(false)
        
        selectedType = .yellow
        delegate?.didSelectCard()
    }
    
    @objc private func redCardTapped() {
        
        guard selectedType != .red else {
            return
        }
        
        greenCard.highlightBackground(false)
        yellowCard.highlightBackground(false)
        redCard.highlightBackground(true)
        
        selectedType = .red
        delegate?.didSelectCard()
    }
        
    
    
}
