//
//  AppIconCard.swift
//  HockeyTimer
//
//  Created by Steven Adons on 02/02/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


class AppIconCard: UIButton {
    
    
    // MARK: - Properties
    
    private (set) var imageName: String!
    private var iconView: UIImageView!
    
    private let iconDimension: CGFloat = 60
    
    
    // MARK: - Init
    
    init(imageName: String) {
        
        super.init(frame: .zero)
        self.imageName = imageName
        setup()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.borderWidth = 0
        layer.borderColor = UIColor(named: ColorName.DarkBlueText)!.cgColor
        
        iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: imageName) {
            iconView.image = image
        }
        iconView.layer.cornerRadius = 12
        iconView.clipsToBounds = true
        addSubview(iconView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: iconDimension),
            iconView.heightAnchor.constraint(equalToConstant: iconDimension),
        
        ])
        
        layer.borderColor = UIColor(named: ColorName.DarkBlueText)!.cgColor
    }
    
    
    // MARK: - Public Methods
   
    func highlight(_ bool: Bool) {
        
        layer.borderWidth = bool ? 3 : 0
    }
    
    
    // MARK: - Private Methods
    
    
    
}
