//
//  PhoneView.swift
//  HockeyTimer
//
//  Created by Steven Adons on 30/11/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PhoneView: UIView {

    
    // MARK: - Properties
    
//    private var phone: UIImageView!
    private var signal: UIImageView!

    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        signal = UIImageView()
        if let signalImage = UIImage(named: "wifi") {
            signal.image = signalImage
        }
        signal.tintColor = COLOR.DarkBlue
        signal.contentMode = .scaleAspectFit
        signal.translatesAutoresizingMaskIntoConstraints = false
        addSubview(signal)
        
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            signal.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            signal.centerYAnchor.constraint(equalTo: centerYAnchor),
            signal.centerXAnchor.constraint(equalTo: centerXAnchor),
            signal.widthAnchor.constraint(equalTo: signal.heightAnchor),
            ])
    }
    
    

}
