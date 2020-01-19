//
//  CountryCell.swift
//  HockeyTimer
//
//  Created by Steven Adons on 19/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    
    // MARK: - Properties
    
    private var oval: OvalCountryButton!
    private var countryLabel: UILabel!
    
    
    // MARK: - Initializing
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .secondarySystemBackground
        selectionStyle = .blue
        
        oval = OvalCountryButton(capitals: "ZZZ", color: .white, crossColor: .white)
        oval.translatesAutoresizingMaskIntoConstraints = false
        addSubview(oval)
        
        countryLabel = UILabel()
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.numberOfLines = 1
        countryLabel.textAlignment = .left
        countryLabel.textColor = .label
        countryLabel.font = UIFont(name: FONTNAME.ThemeBold, size: 17)
        addSubview(countryLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:)")
    }
    
    
    // MARK: - Public Methods
    
    func configureWith(country: Country, textColor: UIColor, ovalColor: UIColor) {
        
        countryLabel.text = country.name
        countryLabel.textColor = textColor
        
        oval.setCapitals(country.capitals)
        oval.setColor(ovalColor, crossColor: ovalColor)
    }

    
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let inset: CGFloat = UIDevice.whenDeviceIs(small: 12, normal: 16, big: 16)
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            
            oval.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            oval.widthAnchor.constraint(equalToConstant: 44),
            oval.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            countryLabel.leadingAnchor.constraint(equalTo: oval.trailingAnchor, constant: padding),
            countryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            countryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countryLabel.heightAnchor.constraint(equalTo: heightAnchor),
            
            ])
        
        
    }
    
    
    
    // MARK: - Touch Methods
    
   

}
