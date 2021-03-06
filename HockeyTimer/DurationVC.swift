//
//  DurationVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DurationVC: PanArrowVC {

    
    // MARK: - Properties
    
    var currentDuration: MINUTESINHALF?
    var selectedDuration: MINUTESINHALF?
    
    fileprivate var cancelView: UIButton!
    fileprivate var cardOne: DurationCard!
    fileprivate var cardTwo: DurationCard!
    fileprivate var cardThree: DurationCard!
    fileprivate var cardFour: DurationCard!
    fileprivate var cards: [DurationCard] = []
    
    fileprivate let padding: CGFloat = 18
    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = COLOR.White
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        for card in self.cards {
            if let index = self.cards.index(of: card) {
                card.popup(delay: 0.1 * Double(index))
            } else {
                card.popup(delay: 1.0)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        for card in self.cards {
            card.windUp()
        }
    }
    
    private func setupViews() {
        
        cancelView = UIButton()
        cancelView.addTarget(self, action: #selector(cancelViewTapped(sender:forEvent:)), for: [.touchUpInside])
        cancelView.translatesAutoresizingMaskIntoConstraints = false
        cancelView.backgroundColor = UIColor.clear
        cancelView.isUserInteractionEnabled = false
        view.insertSubview(cancelView, at: 0)

        cardOne = DurationCard(duration: .Twenty)
        cardTwo = DurationCard(duration: .TwentyFive)
        cardThree = DurationCard(duration: .Thirty)
        cardFour = DurationCard(duration: .ThirtyFive)
        cards.append(cardOne)
        cards.append(cardTwo)
        cards.append(cardThree)
        cards.append(cardFour)
        cards.forEach {
            $0.addTarget(self, action: #selector(handleCardTapped(sender:forEvent:)), for: [.touchUpInside])
            view.addSubview($0)
        }
        
        panArrowUp.alpha = 0.0
        panArrowDown.color = COLOR.LightYellow
        panArrowUpLabel.alpha = 0.0
        panArrowDownLabel.text = LS_TITLE_STOPWATCH
        panArrowDownLabel.textColor = COLOR.VeryDarkBlue
        
        NSLayoutConstraint.activate([
            
            cancelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cancelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cancelView.topAnchor.constraint(equalTo: view.topAnchor),
            cancelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cardOne.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -padding / 2),
            cardOne.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 140 / 375),
            cardOne.heightAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardOne.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -65 - padding / 2),
            
            cardTwo.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: padding / 2),
            cardTwo.widthAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardTwo.heightAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardTwo.bottomAnchor.constraint(equalTo: cardOne.bottomAnchor),
            
            cardThree.trailingAnchor.constraint(equalTo: cardOne.trailingAnchor),
            cardThree.widthAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardThree.heightAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardThree.topAnchor.constraint(equalTo: cardOne.bottomAnchor, constant: padding),
            
            cardFour.leadingAnchor.constraint(equalTo: cardTwo.leadingAnchor),
            cardFour.widthAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardFour.heightAnchor.constraint(equalTo: cardOne.widthAnchor, multiplier: 1),
            cardFour.topAnchor.constraint(equalTo: cardThree.topAnchor),
            
            ])
    }

    
    
    // MARK: - Touch Methods
    
    @objc private func handleCardTapped(sender: DurationCard, forEvent event: UIEvent) {
        
        cancelView.isUserInteractionEnabled = true
        if sender.duration != currentDuration {
            selectedDuration = sender.duration
        }
        sender.alpha = 1.0
        UIView.animate(withDuration: 0.2, animations: {
            self.cards.forEach {
                if !($0.isEqual(sender)) {
                    $0.alpha = 0.3
                }
            }
        })
    }
    
    @objc private func cancelViewTapped(sender: UIButton, forEvent event: UIEvent) {
        
        cancelView.isUserInteractionEnabled = false
        cards.forEach { $0.alpha = 1.0 }
        selectedDuration = nil
    }
    
}


