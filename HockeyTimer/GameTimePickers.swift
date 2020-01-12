//
//  GameTimePickers.swift
//  HockeyTimer
//
//  Created by Steven Adons on 08/12/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class GameTimePickers: UIView {

    
    // MARK: - Properties
    
    private var leftPicker: UIPickerView!
    private var rightPicker: UIPickerView!
    private var xLabel: UILabel!
    
    private var leftDataSource: LeftPickerDataSource!
    private var rightDataSource: LeftPickerDataSource!
    
    private let vertInset: CGFloat = 24
    private let horInset: CGFloat = 24
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor(named: ColorName.Olive)!
        layer.shadowRadius = 6
        
        xLabel = UILabel()
        xLabel.translatesAutoresizingMaskIntoConstraints = false
        xLabel.text = "x"
        xLabel.font = UIFont(name: FONTNAME.ThemeRegular, size: 14)
        xLabel.contentMode = .center
        xLabel.textColor = .white
        addSubview(xLabel)
        
        leftPicker = UIPickerView()
        leftPicker.translatesAutoresizingMaskIntoConstraints = false
        leftDataSource = LeftPickerDataSource()
        leftPicker.dataSource = leftDataSource
        leftPicker.delegate = leftDataSource
        addSubview(leftPicker)

        rightPicker = UIPickerView()
        rightPicker.translatesAutoresizingMaskIntoConstraints = false
        rightDataSource = LeftPickerDataSource()
        rightPicker.dataSource = rightDataSource
        rightPicker.delegate = rightDataSource
        addSubview(rightPicker)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
        
            xLabel.topAnchor.constraint(equalTo: topAnchor, constant: vertInset),
            xLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -vertInset),
            xLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            leftPicker.topAnchor.constraint(equalTo: topAnchor, constant: vertInset),
            leftPicker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -vertInset),
            leftPicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horInset),
            leftPicker.trailingAnchor.constraint(equalTo: xLabel.leadingAnchor),
            
            rightPicker.topAnchor.constraint(equalTo: topAnchor, constant: vertInset),
            rightPicker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -vertInset),
            rightPicker.leadingAnchor.constraint(equalTo: xLabel.trailingAnchor),
            rightPicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horInset),
            
        ])
    }



}
