//
//  RulesCell.swift
//  HockeyTimer
//
//  Created by Steven Adons on 25/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class RulesCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    private var button: RulesButton?
    
    private (set) var rules: Rules!
    private var bgColor: UIColor = .secondarySystemBackground
    private var txtColor: UIColor = .label
    private var alignment: NSTextAlignment = .left
    
    
    // MARK: - Initializing
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .clear
        selectionStyle = .none
        
        // add button
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:)")
    }
    
    
    // MARK: - Public Methods
    
    func configureWith(rules: Rules, textColor: UIColor, bgColor: UIColor, alignment: NSTextAlignment) {
        
        self.rules = rules
        self.txtColor = textColor
        self.bgColor = bgColor
        self.alignment = alignment
        
        button?.removeFromSuperview()
        button = RulesButton.button(rules: rules, color: bgColor, titleColor: txtColor)
        button!.translatesAutoresizingMaskIntoConstraints = false
        button!.isUserInteractionEnabled = false
        addSubview(button!)
    }
    
    
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        guard let button = button else {
            return
        }
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: RulesButton.fixedHeight),
            button.widthAnchor.constraint(equalToConstant: RulesButton.fixedWidth),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        let horInset = min((bounds.width - RulesButton.fixedWidth) / 2 - 15, 55)
        if alignment == .right {
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horInset).isActive = true
        } else if alignment == .left {
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horInset).isActive = true
        } else {
            button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        }
    }
}
