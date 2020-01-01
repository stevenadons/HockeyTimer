//
//  RightPickerDataSource.swift
//  HockeyTimer
//
//  Created by Steven Adons on 15/12/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class RightPickerDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    

    // MARK: - Properties
    
    private var data: [Int] = [2, 3, 4]
    
    
    // MARK: - Init
    
    override init() {
        
        super.init()
//        for counter in
    }
    
    
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let int = data[row]
        return String(int)
    }
    

    
}
