//
//  CardTimerPanel.swift
//  ProbeerselUICollectionView
//
//  Created by Steven Adons on 04/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


protocol CardTimerPanelDelegate: AnyObject {
    
    func shouldAddCard()
}


class CardTimerPanel: UIView {
    
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView!
    
    private var dataSource: CardTimerPanelDataSource!
    weak var delegate: CardTimerPanelDelegate?
    
    var timers: [AnnotatedCardTimer] {
        return dataSource.timers
    }
    
    private let padding: CGFloat = 10
    private var itemWidth: CGFloat {
        return bounds.height * 0.8
    }
    private var itemHeight: CGFloat {
        return bounds.height
    }
    
    
    // MARK: - Init and Layout
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = padding
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(CardTimerCell.self, forCellWithReuseIdentifier: "CardTimerCell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        addSubview(collectionView)
        
        dataSource = CardTimerPanelDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, cardTimer) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardTimerCell", for: indexPath) as! CardTimerCell
            cell.configure(with: cardTimer)
            return cell
        })
        dataSource.configureWithAddCardCell()
        dataSource.takeSnapShot()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        
        ])
        
        dataSource.takeSnapShot()
    }
    
    
    // MARK: - Public Methods
    
    func add(_ card: Card, minutes: Int, cardDrawnAtMinute: Int, team: Team?, player: String?) {
        
        dataSource.addTimerFor(card, minutes: minutes, cardDrawnAtMinute: cardDrawnAtMinute, team: team, player: player)
    }
    
    func deleteLast() {
        
        dataSource.deleteLast()
    }
    
    func deleteAllCards() {
        
        dataSource.deleteAllCards()
    }
    
    func minusOneSecond() {
        
        dataSource.minusOneSecond()
    }
    
    func updateAfterRestoringFromBackground() {
        
        dataSource.updateAfterRestoringFromBackground()
    }
 
}


extension CardTimerPanel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // Center items in middle of view
        let totalPadding = dataSource.count > 0 ? CGFloat(dataSource.count - 1) * padding : 0
        let cardsSpan = CGFloat(dataSource.count) * itemWidth + totalPadding
        let inset = max((bounds.width - cardsSpan) / 2, 30)
        
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}


extension CardTimerPanel: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard indexPath.row == dataSource.count - 1 else {
            return
        }
        delegate?.shouldAddCard()
    }
}


