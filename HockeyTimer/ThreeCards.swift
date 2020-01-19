//
//  ThreeCards.swift
//  ProbeerselUICollectionView
//
//  Created by Steven Adons on 10/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class ThreeCards: CALayer {
    
    
    // MARK: - Properties
    
    private var green: CAShapeLayer!
    private var yellow: CAShapeLayer!
    private var red: CAShapeLayer!
    
    private var isGrayScale: Bool = false
    
    private let greenCard: Card = Card(type: .green)
    private let yellowCard: Card = Card(type: .yellow)
    private let redCard: Card = Card(type: .red)
    
    private let grayScaleGreen: UIColor = UIColor(named: ColorName.GrayScaleGreenCard)!
    private let grayScaleYellow: UIColor = UIColor(named: ColorName.GrayScaleYellowCard)!
    private let grayScaleRed: UIColor = UIColor(named: ColorName.GrayScaleRedCard)!

    
    
    // MARK: - Init
    
    override init(layer: Any) {
        
        super.init(layer: layer)
        setup()
    }

    override init() {
        
        super.init()
        setup()
    }
    
    convenience init(grayScale: Bool) {
        
        self.init()
        if grayScale {
            makeGrayScale()
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        green = CAShapeLayer()
        green.fillColor = greenCard.color().cgColor
        addSublayer(green)
        
        yellow = CAShapeLayer()
        yellow.fillColor = yellowCard.color().cgColor
        addSublayer(yellow)
        
        red = CAShapeLayer()
        red.fillColor = redCard.color().cgColor
        addSublayer(red)
    }
    
    
    // MARK: - Layout
    
    override func layoutSublayers() {
        
        super.layoutSublayers()
        
        let minimumSide = min(bounds.width, bounds.height)
        let cardSide = minimumSide * 0.5
        
        let greenCardSize = CGSize(width: cardSide * 1.3, height: cardSide * 1.3)
        let greenPath = greenCard.pathInSize(greenCardSize)
        let greenX = (bounds.width - minimumSide) / 2 + cardSide / 1.3 - minimumSide * 0.1
        let greenY = (bounds.height - minimumSide) / 2 - cardSide * 0.05
        let greenTranslate = CGAffineTransform(translationX: greenX, y: greenY)
        greenPath.apply(greenTranslate)
        green.path = greenPath.cgPath
        
        let yellowCardSize = CGSize(width: cardSide * 0.8, height: cardSide * 0.8)
        let yellowPath = yellowCard.pathInSize(yellowCardSize)
        let yellowX = (bounds.width - minimumSide) / 2 + minimumSide * 0.15
        let yellowY = (bounds.height - minimumSide) / 2 + minimumSide * 0.25
        let yellowTranslate = CGAffineTransform(translationX: yellowX, y: yellowY)
        yellowPath.apply(yellowTranslate)
        yellow.path = yellowPath.cgPath
        
        
        let redCardSize = CGSize(width: cardSide * 0.9, height: cardSide * 0.9)
        let redPath = redCard.pathInSize(redCardSize)
        let redX = (bounds.width - minimumSide) / 2 + minimumSide * 0.3
        let redY = (bounds.height - minimumSide) / 2 + minimumSide * 0.375
        let redTranslate = CGAffineTransform(translationX: redX, y: redY)
        redPath.apply(redTranslate)
        red.path = redPath.cgPath
    }
    
    private func makeGrayScale() {
        
        green.fillColor = grayScaleGreen.cgColor
        yellow.fillColor = grayScaleYellow.cgColor
        red.fillColor = grayScaleRed.cgColor
    }
}
