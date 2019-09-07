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
    private var id: UUID!
    
    
    // MARK: - Init
    
    init(rulesArray: [Rules]) {
        
        self.rulesArray = rulesArray
        self.id = UUID()
    }
}


extension GroupOfRules: Codable, Hashable {
    
    static func == (lhs: GroupOfRules, rhs: GroupOfRules) -> Bool {
        
        return lhs.id == rhs.id
    }
    
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(id)
    }
}
