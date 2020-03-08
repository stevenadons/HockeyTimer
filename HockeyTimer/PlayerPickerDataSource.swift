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
    
    private var data: [Int]!
    
    
    
    // MARK: - Init
    
    init(data: [Int]) {
        
        super.init()
        self.data = data
    }
    
    
    // MARK: - Public Methods
    
    func numberAtIndex(_ index: Int) -> Int? {
       
        guard index < data.count else {
            return nil
        }
        return data[index]
    }
    
    func indexForNumber(_ number: Int) -> Int? {
        
        return data.firstIndex(of: number)
    }

    
    
    // MARK: - UIPickerViewDataSource and UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        guard let number = numberAtIndex(row) else {
            fatalError("Trying to acces a too big index in pickerview datasource")
        }
        let numberColor = UIColor.white
        let shapeColor = UIColor(named: ColorName.DarkBlue)!
        return PlayerPickerView(number: number, numberColor: numberColor, shapeColor: shapeColor)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 100
    }
    
}
