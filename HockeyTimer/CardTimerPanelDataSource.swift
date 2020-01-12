//
//  CardTimerPanelDataSource.swift
//  ProbeerselUICollectionView
//
//  Created by Steven Adons on 04/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class CardTimerPanelDataSource: UICollectionViewDiffableDataSource<Int, CardTimer> {
    
    
    // MARK: - Properties
    
    private var timers: [CardTimer] = []
    
    var count: Int {
        return timers.count
    }
    
    // MARK: - Private Methods
    
    private func takeSnapShot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, CardTimer>()
        snapshot.appendSections([0])
        snapshot.appendItems(timers, toSection: 0)
        apply(snapshot)
    }


    
    // MARK: - Public Methods
    
    func configureWithAddCardCell() {
        
        let dummyCard = Card(type: .green)
        let addCardTimer = CardTimer(card: dummyCard, minutes: 999, delegate: self, isDummyForAddCard: true)
        timers.append(addCardTimer)
        
        takeSnapShot()
    }
    
    func addTimerFor(_ card: Card, minutes: Int) {
        
        let timer = CardTimer(card: card, minutes: minutes, delegate: self)
        timers.insert(timer, at: timers.count - 1)
        
        takeSnapShot()
    }
    
    func deleteLast() {
        
        guard !timers.isEmpty else {
            return
        }
        timers.remove(at: timers.count - 2)
        
        takeSnapShot()
    }
    
    func deleteAllCards() {
        
        guard !timers.isEmpty else {
            return
        }
        timers = []
        configureWithAddCardCell()
        takeSnapShot()
    }
    
    func minusOneSecond() {
        
        timers.forEach {
            $0.minusOneSecond()
        }
    }
}


extension CardTimerPanelDataSource: CardTimerDelegate {
    
    func deleteCardTimer() {
        
        guard !timers.isEmpty else {
            return
        }
        for index in 0 ..< (timers.count - 1) {
            if timers[index].shouldDelete {
                timers.remove(at: index)
            }
        }
        takeSnapShot()
    }
    
}
