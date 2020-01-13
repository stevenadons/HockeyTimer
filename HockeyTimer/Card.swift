//
//  Card.swift
//  ProbeerselUICollectionView
//
//  Created by Steven Adons on 04/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

struct Card {
    
    
    // MARK: - Properties

    var type: CardType
    
    
    // MARK: - Public Methods
    
    func pathInSize(_ size: CGSize) -> UIBezierPath {
                
        let width = size.width
        let height = size.height
        let cornerRadius: CGFloat = min(width, height) * 6 / 100
        let outsideRadius: CGFloat = min(width, height) / 2
        let rect = CGRect(origin: .zero, size: size)
        let yOffset = outsideRadius / 8
        
        var path = UIBezierPath()
        
        switch type {
        case .green:
            
            let pointA = CGPoint(x: outsideRadius, y: yOffset)
            let pointB = CGPoint(x: 0, y: height - (outsideRadius / 2) + yOffset)
            let pointC = CGPoint(x: width - pointB.x, y: pointB.y)
            
            let pointA1 = CGPoint(x: pointA.x - cornerRadius * (sqrt(3) / 2), y: pointA.y + cornerRadius * 1.5)
            let pointA2 = CGPoint(x: pointA.x + cornerRadius * (sqrt(3) / 2), y: pointA1.y)
            let pointA3 = CGPoint(x: pointA.x, y: pointA.y + cornerRadius * 2)
            
            let pointB1 = CGPoint(x: pointB.x + cornerRadius * sqrt(3), y: pointB.y)
            let pointB2 = CGPoint(x: pointB.x + cornerRadius * sqrt(3) / 2, y: pointB.y - cornerRadius * 1.5)
            let pointB3 = CGPoint(x: pointB1.x, y: pointB1.y - cornerRadius)
            
            let pointC1 = CGPoint(x: pointC.x - cornerRadius * sqrt(3) / 2, y: pointB2.y)
            let pointC2 = CGPoint(x: pointC.x - cornerRadius * sqrt(3), y: pointC.y)
            let pointC3 = CGPoint(x: pointC2.x, y: pointC2.y - cornerRadius)
            
            path.move(to: pointA2)
            path.addLine(to: pointC1)
            path.addArc(withCenter: pointC3, radius: cornerRadius, startAngle: -.pi / 6, endAngle: .pi / 2, clockwise: true)
            path.addLine(to: pointB1)
            path.addArc(withCenter: pointB3, radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi + .pi / 6, clockwise: true)
            path.addLine(to: pointA1)
            path.addArc(withCenter: pointA3, radius: cornerRadius, startAngle: .pi + .pi / 6, endAngle: -.pi / 6, clockwise: true)
            
        case .yellow:
            
            path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            
        default: // case .red
            
            path = UIBezierPath(ovalIn: rect)
        }
        
        return path
    }
    
    
    func color() -> UIColor {
        
        switch type {
        case .green:
            return UIColor(named: ColorName.PantoneGreenLight)!
        case .yellow:
            return UIColor(named: ColorName.PantoneYellow)!
        default:
            return UIColor(named: ColorName.PantoneRed)!
        }
    }
}


extension Card: Hashable {
    
    
    
}
