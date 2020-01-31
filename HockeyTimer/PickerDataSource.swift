//
//  PickerDataSource.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class PickerDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    

    // MARK: - Properties
    
    private var data: [Double]!
    
    var isHoldingDecimals: Bool {
        if !data.isEmpty, !data[0].isInteger {
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: - Init
    
    init(data: [Double]) {
        
        super.init()
        self.data = data
    }
    
    
    // MARK: - Public Methods
    
    func numberAtIndex(_ index: Int) -> Double? {
       
        guard index < data.count else {
            return nil
        }
        return data[index]
    }
    
    func indexForNumber(_ number: Double) -> Int? {
        
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
        
        let numberColor: UIColor = .white
        var shapeColor: UIColor
        
        switch pickerView.tag {
        case 0:
            shapeColor = UIColor(named: ColorName.DarkBlue)!
        case 1:
            shapeColor = UIColor(named: ColorName.PantoneRed)!
        default:
            fatalError("Did try to get data for pickerview exceeding max tag")
        }
        
        return PickerNumberView(number: number, numberColor: numberColor, shapeColor: shapeColor, isSmall: false, isVeryBig: false)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 90
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var userInfo: [String : Any] = [:]

        if pickerView.tag == 0, let selectedPeriods = numberAtIndex(row) {
            userInfo[GameTimePickersUserInfoKey.Periods] = selectedPeriods
            
        } else if pickerView.tag == 1, let selectedMinutes = numberAtIndex(row) {
            userInfo[GameTimePickersUserInfoKey.Minutes] = selectedMinutes
        }
        
        NotificationCenter.default.post(name: .CustomTimeSelectionOccurred, object: nil, userInfo: userInfo)
    }
    
}
