//
//  Country.swift
//  HockeyTimer
//
//  Created by Steven Adons on 04/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import Foundation


struct Country {
    
    
    // MARK: - Properties
    
    private (set) var capitals: String!
    private (set) var name: String!
    private (set) var durations: [Duration]!
    private (set) var durationStrings: [String]!
    
    
    // MARK: - Init
    
    init(capitals: String, name: String, durations: [Duration], durationStrings: [String]) {
        
        self.capitals = capitals
        self.name = name
        self.durations = durations
        self.durationStrings = durationStrings
    }
    
    
    // MARK: - Static methods
    
    static func allCapitals() -> [String] {
        
        return countries.map {
            $0.capitals
        }
    }
    
    static func allNames() -> [String] {
        
        return countries.map {
            $0.name
        }
    }
    
    
    // MARK: - Public Methods
    
    func durationStringFor(_ duration: Duration) -> String? {
        
        if let index = durations.firstIndex(of: duration), index < durationStrings.count {
            return durationStrings[index]
        }
        return nil
    }

    

}


// MARK: - Equatable

extension Country: Equatable {
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        
        return lhs.capitals == rhs.capitals
    }
}


var countries: [Country] {
    
    let belgium = Country(capitals: "B",
                          name: "Belgium",
                          durations: [.Twenty,
                                      .TwentyFive,
                                      .Thirty,
                                      .ThirtyFive],
                          durationStrings: ["U7 - U8",
                                            "U9 - U10 - U11 - U12",
                                            "U14 - Ladies - Gents",
                                            "U16 - U19"])
    
    let netherlands = Country(capitals: "NL",
                              name: "Netherlands",
                              durations: [.Fifteen,
                                          .TwentyFive,
                                          .Thirty,
                                          .ThirtyFive],
                              durationStrings: ["Teams of 3",
                                                "Teams of 6",
                                                "Teams of 8",
                                                "General"])
    
    return [belgium, netherlands]
    
}
