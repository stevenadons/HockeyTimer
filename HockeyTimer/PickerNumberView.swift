//
//  PickerNumberView.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//


import UIKit

class PickerNumberView: UIView {

    
    // MARK: - Properties
    
    private var numberLabel: UILabel!
    private var shape: UIView!
    private var path: UIBezierPath!

    private var number: Double = 0.0
    private var isSmall: Bool = false
    private var isVeryBig: Bool = false
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
    
    convenience init(number: Double, numberColor: UIColor, shapeColor: UIColor, isSmall: Bool, isVeryBig: Bool) {
        
        self.init()
        
        self.number = number
        self.numberColor = numberColor
        self.shapeColor = shapeColor
        self.isSmall = isSmall
        self.isVeryBig = isVeryBig
        
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
        var pointSize: CGFloat = isSmall ? 26 : 36
        if isVeryBig {
            pointSize = 46
        }
        numberLabel.font = UIFont(name: FONTNAME.Numbers, size: pointSize)
        numberLabel.textColor = numberColor
        numberLabel.attributedText = number.createFormattedString(size: pointSize, decimalSize: pointSize - 12)
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
