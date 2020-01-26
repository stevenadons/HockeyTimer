//
//  GameTimeCardCell.swift
//  HockeyTimer
//
//  Created by Steven Adons on 25/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


class GameTimeCell: UICollectionViewCell {
    
    
    // MARK: - Properties

    private (set) var durationCard: DurationCard?
    
    
    // MARK: - Init and Layout
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if let card = durationCard {
            NSLayoutConstraint.activate([
                card.topAnchor.constraint(equalTo: topAnchor),
                card.bottomAnchor.constraint(equalTo: bottomAnchor),
                card.leadingAnchor.constraint(equalTo: leadingAnchor),
                card.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }
    }
    
    
    // MARK: - Public Methods

    func configure(with minutes: Int, minutesString: String) {
        
        durationCard?.removeFromSuperview()
        
        durationCard = DurationCard(minutes: minutes)
        durationCard!.translatesAutoresizingMaskIntoConstraints = false
        durationCard!.setMinutes(minutes, minutesString: minutesString, animated: false, delay: 0.0)
        addSubview(durationCard!)
        
        setNeedsLayout()
    }
    
    // MARK: - Private Methods
    
    
}
