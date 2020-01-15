//
//  MainMenuButton.swift
//  HockeyTimer
//
//  Created by Steven Adons on 14/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class MainMenuButton: UIButton {

    
    // MARK: - Properties
    
    private var hamburgerColor: UIColor = .black
    private var crossColor: UIColor = .white
    
    private let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)
    private var showingCross: Bool = false
    
    
    
    // MARK: - Initializing
    
    convenience init(hamburgerColor: UIColor, crossColor: UIColor) {
        
        self.init(frame: .zero)
        setColor(hamburgerColor: hamburgerColor, crossColor: crossColor)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = true
        
        showHamburger()
    }
    
    
    
    // MARK: - Layout and draw methods
    
  
    
    
    // MARK: - User Methods
    
    func showCross() {
        
        let image = UIImage(systemName: "xmark", withConfiguration: configuration)?.withTintColor(crossColor, renderingMode: .alwaysOriginal)
        setImage(image, for: .normal)
        showingCross = true
    }
    
    func showHamburger() {
        
        let image = UIImage(systemName: "line.horizontal.3", withConfiguration: configuration)?.withTintColor(hamburgerColor, renderingMode: .alwaysOriginal)
        setImage(image, for: .normal)
        showingCross = false
    }
    
    func setColor(hamburgerColor: UIColor, crossColor: UIColor) {
        
        self.hamburgerColor = hamburgerColor
        self.crossColor = crossColor
        if showingCross {
            showCross()
        } else {
            showHamburger()
        }
    }
}
