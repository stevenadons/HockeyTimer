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
    
    let internationalRules = Rules(name: DOC_FIHRULES, url: "https://www.hockey.be/app/uploads/2019/04/fih-rules-of-hockey-2019-final-5.pdf", specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2019/04/fih-rules-of-hockey-2019-final.pdf"])
    let internationalGroup = GroupOfRules(rulesArray: [internationalRules])
    
    let rulesU7U12 = Rules(name: DOC_VHLRULESU7U12, url: "https://www.hockey.be/app/uploads/2018/05/Table_Parents-Umpires_-_NL_-_less_U14_-_v1.5.pdf", specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2018/05/Règles-de-jeu-Jeunes-U7-U12-1.pdf"])
    let rulesU14U19 = Rules(name: DOC_VHLRULESU14U19, url: "https://www.hockey.be/app/uploads/2018/05/Table_Parents-Umpires_-_NL_-_above_U14_-_V1.2.pdf", specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2018/06/Règles-de-jeu-Jeunes-U14-U19.pdf"])
    let rulesYouth = GroupOfRules(rulesArray: [rulesU7U12, rulesU14U19])

    let indoorU7U10 = Rules(name: DOC_INDOOR_U7_U10, url: "https://www.hockey.be/app/uploads/2018/06/2017-007-KBHB-Pictos_NL_HR.pdf")
    let indoorU9U19 = Rules(name: DOC_INDOOR_U9_U19, url: "https://www.hockey.be/app/uploads/2019/01/Indoor-Hockey-Spelregels-U9-U19-2019.pdf")
    let indoorFIH = Rules(name: DOC_INDOOR_FIH, url: "https://www.hockey.be/app/uploads/2018/06/rules-of-indoor-hockey-2017-1.pdf")
    let indoorGroupBelgium = GroupOfRules(rulesArray: [indoorU7U10, indoorU9U19, indoorFIH])

    let ladiesRules = Rules(name: DOC_LADIES, url: "https://www.hockey.be/app/uploads/2018/06/Ladies_rules_NL_2017-2018.pdf", specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2018/06/Ladies_rules_FR_2017-2018.pdf"])
    let gentsRules = Rules(name: DOC_GENTS, url: "https://www.hockey.be/app/uploads/2018/06/Gents_rules_NL_2017-2018-1.pdf", specificLocaleUrls: ["fr": "https://www.hockey.be/app/uploads/2018/06/Gents_rules_FR_2017-2018.pdf"])
    let gentsLadies = GroupOfRules(rulesArray: [ladiesRules, gentsRules])
    
    let moreOutdoorB = Rules(name: DOC_MORE_OUTDOOR, url: "https://www.hockey.be/nl/categorie/competitie/outdoor-hockey/")
    let moreIndoorB = Rules(name: DOC_MORE_INDOOR, url: "https://www.hockey.be/nl/categorie/competitie/indoor-hockey/")
    let moreBGroup = GroupOfRules(rulesArray: [moreOutdoorB, moreIndoorB])

    let belgium = Country(capitals: "B",
                          name: LS_COUNTRY_BELGIUM,
                          durations: [.Twenty, .TwentyFive, .Thirty, .ThirtyFive],
                          durationStrings: ["U7 - U8",
                                            "U9 - U10 - U11 - U12",
                                            "U14 - Ladies - Gents",
                                            "U16 - U19"],
                          groupsOfRules: [internationalGroup, rulesYouth, indoorGroupBelgium, gentsLadies, moreBGroup])
    
    
    let rules = Rules(name: DOC_NL_SPELREGLEMENT, url: "https://www.knhb.nl/app/uploads/2018/08/Spelreglement-Veldhockey-per-1-augustus-2018-1.pdf")
    let basicNL = GroupOfRules(rulesArray: [rules])
    
    let teamsOf3 = Rules(name: DOC_NL_3TALLEN, url: "https://www.knhb.nl/kenniscentrum/artikel/spelregels-3-tallen")
    let teamsOf6 = Rules(name: DOC_NL_6TALLEN, url: "https://www.knhb.nl/kenniscentrum/artikel/spelregels-6-tallen")
    let teamsOf8 = Rules(name: DOC_NL_8TALLEN, url: "https://www.knhb.nl/kenniscentrum/artikel/spelregels-8-tallen")
    let nlYouth = GroupOfRules(rulesArray: [teamsOf3, teamsOf6, teamsOf8])
    
    let indoorHolland = Rules(name: DOC_NL_INDOOR, url: "https://www.knhb.nl/app/uploads/2017/01/Spelreglement-Zaalhockey-2016-2017.pdf")
    let indoorGroupHolland = GroupOfRules(rulesArray: [indoorHolland])
    
    let moreNL = Rules(name: DOC_NL_WEBPAGE, url: "https://www.knhb.nl/kenniscentrum/scheidsrechters/alles-over-de-spelregels")
    let moreNLGroup = GroupOfRules(rulesArray: [moreNL])
    
    let netherlands = Country(capitals: "NL",
                              name: LS_COUNTRY_NETHERLANDS,
                              durations: [.Fifteen, 
                                          .TwentyFive,
                                          .Thirty,
                                          .ThirtyFive],
                              durationStrings: [LS_COUNTRY_TEAMS_OF_3,
                                                LS_COUNTRY_TEAMS_OF_6,
                                                LS_COUNTRY_TEAMS_OF_8,
                                                LS_COUNTRY_GENERAL],
                              groupsOfRules: [basicNL, nlYouth, indoorGroupHolland, moreNLGroup])
    
    return [belgium, netherlands]
    
}
