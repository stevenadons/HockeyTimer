//
//  MinutesView.swift
//  ProbeerselUICollectionView
//
//  Created by Steven Adons on 05/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


class MinutesView: UIButton {
    
    
    // MARK: - Properties
    
    private var timeLabel: UILabel!
    private (set) var minutes: Int!
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    private var highlightColor: UIColor = UIColor.systemYellow
    
    
    // MARK: - Init
    
    init(minutes: Int) {
        
        super.init(frame: .zero)
        self.minutes = minutes
        setup()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = .secondarySystemBackground
        layer.borderColor = highlightColor.cgColor

        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = UIColor(named: ColorName.DarkBlueText)
        timeLabel.text = String(minutes)
        timeLabel.textAlignment = .center
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.baselineAdjustment = .alignCenters
        timeLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        addSubview(timeLabel)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            timeLabel.topAnchor.constraint(equalTo: topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        layer.cornerRadius = bounds.height / 2
    }
    
    
    // MARK: - Public Methods
   
    func highlightBackground(_ bool: Bool) {
        
        layer.borderWidth = bool ? 3 : 0
    }
    
    func setHighlightColor(_ color: UIColor) {
        
        highlightColor = color
        layer.borderColor = color.cgColor
    }
    
    
    // MARK: - Private Methods
    
    
}
