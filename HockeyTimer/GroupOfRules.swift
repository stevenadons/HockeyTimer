//
//  GroupOfRules.swift
//  HockeyTimer
//
//  Created by Steven Adons on 04/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import Foundation


struct GroupOfRules {
    
    
    // MARK: - Properties
    
    private (set) var rulesArray: [Rules]!
    
    
    // MARK: - Init
    
    init(rulesArray: [Rules]) {
        
        self.rulesArray = rulesArray
    }


}
