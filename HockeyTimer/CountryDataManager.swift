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
        case UpdatedWithSourceData
        case UpdateWithLocallyStoredData
        case CheckedRemotely(date: Date)
        case UpdatedWithRemoteData(date: Date)
    }
    
    
    // MARK: - Public Methods
    
    func getData() {
        
        initializeCountries()
        updateWithSourceData()
        updateWithLocallyStoredData()
        updateWithRemoteData()
    }
    
    
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
        case .UpdatedWithSourceData:
            result = "Links updated with local json"
        case .UpdateWithLocallyStoredData:
            result = "Links from device"
        case .CheckedRemotely(let date):
            let dateString = formatter.string(from: date)
            result = "Links remotely checked " + dateString
        case .UpdatedWithRemoteData(let date):
            let dateString = formatter.string(from: date)
            result = "Links updated " + dateString
        }
        
        return result
    }
    
    
    // MARK: - Private Methods
    
    private func initializeCountries() {

        let australia = Country(capitals: "AUS",
                                localeRegionCode: "AU",
                                name: "Australia",
                                periods: [4, 4],
                                minutes: [40, 70],
                                minutesStrings: ["Indoor", "Outdoor"],
                                groupsOfRules: [])
        let belgium = Country(capitals: "B",
                              localeRegionCode: "BE",
                              name: "Belgium",
                              periods: [2, 2, 2, 4],
                              minutes: [40, 50, 60, 70],
                              minutesStrings: ["U7 - U8", "U9 - U10 - U11 - U12", "U14 - Ladies - Gents", "U16 - U19"],
                              groupsOfRules: [])
        let germany = Country(capitals: "D",
                              localeRegionCode: "DE",
                              name: "Germany",
                              periods: [4, 2, 2, 4],
                              minutes: [40, 50, 60, 70],
                              minutesStrings: [LS_COUNTRY_INDOOR, LS_COUNTRY_YOUTH, LS_COUNTRY_GENERAL, LS_COUNTRY_INTERNATIONAL],
                              groupsOfRules: [])
        let spain = Country(capitals: "E",
                            localeRegionCode: "ES",
                            name: "Spain",
                            periods: [4, 2, 2, 4],
                            minutes: [40, 50, 60, 70],
                            minutesStrings: [LS_COUNTRY_INDOOR, LS_COUNTRY_MASTERS_MAMIS_PAPIS, LS_COUNTRY_OUTDOOR, LS_COUNTRY_OUTDOOR],
                            groupsOfRules: [])
        let england = Country(capitals: "ENG",
                              localeRegionCode: "GB",
                              name: "England",
                              periods: [2, 4, 2, 4],
                              minutes: [30, 40, 60, 70],
                              minutesStrings: [LS_COUNTRY_IN2HOCKEY, LS_COUNTRY_INDOOR, LS_COUNTRY_OUTDOOR, LS_COUNTRY_OUTDOOR],
                              groupsOfRules: [])
        let netherlands = Country(capitals: "NL",
                                  localeRegionCode: "NL",
                                  name: "Netherlands",
                                  periods: [2, 2, 2, 4],
                                  minutes: [30, 50, 60, 70],
                                  minutesStrings: [LS_COUNTRY_TEAMS_OF_3, LS_COUNTRY_TEAMS_OF_6, LS_COUNTRY_TEAMS_OF_8, LS_COUNTRY_GENERAL],
                                  groupsOfRules: [])

        countries = [australia, belgium, germany, spain, england, netherlands]
        status = .Initialized
    }
    
    
    private func updateWithSourceData() {
        
        if countries.isEmpty {
            initializeCountries()
        }
        
        guard let jsonURL = Bundle.main.url(forResource: "HockeyUppLinks", withExtension: "json") else {
            return
        }
        
        var data = Data()
        do {
            data = try Data(contentsOf: jsonURL)
            let jsonFile = try JSONSerialization.jsonObject(with: data, options: [])
            if let jsonObject = jsonFile as? [String: AnyObject] {
                handleJSON(jsonObject) { (countriesFromLocalJSON) in
                    self.countries = countriesFromLocalJSON
                }
                status = .UpdatedWithSourceData
            }
        } catch {
            print("error reading json from HockeyUppLinks.json")
        }
    }
    
    
    private func updateWithLocallyStoredData() {
        
        if countries.isEmpty {
            initializeCountries()
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
                    status = .UpdateWithLocallyStoredData
                }
            }
        }
    }
    
    
    private func updateWithRemoteData(then handler: (([Country]) -> Void)? = nil) {
        
        if countries.isEmpty {
            initializeCountries()
        }
        
        let countriesToUpdate = countries
        
        DataService.instance.getJSON(urlComponentsScheme: urlScheme, urlComponentsHost: urlHost, urlComponentsPath: urlPath + "/hockeyUppRules") { (result) in
            
            switch result {
                
            case .success(let jsonObject):
                
                self.status = .CheckedRemotely(date: Date())
                self.handleJSON(jsonObject) { (countriesFromRemoteJSON) in
                    
                    self.status = .UpdatedWithRemoteData(date: Date())
                    self.countries = countriesFromRemoteJSON
                    
                    // Update persistence
                    Country.deleteAllFromStorage()
                    self.countries.forEach {
                        $0.saveItem()
                    }
                    
                    handler?(countriesFromRemoteJSON)
                }
                
            case .failure( _):

                handler?(countriesToUpdate!)
            }
        }
    }
    
    
    private func handleJSON(_ jsonObject: [String: AnyObject], then handler: (([Country]) -> Void)?) {
        
        let countriesToUpdate = countries
        
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
                                        if let storedNames = set["names"] as? [String: String] {
                                            
                                            // Look up rules, language (in preference): app language, system language, english, first value, "Rules"
                                            if let appLanguage = Bundle.main.preferredLocalizations.first, let appPreferredName = storedNames[appLanguage] {
                                                name = appPreferredName
                                            } else if let language = Locale.current.languageCode, let preferredName = storedNames[language] {
                                                name = preferredName
                                            } else if let englishName = storedNames["en"] {
                                                name = englishName
                                            } else if !(storedNames.isEmpty), let firstName = storedNames.first?.value {
                                                name = firstName
                                            } else {
                                                name = "Rules"
                                            }
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
                            for index in 0 ..< countriesToUpdate!.count {
                                if countriesToUpdate![index].capitals == capitals {
                                    let currentCountry = countriesToUpdate![index]
                                    let updatedCountry = Country(capitals: capitals, localeRegionCode: currentCountry.localeRegionCode, name: currentCountry.name, periods: currentCountry.periods, minutes: currentCountry.minutes, minutesStrings: currentCountry.minutesStrings, groupsOfRules: resultGroupsOfRules)
                                    resultCountries.remove(at: index)
                                    resultCountries.insert(updatedCountry, at: index)
                                }
                            }
                        }
                    }
                }
            }
            
            // Handler
            handler?(resultCountries)
        }
        
    }
    
    private func checkOutdoorRulesURLForAustralia() {
        
        for country in countries {
            if country.capitals == "AUS" {
                if let gor = country.groupsOfRules {
                    for group in gor {
                        for rules in group.rulesArray {
                            if rules.name == "Outdoor Rules" {
                                if let url = rules.url {
                                    print("Checking AUS - Outdoor Rules: \(url)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    
}
