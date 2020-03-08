//
//  PlayerPickerView.swift
//  HockeyTimer
//
//  Created by Steven Adons on 08/03/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class PlayerPickerView: UIView {

    
    // MARK: - Properties
    
    private var numberLabel: UILabel!
    private var shape: UIView!
    private var path: UIBezierPath!

    private var number: Int = 0
    private var numberColor: UIColor = .systemBackground {
        didSet {
            setNeedsLayout()
        }
    }
    private var shapeColor: UIColor = .label {
        didSet {
            setNeedsLayout()
        }
    }

    
    // MARK: - Initializers
    
    convenience init(number: Int, numberColor: UIColor, shapeColor: UIColor) {
        
        self.init()
        
        self.number = number
        self.numberColor = numberColor
        self.shapeColor = shapeColor
        
        setup()
    }
    
    private func setup() {
        
        shape = UIView()
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.backgroundColor = shapeColor
        addSubview(shape)
        
        numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.numberOfLines = 1
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont(name: FONTNAME.Numbers, size: 28)
        numberLabel.textColor = numberColor
        numberLabel.text = String(number)
        addSubview(numberLabel)
    }
    
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        numberLabel.textColor = numberColor
        shape.backgroundColor = shapeColor
        
        let shapeWidth = min(bounds.height, bounds.width) * 0.9
        shape.layer.cornerRadius = 8
                
        NSLayoutConstraint.activate([
            
            shape.centerXAnchor.constraint(equalTo: centerXAnchor),
            shape.widthAnchor.constraint(equalToConstant: shapeWidth),
            shape.centerYAnchor.constraint(equalTo: centerYAnchor),
            shape.heightAnchor.constraint(equalToConstant: shapeWidth),
        
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberLabel.widthAnchor.constraint(equalTo: widthAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.heightAnchor.constraint(equalTo: heightAnchor),
        
        ])
    }
}
