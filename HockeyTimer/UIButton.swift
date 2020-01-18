//
//  UIButton.swift
//  HockeyTimer
//
//  Created by Steven Adons on 18/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


extension UIButton {
    
    class func createTopButton(imageName: String, tintColor: UIColor) -> UIButton {
        
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)
        let tintColor = tintColor
        let resetImage = UIImage(systemName: imageName, withConfiguration: configuration)?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        button.setImage(resetImage, for: .normal)
        
        return button
    }
}
