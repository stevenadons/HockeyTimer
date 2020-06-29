//
//  MessageView.swift
//  HockeyTimer
//
//  Created by Steven Adons on 28/06/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit



class MessageView: UIView {

    
    // MARK: - Properties
    
    private var balloon: UIView!
    private var label: UILabel!
    private var xButton: XButton!
    
    private var message: String = "" {
        didSet {
            alpha = (message != "") ? 1.0 : 0.0
        }
    }
    
    
    
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
        alpha = 0.0
        
        balloon = UIView()
        balloon.translatesAutoresizingMaskIntoConstraints = false
        balloon.backgroundColor = UIColor(named: ColorName.MessageView)!
        balloon.layer.cornerRadius = 8
        addSubview(balloon)

        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = message
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.adjustsFontSizeToFitWidth = false
        addSubview(label)
        
        xButton = XButton(color: .white, bgColor: .clear)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        xButton.addTarget(self, action: #selector(xTapped), for: .touchUpInside)
        addSubview(xButton)
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let xButtonDimension: CGFloat = 36
        
        NSLayoutConstraint.activate([
            
            balloon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            balloon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            balloon.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            balloon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36 - xButtonDimension - 6),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            xButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            xButton.heightAnchor.constraint(equalToConstant: xButtonDimension),
            xButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            xButton.widthAnchor.constraint(equalToConstant: xButtonDimension),
            
            ])
    }
    
    // MARK: - Public Methods
    
    func setMessage(_ message: String) {
        
        self.message = message
        label.text = message
    }
    
    
    // MARK: - Touch methods
    
    @objc private func xTapped() {
        
        message = ""
    }
    
}


