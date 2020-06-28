//
//  PlayerPickerDataSource.swift
//  HockeyTimer
//
//  Created by Steven Adons on 08/03/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class PlayerPickerDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    

    // MARK: - Properties
    
    private var data: [String]!
    
    
    
    // MARK: - Init
    
    init(data: [String]) {
        
        super.init()
        self.data = data
    }
    
    
    // MARK: - Public Methods
    
    func itemAtIndex(_ index: Int) -> String? {
       
        guard index < data.count else {
            return nil
        }
        return data[index]
    }
    
    func indexForItem(_ string: String) -> Int? {
        
        return data.firstIndex(of: string)
    }

    
    
    // MARK: - UIPickerViewDataSource and UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        guard let player = itemAtIndex(row) else {
            fatalError("Trying to acces a too big index in pickerview datasource")
        }
        let numberColor = UIColor.white
        let shapeColor = UIColor(named: ColorName.DarkBlue)!
        return PlayerPickerView(player: player, numberColor: numberColor, shapeColor: shapeColor)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 100
    }
    
}
