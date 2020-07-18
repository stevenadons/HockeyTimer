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
    var selectedPlayer: String? {
        let index = picker.selectedRow(inComponent: 0) 
        return pickerDataSource.itemAtIndex(index)
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
        let players: [String] = createPlayers()
        pickerDataSource = PlayerPickerDataSource(data: players)
        picker.selectRow(2, inComponent: 0, animated: false)
        addSubview(picker)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let vertRatio: CGFloat = 0.9
        
        NSLayoutConstraint.activate([
        
            picker.widthAnchor.constraint(equalTo: widthAnchor),
            picker.centerXAnchor.constraint(equalTo: centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: centerYAnchor),
            picker.heightAnchor.constraint(equalTo: heightAnchor, multiplier: vertRatio),
            
        ])
    }
    
    
    // MARK: - Public Methods
    
    
    
    // MARK: - Touch Methods
    
    
    
    
    // MARK: - Private Methods
    
    private func createPlayers() -> [String] {
        
        var result: [String] = [LS_CAPTAIN, LS_STAFF]
        for int in 1 ... 99 {
            result.append(String(int))
        }
        return result
    }
    
}
