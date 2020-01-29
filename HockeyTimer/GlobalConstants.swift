//
//  GlobalConstants.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 14/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit
import StoreKit


var SELECTED_COUNTRY: Country {
    set {
        let index = CountryDataManager.shared.countries.firstIndex(of: newValue) ?? 0
        UserDefaults.standard.set(index, forKey: UserDefaultsKey.CountryIndex)
    }
    get {
        if let index = UserDefaults.standard.value(forKey: UserDefaultsKey.CountryIndex) as? Int, index < CountryDataManager.shared.countries.count {
            return CountryDataManager.shared.countries[index]
        } else {
            let localeCountries = CountryDataManager.shared.countries.filter { $0.localeRegionCode == Locale.current.regionCode }
            if !localeCountries.isEmpty {
                return localeCountries[0]
            }
            return CountryDataManager.shared.countries[0]
        }
    }
}

var timerIsRunning: Bool = false
var runningSecondsToGo: Int = 0 
var runningSecondsOverdue: Int = 0
var runningSecondsCountingUp: Int = 0
var runningCountingUp: Bool = false
var runningMinutes: Double = HockeyGame.standardTotalMinutes
var allCardsSecondsToGo: [Int] = []

var shouldRestoreFromBackground: Bool = false
var appStoreProducts: [SKProduct] = []
var shadowed: Bool = false


