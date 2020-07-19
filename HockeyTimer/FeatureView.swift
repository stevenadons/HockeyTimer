//
//  FeatureView.swift
//  HockeyTimer
//
//  Created by Steven Adons on 19/07/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

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
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .systemBackground
        
        graphics = UIImageView()
        graphics.translatesAutoresizingMaskIntoConstraints = false
        graphics.contentMode = .scaleAspectFit
        addSubview(graphics)
        
        body = UILabel()
        body.text = ""
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
