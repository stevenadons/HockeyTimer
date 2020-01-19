//
//  OnboardScreen.swift
//  AntiTheftMode
//
//  Created by Steven Adons on 15/06/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class OnboardScreen: UIView {

    
    // MARK: - Properties

    var logo: UILabel!
    var graphics: UIView!
    var title: UILabel!
    var body: UITextView!
    
    var logoFont: UIFont? {
        didSet {
            logo.font = logoFont
            setNeedsDisplay()
        }
    }
    var logoFontColor: UIColor? {
        didSet {
            logo.textColor = logoFontColor
            setNeedsDisplay()
        }
    }
    var titleFont: UIFont? {
        didSet {
            title.font = titleFont
            setNeedsDisplay()
        }
    }
    var titleFontColor: UIColor? {
        didSet {
            title.textColor = titleFontColor
            setNeedsDisplay()
        }
    }
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
        
        logo = createLabel(bold: true, fontSize: 24)
        logo.font = UIFont(name: FONTNAME.ThemeBlack, size: 24)
        logo.textColor = UIColor(named: ColorName.VeryDarkBlue_White)!
        addSubview(logo)
        
        graphics = UIView()
        graphics.translatesAutoresizingMaskIntoConstraints = false
        addSubview(graphics)
        
        title = createLabel(bold: true, fontSize: 24)
        title.font = UIFont(name: FONTNAME.ThemeBold, size: 24)
        title.textColor = UIColor(named: ColorName.VeryDarkBlue_White)!
        addSubview(title)
        
        body = UITextView()
        body.text = ""
        body.font = UIFont(name: FONTNAME.ThemeRegular, size: 17)
        body.isUserInteractionEnabled = false
        body.textAlignment = .center
        body.textColor = UIColor(named: ColorName.VeryDarkBlue_White)!
        body.backgroundColor = .clear
        body.translatesAutoresizingMaskIntoConstraints = false
        addSubview(body)
    }
    
    private func createLabel(bold: Bool, fontSize: CGFloat) -> UILabel {
        
        let label = UILabel()
        label.text = ""
        label.font = bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // MARK: - Draw and layout

    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            
            logo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            logo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            logo.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            logo.heightAnchor.constraint(equalToConstant: 45),
            
            graphics.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            graphics.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            graphics.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            graphics.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 300/667),
            
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            title.topAnchor.constraint(equalTo: graphics.bottomAnchor),
            title.heightAnchor.constraint(equalToConstant: 30),
            
            body.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            body.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            body.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            body.heightAnchor.constraint(equalToConstant: 125),
            
            ])
    }

    
}
