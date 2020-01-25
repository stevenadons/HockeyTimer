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
    private (set) var localeRegionCode: String!
    private (set) var name: String!
    private (set) var minutes: [Int]!
    private (set) var minutesStrings: [String]!
    private (set) var groupsOfRules: [GroupOfRules]!
    
    
    // MARK: - Init
    
    init(capitals: String, localeRegionCode: String, name: String, minutes: [Int], minutesStrings: [String], groupsOfRules: [GroupOfRules]) {
        
        self.capitals = capitals
        self.localeRegionCode = localeRegionCode
        self.name = name
        self.minutes = minutes
        self.minutesStrings = minutesStrings
        self.groupsOfRules = groupsOfRules
    }
    
    
    // MARK: - Static methods
    
    static func allCapitals() -> [String] {
        
        return CountryDataManager.shared.countries.map {
            $0.capitals
        }
    }
    
    static func allNames() -> [String] {
        
        return CountryDataManager.shared.countries.map {
            $0.name
        }
    }
    
    static func loadAll(sorted: Bool) -> [Country] {
        
        let countries = LocalDataManager.loadAll(Country.self)
        let filteredCountries = countries.filter { $0.name != nil }
        if sorted && filteredCountries.count > 1 {
            let sortedCountries: [Country] = filteredCountries.sorted { $0.name < $1.name }
            return sortedCountries
        }
        return filteredCountries
    }
    
    static func deleteAllFromStorage() {
        
        let countries = LocalDataManager.loadAll(Country.self)
        countries.forEach {
            $0.deleteItem()
        }
    }
    
    
    // MARK: - Public Methods
    
    func saveItem() {
        
        LocalDataManager.save(self, withFileName: name)
    }
    
    func deleteItem() {
        
        LocalDataManager.delete(name)
    }
    
    func minutesStringFor(_ minutes: Int) -> String? {
        
        if let index = self.minutes.firstIndex(of: minutes), index < minutesStrings.count {
            return minutesStrings[index]
        }
        return nil
    }
}


// MARK: - Equatable

extension Country: Equatable {
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        
        return (lhs.capitals == rhs.capitals) && (lhs.minutes == rhs.minutes) && (lhs.minutesStrings == rhs.minutesStrings)
    }
}

// MARK: - Codable, Hashable

extension Country: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(name)
    }
}
