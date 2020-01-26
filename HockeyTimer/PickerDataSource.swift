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
        
        var numberColor: UIColor
        var shapeColor: UIColor
        var inDecimalMode: Bool = false
        
        switch pickerView.tag {
        case 0:
            numberColor = .white
            shapeColor = UIColor(named: ColorName.DarkBlue)!
        case 1:
            numberColor = .white
            shapeColor = UIColor(named: ColorName.PantoneRed)!
            let decimalPickerView = pickerView as! DecimalPickerView
            inDecimalMode = decimalPickerView.inDecimalMode
        default:
            fatalError("Did try to get data for pickerview exceeding max tag")
        }
        
        return PickerNumberView(number: number, addHalf: inDecimalMode, numberColor: numberColor, shapeColor: shapeColor, isSmall: false, isVeryBig: false)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 90
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("select")
        
        let pickerView = pickerView as! DecimalPickerView
        
        var userInfo: [String : Any] = [:]

        if pickerView.tag == 0, let selectedPeriods = pickerView.selectedPeriods {
            userInfo[GameTimePickersUserInfoKey.Periods] = selectedPeriods
            
        } else if pickerView.tag == 1, let selectedMinutes = pickerView.selectedMinutes {
            userInfo[GameTimePickersUserInfoKey.Minutes] = selectedMinutes
            userInfo[GameTimePickersUserInfoKey.AddHalf] = pickerView.inDecimalMode
        }
        
        NotificationCenter.default.post(name: .CustomTimeSelectionOccurred, object: nil, userInfo: userInfo)

    }
    
}
