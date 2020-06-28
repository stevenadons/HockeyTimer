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
    
    private var playerLabel: UILabel!
    private var shape: UIView!
    private var path: UIBezierPath!

    private var player: String = "0"
    private var playerColor: UIColor = .white {
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
    
    convenience init(player: String, numberColor: UIColor, shapeColor: UIColor) {
        
        self.init()
        
        self.player = player
        self.playerColor = numberColor
        self.shapeColor = shapeColor
        
        setup()
    }
    
    private func setup() {
        
        shape = UIView()
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.backgroundColor = shapeColor
        addSubview(shape)
        
        playerLabel = UILabel()
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        playerLabel.numberOfLines = 1
        playerLabel.textAlignment = .center
        playerLabel.font = UIFont(name: FONTNAME.Numbers, size: 28)
        playerLabel.textColor = playerColor
        playerLabel.text = player
        addSubview(playerLabel)
    }
    
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        playerLabel.textColor = playerColor
        shape.backgroundColor = shapeColor
        
        let shapeWidth = min(bounds.height, bounds.width) * 0.9
        shape.layer.cornerRadius = 8
                
        NSLayoutConstraint.activate([
            
            shape.centerXAnchor.constraint(equalTo: centerXAnchor),
            shape.widthAnchor.constraint(equalToConstant: shapeWidth),
            shape.centerYAnchor.constraint(equalTo: centerYAnchor),
            shape.heightAnchor.constraint(equalToConstant: shapeWidth),
        
            playerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            playerLabel.widthAnchor.constraint(equalTo: widthAnchor),
            playerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            playerLabel.heightAnchor.constraint(equalTo: heightAnchor),
        
        ])
    }
}
