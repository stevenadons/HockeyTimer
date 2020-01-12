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
    
    private var notification: UIImageView!

    
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
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        notification = UIImageView()
        if let signalImage = UIImage(named: "notification") {
            notification.image = signalImage
        }
        notification.contentMode = .scaleAspectFit
        notification.translatesAutoresizingMaskIntoConstraints = false
        addSubview(notification)
        
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            notification.heightAnchor.constraint(equalToConstant: 100),
            notification.centerYAnchor.constraint(equalTo: centerYAnchor),
            notification.centerXAnchor.constraint(equalTo: centerXAnchor),
            notification.widthAnchor.constraint(equalTo: notification.heightAnchor),
            
            ])
    }
    
    

}
