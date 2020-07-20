//
//  PremiumFeature.swift
//  HockeyTimer
//
//  Created by Steven Adons on 19/07/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

enum PremiumFeatureType {
    
    case DarkMode
    case PenaltyCards
    case AppIcon
    case GameReports
}

struct PremiumFeature: FeatureViewable {
    
    var type: PremiumFeatureType
    var firstFeature: Bool
    
    var image: UIImage {
        switch type {
        case .DarkMode:
            return UIImage(named: "FeatureDarkMode")!
        case .PenaltyCards:
            return UIImage(named: "FeaturePenaltyCards")!
        case .AppIcon:
            return UIImage(named: "FeatureAppIcons")!
        case .GameReports:
            return UIImage(named: "FeatureGameReports")!
        }
    }
    var bodyText: String {
        var string: String = ""
        switch type {
        case .DarkMode:
            string += LS_UPGRADE_DARK_MODE
        case .PenaltyCards:
            string +=  LS_UPGRADE_PENALTY_CARDS
        case .AppIcon:
            string +=  LS_UPGRADE_APP_ICON
        case .GameReports:
            string +=  LS_UPGRADE_GAME_REPORTS
        }
        if firstFeature {
            string += " " + LS_UPGRADE_ONE_TIME_PAYMENT
        }
        return string
    }
}
