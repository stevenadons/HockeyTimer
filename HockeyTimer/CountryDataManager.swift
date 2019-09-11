//
//  CountryDataManager.swift
//  HockeyRulesRemoteData
//
//  Created by Steven Adons on 07/09/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import Foundation

class CountryDataManager {
    
    
    // MARK: - Properties

    private static let _shared = CountryDataManager()
    static var shared: CountryDataManager {
        return _shared
    }
    
    private (set) var countries: [Country]!
    private (set) var status: DataStatus = .Blank
    
    private let urlScheme = "https"
    private let urlHost = "raw.githubusercontent.com"
    private let urlPath = "/stevenadons/RemoteJSON/master"
    
    
    // MARK: - Local Types
    
    enum DataStatus {
        
        case Blank
        case Initialized
        case UpdatedLocally
        case CheckedRemotely(date: Date)
        case UpdatedRemotely(date: Date)
    }
    
    
    // MARK: - Public Methods
    
    func statusString() -> String {
        
        var result: String
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        switch status {
        case .Blank:
            result = "Links not initialized"
        case .Initialized:
            result = "Links initialized from code"
        case .UpdatedLocally:
            result = "Links from device"
        case .CheckedRemotely(let date):
            let dateString = formatter.string(from: date)
            result = "Links remotely checked " + dateString
        case .UpdatedRemotely(let date):
            let dateString = formatter.string(from: date)
            result = "Links updated " + dateString
        }
        
        return result
    }
    
    func updateLocally() {
        
        if countries == nil {
            countries = initialCountriesFromCodeBase()
            status = .Initialized
        }
        let locallyStoredCountries = Country.loadAll(sorted: false)
        
        // Iterate over countries in memory
        for index in 0..<countries.count {
            
            // Iterate over locally stored countries
            for storedCountry in locallyStoredCountries {
                
                // Match
                if storedCountry == countries[index] {
                    countries.remove(at: index)
                    countries.insert(storedCountry, at: index)
                    status = .UpdatedLocally
                }
            }
        }
    }
    
    
    func updateRemote(then handler: (([Country]) -> Void)?) {
        
        if countries == nil {
            countries = initialCountriesFromCodeBase()
            status = .Initialized
        }
        let countriesToUpdate = countries
        
        DataService.instance.getJSON(urlComponentsScheme: urlScheme, urlComponentsHost: urlHost, urlComponentsPath: urlPath + "/data") { (result) in
            
            switch result {
                
            case .success(let jsonObject):
                
                self.status = .CheckedRemotely(date: Date())
                
                if let storedCountries = jsonObject["data"] as? [AnyObject] {
                    var resultCountries: [Country] = countriesToUpdate!
                    
                    // Iterate over stored countries
                    for country in storedCountries {
                        
                        var resultGroupsOfRules: [GroupOfRules] = []
                        var resultArrayOfRules: [Rules] = []
                        if let country = country as? [String: AnyObject] {
                            
                            if let capitals = country["countryCapitals"] as? String, let groupsOfRules = country["groups"] as? [AnyObject] {
                                
                                // Iterate over groups of rules in stored country
                                for groupOfRules in groupsOfRules {
                                    
                                    if let groupOfRules = groupOfRules as? [String: AnyObject], let setsOfRules = groupOfRules["rules"] as? [AnyObject] {
                                        
                                        // Iterate over rules within groupOfRules
                                        for set in setsOfRules {
                                            
                                            if let set = set as? [String: AnyObject] {
                                                var name: String? = nil
                                                var urlString: String? = nil
                                                var specificLocaleUrls: [String: String]?
                                                if let storedName = set["name"] as? String {
                                                    name = storedName
                                                }
                                                if let storedURLString = set["url"] as? String {
                                                    urlString = storedURLString
                                                }
                                                if let storedSpecificLocaleURLS = set["specificLocaleURLs"] as? [String: String] {
                                                    specificLocaleUrls = storedSpecificLocaleURLS
                                                }
                                                if name != nil && urlString != nil {
                                                    // Make new Rules and add to result array
                                                    let rules = Rules(name: name!, url: urlString!, specificLocaleUrls: specificLocaleUrls)
                                                    resultArrayOfRules.append(rules)
                                                }
                                            }
                                        }
                                    }
                                    // Make new GroupOfRules and add to result array for this array of GroupOfRules
                                    if !resultArrayOfRules.isEmpty {
                                        let groupOfRules = GroupOfRules(rulesArray: resultArrayOfRules)
                                        resultGroupsOfRules.append(groupOfRules)
                                    }
                                    resultArrayOfRules = []
                                }
                                
                                // Make new country with updated groupsOfRules and add to result
                                if !resultGroupsOfRules.isEmpty {
                                    for index in 0..<countriesToUpdate!.count {
                                        if countriesToUpdate![index].capitals == capitals {
                                            let currentCountry = countriesToUpdate![index]
                                            let updatedCountry = Country(capitals: capitals, localeRegionCode: currentCountry.localeRegionCode, name: currentCountry.name, durations: currentCountry.durations, durationStrings: currentCountry.durationStrings, groupsOfRules: resultGroupsOfRules)
                                            resultCountries.remove(at: index)
                                            resultCountries.insert(updatedCountry, at: index)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Update persistence
                    Country.deleteAllFromStorage()
                    resultCountries.forEach {
                        $0.saveItem()
                    }
                    self.countries = resultCountries
                    self.status = .UpdatedRemotely(date: Date())
                    handler?(resultCountries)
                }
                
            case .failure(let error):
                print("error \(error)")
                handler?(countriesToUpdate!)
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func initialCountriesFromCodeBase() -> [Country] {
        
        let australia = Country(capitals: "AUS",
                                localeRegionCode: "AU",
                                name: "Australia",
                                durations: [.Twenty, .ThirtyFive],
                                durationStrings: ["Indoor", "Outdoor"],
                                groupsOfRules: [])
        let belgium = Country(capitals: "B",
                              localeRegionCode: "BE",
                              name: "Belgium",
                              durations: [.Twenty, .TwentyFive, .Thirty, .ThirtyFive],
                              durationStrings: ["U7 - U8", "U9 - U10 - U11 - U12", "U14 - Ladies - Gents", "U16 - U19"],
                              groupsOfRules: [])
        let germany = Country(capitals: "D",
                              localeRegionCode: "DE",
                              name: "Germany",
                              durations: [.Ten, .Fifteen, .Twenty, .TwentyFive, .Thirty, .ThirtyFive],
                              durationStrings: [LS_COUNTRY_YOUTH, LS_COUNTRY_YOUTH, LS_COUNTRY_INDOOR, LS_COUNTRY_YOUTH, LS_COUNTRY_GENERAL, LS_COUNTRY_INTERNATIONAL],
                              groupsOfRules: [])
        let spain = Country(capitals: "E",
                            localeRegionCode: "ES",
                            name: "Spain",
                            durations: [.Twenty, .TwentyFive, .Thirty],
                            durationStrings: [LS_COUNTRY_INDOOR, LS_COUNTRY_MASTERS_MAMIS_PAPIS, LS_COUNTRY_OUTDOOR],
                            groupsOfRules: [])
        let england = Country(capitals: "ENG",
                              localeRegionCode: "GB",
                              name: "England",
                              durations: [.Nine, .Twelve, .Fifteen, .Twenty, .Thirty, .ThirtyFive],
                              durationStrings: [LS_COUNTRY_IN2HOCKEY, LS_COUNTRY_IN2HOCKEY, LS_COUNTRY_IN2HOCKEY, LS_COUNTRY_INDOOR, LS_COUNTRY_OUTDOOR, LS_COUNTRY_OUTDOOR],
                              groupsOfRules: [])
        let netherlands = Country(capitals: "NL",
                                  localeRegionCode: "NL",
                                  name: "Netherlands",
                                  durations: [.Fifteen, .Twenty, .TwentyFive, .Thirty, .ThirtyFive],
                                  durationStrings: [LS_COUNTRY_TEAMS_OF_3, LS_COUNTRY_INDOOR_AND_H, LS_COUNTRY_TEAMS_OF_6, LS_COUNTRY_TEAMS_OF_8, LS_COUNTRY_GENERAL],
                                  groupsOfRules: [])
        
        return [australia, belgium, germany, spain, england, netherlands]
    }
    
}
