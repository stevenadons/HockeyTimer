//
//  CardTimerPanelDataSource.swift
//  ProbeerselUICollectionView
//
//  Created by Steven Adons on 04/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class CardTimerPanelDataSource: UICollectionViewDiffableDataSource<Int, AnnotatedCardTimer> {
    
    
    // MARK: - Properties
    
    private var timers: [AnnotatedCardTimer] = [] {
        didSet {
            updateGlobalSecondsToGo()
        }
    }
    
    var count: Int {
        return timers.count
    }
    
    // MARK: - Private Methods
    
    private func updateGlobalSecondsToGo() {
        
        allCardsSecondsToGo = timers.map {
            $0.secondsToGo
        }
    }
    
    
    // MARK: - Public Methods
    
    func takeSnapShot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, AnnotatedCardTimer>()
        snapshot.appendSections([0])
        snapshot.appendItems(timers, toSection: 0)
        apply(snapshot)
    }
    
    func configureWithAddCardCell() {
        
        let dummyCard = Card(type: .green)
        let addCardTimer = AnnotatedCardTimer(card: dummyCard, minutes: 9999, delegate: self, isDummyForAddCard: true)
        timers.append(addCardTimer)
    }
    
    func addTimerFor(_ card: Card, minutes: Int, team: Player?, player: Int?) {
        
        let timer = AnnotatedCardTimer(card: card, minutes: minutes, team: team, player: player, delegate: self)
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
        updateGlobalSecondsToGo()
    }
    
    func updateAfterRestoringFromBackground() {
        
        guard allCardsSecondsToGo.count == timers.count else {
            return
        }
        for index in 0 ..< timers.count {
            timers[index].setSecondsToGo(allCardsSecondsToGo[index], sound: false)
        }
    }
}


extension CardTimerPanelDataSource: AnnotatedCardTimerDelegate {
    
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
