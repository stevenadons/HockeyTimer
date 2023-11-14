//
//  BlockMenuItemButton.swift
//  HockeyTimer
//
//  Created by Steven Adons on 19/07/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class BlockMenuItemButton: UIButton {

    
    // MARK: - Properties
    
    var contentColor: UIColor = .systemBackground {
        didSet {
            if let image = UIImage(systemName: imageName, withConfiguration: config)?.withTintColor(contentColor, renderingMode: .alwaysOriginal) {
                setImage(image, for: .normal)
            }
        }
    }
    var bgColor: UIColor = .systemBlue {
        didSet {
            backgroundColor = bgColor
        }
    }
    var imageName: String = "line.horizontal.3" {
        didSet {
            if let image = UIImage(systemName: imageName, withConfiguration: config)?.withTintColor(contentColor, renderingMode: .alwaysOriginal) {
                setImage(image, for: .normal)
            }
        }
    }
    
    private let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .large)
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = bgColor
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    convenience init(shapeColor: UIColor, bgColor: UIColor, imageName: String) {
        
        self.init()
        convenienceSet(shapeColor: shapeColor, bgColor: bgColor, imageName: imageName)
    }
    
    private func convenienceSet(shapeColor: UIColor, bgColor: UIColor, imageName: String) {
        
        self.contentColor = shapeColor
        self.bgColor = bgColor
        self.imageName = imageName
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

}
