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
    private var addCardLabel: UILabel?
    private var overlay: CALayer?
    
    
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
            
        } else {
            
            threeCards?.frame = bounds
            addCardLabel?.frame = bounds
            
            if let addCardLabel = addCardLabel {
                overlay?.frame = addCardLabel.textRect(forBounds: addCardLabel.bounds, limitedToNumberOfLines: 2).insetBy(dx: -4, dy: -4)
            }
        }
    }
    
    
    // MARK: - Public Methods

    func configure(with cardTimer: CardTimer) {
        
        if cardTimer.isDummyForAddCard {
            
            clipsToBounds = true
            layer.cornerRadius = 8
            
            threeCards = ThreeCards(grayScale: true)
//            #warning("to delete")
//            threeCards?.opacity = 0.0
            layer.addSublayer(threeCards!)
            
            addCardLabel = UILabel()
            addCardLabel!.textAlignment = .center
            addCardLabel!.text = "ADD\nCARD"
            addCardLabel!.numberOfLines = 2
            addCardLabel!.font = UIFont.preferredFont(forTextStyle: .footnote)
            addCardLabel!.textColor = .white
            #warning("to delete")
            addCardLabel!.alpha = 0.0
            addSubview(addCardLabel!)
            
            overlay = CALayer()
            overlay!.cornerRadius = 8
            overlay!.backgroundColor = UIColor.orange.cgColor
            #warning("to delete")
            overlay!.opacity = 0.0
            layer.addSublayer(overlay!)
            
            backgroundColor = .clear
            
        } else {
            
            timer = cardTimer
            addSubview(timer!)
        }
        
        setNeedsLayout()
    }
    
    // MARK: - Private Methods
    
    
}
