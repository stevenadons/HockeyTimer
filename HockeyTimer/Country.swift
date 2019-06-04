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
    private (set) var groupsOfRules: [GroupOfRules]!
    
    
    // MARK: - Init
    
    init(capitals: String, name: String, durations: [Duration], durationStrings: [String], groupsOfRules: [GroupOfRules]) {
        
        self.capitals = capitals
        self.name = name
        self.durations = durations
        self.durationStrings = durationStrings
        self.groupsOfRules = groupsOfRules
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
    
    let pictogramU7U8 = Rules(name: LS_DOCUMENTNAME_PICTOGRAMU7U8,
                              url: "https://www.hockey.be/app/uploads/2018/05/Pictogram_spelregels_U7-U8-1.pdf",
                              specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2018/05/Pictos-Règles-du-jeu-U7-U8.pdf"])
    let pictogramU9 = Rules(name: LS_DOCUMENTNAME_PICTOGRAMU9,
                            url: "https://www.hockey.be/app/uploads/2018/05/Pictogram_spelregels_U9-1.pdf",
                            specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2018/05/Pictos-Règles-du-Jeu-U9-1.pdf"])
    let pictogramU10U12 = Rules(name: LS_DOCUMENTNAME_PICTOGRAMU10U12,
                                url: "https://www.hockey.be/app/uploads/2018/05/Pictogram_spelregels_U10-U12-1.pdf",
                                specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2018/06/Pictos-Règles-du-Jeu-U10-U12-1.pdf"])
    let vhlOverviewYouth = Rules(name: LS_DOCUMENTNAME_VHLSHOOTOUTS,
                                 url: "https://www.hockey.be/app/uploads/2018/06/spelregels_jeugd_NL01092014.pdf")
    let rulesU7U12 = Rules(name: LS_DOCUMENTNAME_VHLRULESU7U12,
                           url: "https://www.hockey.be/app/uploads/2018/05/Table_Parents-Umpires_-_NL_-_less_U14_-_v1.5.pdf",
                           specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2018/05/Règles-de-jeu-Jeunes-U7-U12-1.pdf"])
    let rulesU14U19 = Rules(name: LS_DOCUMENTNAME_VHLRULESU14U19,
                            url: "https://www.hockey.be/app/uploads/2018/05/Table_Parents-Umpires_-_NL_-_above_U14_-_V1.2.pdf",
                            specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2018/06/Règles-de-jeu-Jeunes-U14-U19.pdf"])
    let ladiesRules = Rules(name: LS_DOCUMENTNAME_LADIES,
                            url: "https://www.hockey.be/app/uploads/2018/06/Ladies_rules_NL_2017-2018.pdf",
                            specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2018/06/Ladies_rules_FR_2017-2018.pdf"])
    let gentsRules = Rules(name: LS_DOCUMENTNAME_GENTS,
                           url: "https://www.hockey.be/app/uploads/2018/06/Gents_rules_NL_2017-2018-1.pdf",
                           specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2018/06/Gents_rules_FR_2017-2018.pdf"])
    let internationalRules = Rules(name: LS_DOCUMENTNAME_FIHRULES,
                                   url: "https://www.hockey.be/app/uploads/2019/04/fih-rules-of-hockey-2019-final-5.pdf",
                                   specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2019/04/fih-rules-of-hockey-2019-final.pdf"])
    
    let group1 = GroupOfRules(rulesArray: [pictogramU7U8, pictogramU9, pictogramU10U12])
    let group2 = GroupOfRules(rulesArray: [vhlOverviewYouth])
    let group3 = GroupOfRules(rulesArray: [rulesU7U12, rulesU14U19])
    let group4 = GroupOfRules(rulesArray: [ladiesRules, gentsRules])
    let group5 = GroupOfRules(rulesArray: [internationalRules])
    
    let belgium = Country(capitals: "B",
                          name: "Belgium",
                          durations: [.Twenty, .TwentyFive, .Thirty, .ThirtyFive],
                          durationStrings: ["U7 - U8",
                                            "U9 - U10 - U11 - U12",
                                            "U14 - Ladies - Gents",
                                            "U16 - U19"],
                          groupsOfRules: [group1, group2, group3, group4, group5])
    
    let netherlands = Country(capitals: "NL",
                              name: "Netherlands",
                              durations: [.Fifteen,
                                          .TwentyFive,
                                          .Thirty,
                                          .ThirtyFive],
                              durationStrings: ["Teams of 3",
                                                "Teams of 6",
                                                "Teams of 8",
                                                "General"],
                              groupsOfRules: [group1, group2, group3, group4, group5])
    
    return [belgium, netherlands]
    
}
