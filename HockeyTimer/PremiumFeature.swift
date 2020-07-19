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
            return UIImage(named: "FeatureGraphicsAppIcon")!
        case .PenaltyCards:
            return UIImage(named: "FeatureGraphicsAppIcon")!
        case .AppIcon:
            return UIImage(named: "FeatureGraphicsAppIcon")!
        case .GameReports:
            return UIImage(named: "FeatureGraphicsAppIcon")!
        }
    }
    var bodyText: String {
        switch type {
        case .DarkMode:
            return firstFeature ? "In premium mode you can have dark mode" : "Enable dark mode"
        case .PenaltyCards:
            return firstFeature ? "In premium mode you can have penalty cards" : "Enable penalty cards"
        case .AppIcon:
            return firstFeature ? "In premium mode you can have app icons" : "Enable app icons"
        case .GameReports:
            return firstFeature ? "In premium mode you can have game reports" : "Enable game reports"
        }
    }
}
