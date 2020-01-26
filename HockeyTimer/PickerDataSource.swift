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
        var isSmall: Bool = false
        var isVeryBig: Bool = false
        
        switch pickerView.tag {
        case 0:
            numberColor = .white
            shapeColor = UIColor(named: ColorName.DarkBlue)!
        case 1:
            numberColor = .white
            shapeColor = UIColor(named: ColorName.PantoneRed)!
            isVeryBig = true
        case 2:
            numberColor = .white // UIColor(named: ColorName.VeryDarkBlue)!
            shapeColor = UIColor(named: ColorName.PantoneYellow)!
            isSmall = true
        default:
            fatalError("Did try to get data for pickerview exceeding max tag")
        }
        
        return PickerNumberView(number: number, numberColor: numberColor, shapeColor: shapeColor, isSmall: isSmall, isVeryBig: isVeryBig)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 90
    }
    
}
