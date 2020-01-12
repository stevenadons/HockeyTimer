//
//  CardTimerCell.swift
//  ProbeerselUICollectionView
//
//  Created by Steven Adons on 04/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class CardTimerCell: UICollectionViewCell {
    
    
    // MARK: - Properties

    private var timer: CardTimer?
    private var threeCards: ThreeCards?
    
    
    // MARK: - Init and Layout
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if let timer = timer {
            
            NSLayoutConstraint.activate([
                
                timer.topAnchor.constraint(equalTo: topAnchor),
                timer.bottomAnchor.constraint(equalTo: bottomAnchor),
                timer.leadingAnchor.constraint(equalTo: leadingAnchor),
                timer.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
            
        } else if let threeCards = threeCards {
            
            threeCards.frame = bounds
        }
    }
    
    
    // MARK: - Public Methods

    func configure(with cardTimer: CardTimer) {
        
        if cardTimer.isDummyForAddCard {
            
            clipsToBounds = true
            layer.cornerRadius = 8
            
            threeCards = ThreeCards(grayScale: false)
            layer.addSublayer(threeCards!)
            
            backgroundColor = .clear
            
        } else {
            
            timer = cardTimer
            addSubview(timer!)
        }
        
        setNeedsLayout()
    }
    
    // MARK: - Private Methods
    
    
}
