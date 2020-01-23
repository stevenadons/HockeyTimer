//
//  StopWatchLabel.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 22/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


class StopWatchLabel: UIView {
    
    
    // MARK: - Properties
    
    var text: String = "" {
        didSet {
            setNeedsLayout()
        }
    }
    var textColor: UIColor = UIColor(named: ColorName.VeryDarkBlue_White)! {
        didSet {
            label.textColor = textColor
            setNeedsDisplay()
        }
    }
    private (set) var standardColor: UIColor = UIColor(named: ColorName.VeryDarkBlue_White)!
    
    private var label: UILabel!
    
    
    
    // MARK: - Initializers
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(text: String) {
        
        self.init()
        self.text = text
    }
    
    
    
    // MARK: - Public methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        label.text = text
    }
    
    
    
    // MARK: - UI methods
    
    private func setup() {
        
        // Configure self
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        // Add label
        label = label(text: text, alignment: .center)
        addSubview(label)
        
        // Set constraints
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor),
            ])
    }
    
    private func label(text: String, alignment: NSTextAlignment) -> UILabel {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = textColor
        label.text = text
        label.textAlignment = alignment
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.font = UIFont(name: FONTNAME.Numbers, size: 48)
        
        return label
    }
    

    // MARK: - User methods
    
    func setFont(font: UIFont) {
        
        label.font = font
        setNeedsDisplay()
    }


    
}
