//
//  FeatureView.swift
//  HockeyTimer
//
//  Created by Steven Adons on 19/07/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


protocol FeatureViewable {
    
    var image: UIImage { get }
    var bodyText: String { get }
}


class FeatureView: UIView {

    // MARK: - Properties

    var graphics: UIImageView!
    var body: UILabel!
    
    var bodyFont: UIFont? {
        didSet {
            body.font = bodyFont
            setNeedsDisplay()
        }
    }
    var bodyFontColor: UIColor? {
        didSet {
            body.textColor = bodyFontColor
            setNeedsDisplay()
        }
    }
    
    private var feature: FeatureViewable!
    
    
    // MARK: - Initializers
    
    init(feature: FeatureViewable) {
        
        super.init(frame: .zero)
        self.feature = feature
        setup()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        backgroundColor = .clear
        
        graphics = UIImageView()
        graphics.translatesAutoresizingMaskIntoConstraints = false
        graphics.contentMode = .scaleAspectFit
        graphics.image = feature.image
        addSubview(graphics)
        
        body = UILabel()
        body.text = feature.bodyText
        body.numberOfLines = 0
        body.font = UIFont(name: FONTNAME.ThemeRegular, size: 16)
        body.isUserInteractionEnabled = false
        body.textAlignment = .center
        body.textColor = UIColor(named: ColorName.VeryDarkBlue_White)!
        body.backgroundColor = .clear
        body.translatesAutoresizingMaskIntoConstraints = false
        addSubview(body)
    }
    
    // MARK: - Draw and layout

    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            graphics.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            graphics.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            graphics.topAnchor.constraint(equalTo: topAnchor),
            graphics.bottomAnchor.constraint(equalTo: body.topAnchor),
            
            body.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            body.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            body.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            ])
    }
    
    // MARK: - Public Methods
    
    func addImage(image: UIImage) {
        
        graphics.image = image
    }
    
}
