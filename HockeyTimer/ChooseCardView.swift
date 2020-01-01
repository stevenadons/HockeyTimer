//
//  ChooseCardView.swift
//  HockeyTimer
//
//  Created by Steven Adons on 01/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class ChooseCardView: UIButton {
    
    
    // MARK: - Properties
    
    private var graphics: CAShapeLayer!
    private var card: Card!
    
    private var insetFactor: CGFloat {
        switch card {
        case .green:
            return 0.1
        default:
            return 0.2
        }
    }
    
    private let highlightedColor: UIColor = UIColor(named: "LightBlue")!
    private let standardColor: UIColor = UIColor(named: "DarkGray")!
   
    
    
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
        backgroundColor = standardColor
        
        graphics = CAShapeLayer()
        graphics.path = card.pathInSize(.zero).cgPath
        graphics.fillColor = card.color().cgColor
        graphics.lineCap = .round
        layer.addSublayer(graphics)
        
        layer.cornerRadius = 12
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        let graphicsBounds = bounds.insetBy(dx: bounds.width * insetFactor, dy: bounds.height * insetFactor)
        let path = card.pathInSize(graphicsBounds.size)
        let translate = CGAffineTransform(translationX: bounds.width * insetFactor, y: bounds.height * insetFactor)
        path.apply(translate)
        graphics.path = path.cgPath
    }
    
    
    
    // MARK: - Public Methods
    
    func highlightBackground(_ bool: Bool) {
        
        backgroundColor = bool ? highlightedColor : standardColor
    }
    
    
}
