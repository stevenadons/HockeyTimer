//
//  Country.swift
//  HockeyTimer
//
//  Created by Steven Adons on 02/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import Foundation

enum Country: String, CaseIterable {
    
    
    // MARK: - Cases
    
    case Belgium
    case Netherlands
    case France
    
    
    // MARK: - Public Methods
    
    func capitals() -> String {
        
        switch self {
        case .Belgium:
            return "B"
        case .Netherlands:
            return "NL"
        case .France:
            return "FR"
        }
    }
    
    func durations() -> [Duration] {
        
        switch self {
        case .Belgium:
            return [.Twenty,
                    .TwentyFive,
                    .Thirty,
                    .ThirtyFive]
        case .Netherlands:
            return [.Fifteen,
                    .TwentyFive,
                    .Thirty,
                    .ThirtyFive]
        case .France:
            return [.Twenty,
                    .TwentyFive,
                    .Thirty,
                    .ThirtyFive]
        }
    }
    
    func stringForDuration(_ duration: Duration) -> String {
        
        var strings: [String]
        switch self {
        case .Belgium:
            strings = ["U7 - U8",
                       "U9 - U10 - U11 - U12",
                       "U14 - Ladies - Gents",
                       "U16 - U19"]
            
        case .Netherlands:
            strings = ["Teams of 3",
                       "Teams of 6",
                       "Teams of 8",
                       "General"]
            
        case .France:
            strings = ["U7 - U8",
                       "U9 - U10 - U11 - U12",
                       "U14 - Ladies - Gents",
                       "U16 - U19"]
        }
        
        if let index = durations().firstIndex(of: duration), index < strings.count {
            return strings[index]
        } else {
            return ""
        }
    }
    
    
    // MARK: - Static Methods
    
    static func defaultValue() -> Country {
        
        return Country.Belgium
    }
   
    static func allCountryNames() -> [String] {
        
        var countryNames: [String] = []
        for country in Country.allCases {
            countryNames.append(country.rawValue)
        }
        return countryNames
    }
    
    static func allCapitals() -> [String] {
        
        var capitalsStrings: [String] = []
        for country in Country.allCases {
            capitalsStrings.append(country.capitals())
        }
        return capitalsStrings
    }
    
    static func indexOf(_ country: Country) -> Int? {
        
        for index in 0..<Country.allCountryNames().count {
            if Country.allCases[index].rawValue == country.rawValue {
                return index
            }
        }
        return nil
    }
}
