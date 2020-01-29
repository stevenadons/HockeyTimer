//
//  GameTimeDataSource.swift
//  HockeyTimer
//
//  Created by Steven Adons on 25/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class GameTimeDataSource: UICollectionViewDiffableDataSource<Int, DurationCard> {
    
    
    // MARK: - Properties
    
    private var cards: [DurationCard] = []
    
    var count: Int {
        return cards.count
    }
    
    
    // MARK: - Private Methods
    
    
    
    // MARK: - Public Methods
    
    func configureWith(_ country: Country) {
        
        for index in 0 ..< country.minutes.count {
            let card = DurationCard(minutes: country.minutes[index], periods: country.periods[index])
            card.setMinutes(country.minutes[index], minutesString: country.minutesStrings[index], periods: country.periods[index], animated: false, delay: 0.0)
            cards.append(card)
        }
    }
    
    func takeSnapShot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, DurationCard>()
        snapshot.appendSections([0])
        snapshot.appendItems(cards, toSection: 0)
        apply(snapshot)
    }
    
    func minutesFor(_ indexPath: IndexPath) -> Double {
        
        let card = cards[indexPath.row]
        return card.minutes
    }
    
    func ageStringFor(_ indexPath: IndexPath) -> String {
        
        let card = cards[indexPath.row]
        return card.ageString
    }
    
}
