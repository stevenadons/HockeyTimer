//
//  OvalCountryButton.swift
//  HockeyTimer
//
//  Created by Steven Adons on 04/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit


class OvalCountryButton: UIButton {
    
    
    // MARK: - Properties
    
    private var capitals: String!
    private var color: UIColor = .white
    private var crossColor: UIColor = .white
    
    private var oval: OvalCountryLayer!
    private var capitalsLabel: UILabel!
    private var cross: OvalCountryCross!
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 44, height: 44)
    }
    
    
    // MARK: - Initializing
    
    convenience init(capitals: String, color: UIColor, crossColor: UIColor) {
        
        self.init()
        self.capitals = capitals
        self.color = color
        self.crossColor = crossColor
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = true
        clipsToBounds = true
        
        if let image = UIImage(named: capitals) {
            setImage(image, for: .normal)
        }
        
        oval = OvalCountryLayer(color: color)
        layer.addSublayer(oval)
        
        capitalsLabel = UILabel()
        capitalsLabel.text = capitals
        capitalsLabel.font = UIFont(name: FONTNAME.ThemeBold, size: 28)
        capitalsLabel.adjustsFontSizeToFitWidth = true
        capitalsLabel.textAlignment = .center
        capitalsLabel.textColor = color
        capitalsLabel.baselineAdjustment = .alignCenters
        capitalsLabel.numberOfLines = 1
        addSubview(capitalsLabel)
        
        cross = OvalCountryCross(color: crossColor)
        cross.opacity = 0.0
        layer.addSublayer(cross)
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
        oval.frame = bounds
        oval.setNeedsLayout()
        capitalsLabel.font = UIFont(name: FONTNAME.ThemeBold, size: bounds.height * 0.4)
        capitalsLabel.frame = bounds.insetBy(dx: bounds.height * 0.2, dy: 0.175)
        cross.frame = bounds
    }
    
    
    // MARK: - Public Methods
    
    func setCapitals(_ capitals: String) {
        
        self.capitals = capitals
        capitalsLabel.text = capitals
    }
    
    func showCross() {
        
        cross.opacity = 1.0
        oval.opacity = 0.0
        capitalsLabel.alpha = 0.0
    }
    
    func hideCross() {
        
        cross.opacity = 0.0
        oval.opacity = 1.0
        capitalsLabel.alpha = 1.0
    }
    
    func setColor(_ color: UIColor, crossColor: UIColor) {
        
        self.color = color
        self.crossColor = crossColor
        oval.setColor(color)
        cross.setColor(crossColor)
        capitalsLabel.textColor = color
    }
}
