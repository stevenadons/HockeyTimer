//
//  IconButton.swift
//  HockeyTimer
//
//  Created by Steven Adons on 01/02/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class IconButton: UIButton {
    
    
    // MARK: - Properties
    
    private var iconImage: UIImageView!
    private var textLabel: UILabel!

    private var imageName: String!
    private var text: String!
    private var iconColor: UIColor!
    private var textColor: UIColor!
    
    private let iconWidth: CGFloat = 24
    private let iconHeight: CGFloat = 24
    
    private let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .large)
    
    static var standardWidth: CGFloat = 65
    static var standardHeight: CGFloat = 65
    
    
    // MARK: - Init

    init(imageName: String, text: String, iconColor: UIColor, textColor: UIColor) {
        
        super.init(frame: .zero)
        
        self.imageName = imageName
        self.text = text
        self.iconColor = iconColor
        self.textColor = textColor
        
        translatesAutoresizingMaskIntoConstraints = false
        
        iconImage = UIImageView()
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: imageName, withConfiguration: config)?.withTintColor(iconColor, renderingMode: .alwaysOriginal)
        iconImage.image = image
        iconImage.contentMode = .scaleAspectFill
        addSubview(iconImage)
        
        textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 1
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name: FONTNAME.ThemeBlack, size: 12)!
        textLabel.textColor = textColor
        textLabel.text = text
        addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            iconImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: iconWidth),
            iconImage.heightAnchor.constraint(equalToConstant: iconHeight),
            iconImage.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -6),
            
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.widthAnchor.constraint(equalTo: widthAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        
        ])
    }
    
    
    // MARK: - Public Methods
    
    func setColor(iconColor: UIColor, textColor: UIColor) {
        
        self.iconColor = iconColor
        let image = UIImage(systemName: imageName, withConfiguration: config)?.withTintColor(iconColor, renderingMode: .alwaysOriginal)
        iconImage.image = image
        
        self.textColor = textColor
        textLabel.textColor = textColor
    }

    
}
