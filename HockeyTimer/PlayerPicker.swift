//
//  PlayerPicker.swift
//  HockeyTimer
//
//  Created by Steven Adons on 08/03/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class PlayerPicker: UIView {

    
    // MARK: - Properties
    
    private var picker: UIPickerView!
    private var pickerDataSource: PlayerPickerDataSource! {
        didSet {
            picker.dataSource = pickerDataSource
            picker.delegate = pickerDataSource
        }
    }
    var selectedPlayer: Int? {
        let index = picker.selectedRow(inComponent: 0) 
        return pickerDataSource.numberAtIndex(index)
    }
    
    
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
        
        picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        let players: [Int] = createPlayers()
        pickerDataSource = PlayerPickerDataSource(data: players)
        addSubview(picker)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let vertRatio: CGFloat = 0.9
        let pickerWidth: CGFloat = 120
        
        NSLayoutConstraint.activate([
        
            picker.widthAnchor.constraint(equalToConstant: pickerWidth),
            picker.centerXAnchor.constraint(equalTo: centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: centerYAnchor),
            picker.heightAnchor.constraint(equalTo: heightAnchor, multiplier: vertRatio),
            
        ])
    }
    
    
    // MARK: - Public Methods
    
    
    
    // MARK: - Touch Methods
    
    
    
    
    // MARK: - Private Methods
    
    private func createPlayers() -> [Int] {
        
        var result: [Int] = []
        for int in 0 ... 99 {
            result.append(int)
        }
        return result
    }
    
}
