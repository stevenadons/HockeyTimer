//
//  CardView.swift
//  ProbeerselUICollectionView
//
//  Created by Steven Adons on 05/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


class CardView: UIButton {
    
    
    // MARK: - Properties
    
    private var graphics: CAShapeLayer!
    private var card: Card!
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    
    // MARK: - Init
    
    init(card: Card) {
        
        super.init(frame: .zero)
        self.card = card
        setup()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.borderColor = card.color().cgColor

        graphics = CAShapeLayer()
        graphics.path = card.pathInSize(.zero).cgPath
        graphics.fillColor = card.color().cgColor
        graphics.lineCap = .round
        layer.addSublayer(graphics)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let ratio: CGFloat = card.type == .green ? 0.6 : 0.45
        let graphicsSide = min(bounds.width, bounds.height) * ratio
        let graphicsSize = CGSize(width: graphicsSide, height: graphicsSide)
        let path = card.pathInSize(graphicsSize)
        let cardYOffset = card.type == .green ? bounds.height * 0.225 : bounds.height * 0.3
        let cardXOffset = (bounds.width - graphicsSide) / 2
        let translate = CGAffineTransform(translationX: cardXOffset, y: cardYOffset)
        path.apply(translate)
        graphics.path = path.cgPath
    }
    
    
    // MARK: - Public Methods
   
    func highlightBackground(_ bool: Bool) {
        
        layer.borderWidth = bool ? 3 : 0
    }
    
    
    // MARK: - Private Methods
    
    
    
}
