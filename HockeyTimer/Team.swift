//
//  Player.swift
//  HockeyTimer
//
//  Created by Steven Adons on 08/03/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import Foundation


enum Team {
    
    case Home
    case Away
    
    func teamString() -> String {
        
        if self == Team.Home {
            return LS_HOME_TEAM
        }
        return LS_AWAY_TEAM
    }
}


