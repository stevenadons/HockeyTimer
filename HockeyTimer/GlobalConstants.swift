//
//  GlobalConstants.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 14/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


enum HALF {
    
    case First
    case Second
}


enum MINUTESINHALF: Int {
    
    case Fifteen = 15
    case Twenty = 20
    case TwentyFive = 25
    case Thirty = 30
    case ThirtyFive = 35
}


enum COLOR {
    
    // Standard colors
    static let Theme = UIColor.init(hexString: "#394560") // Dark Blue 1E2460         // Colours on Navigation Bar, Button Titles, Progress Indicator //
    static let DarkBackground = UIColor.init(hexString: "#989CB5") // Dark Grey // Dark background colour to group UI components with light colour. "#999966"
    static let LightBackground = UIColor.init(hexString: "#EAEBF0") // Light Grey // Light background colour to group UI components with dark colour.
    static let Affirmation = UIColor.init(hexString: "#F7BD52") // F4AB23 // Colour to show success, something right for user. "#00ff66""
    static let Negation = UIColor.init(hexString: "#F0505A") // 980822             // Colour to show error, some danger zones for user. ff3300
    
    // Custom colors
    
    static let PitchBlue = UIColor(hexString: "#3D8FE5") // 4784C9
    static let PitchEdge = UIColor(hexString: "#8DBFF7")
    static let Striping = UIColor(hexString: "#FFFFFF") //6F7498
    static let BallShining = UIColor(hexString: "#FFFEE5")
    static let BallBody = UIColor(hexString: "#FFFA41")
    
    static let Blue = UIColor(hexString: "#3D8FE5") 
    static let BlueLight = UIColor(hexString: "#8FC0F2")
    static let BlueDark = UIColor(hexString: "#0862BF")
    static let Green = UIColor(hexString: "#60D44B")
    static let GreenLight = UIColor(hexString: "#A9EF9E")
    static let GreenDark = UIColor(hexString: "#25A111")
    static let Orange = UIColor(hexString: "#F7BD52")
    static let OrangeLight = UIColor(hexString: "#FFDEA2")
    static let OrangeDark = UIColor(hexString: "#B57C12")
    static let Red = UIColor(hexString: "#F0505A")
    static let RedLight = UIColor(hexString: "#FCA1A8")
    static let RedDark = UIColor(hexString: "#B0121E")
    
    static let DarkRed = UIColor(hexString: "#6E070C")
    static let DarkOrange = UIColor(hexString: "#A3402F")
    static let DarkBlue = UIColor(hexString: "#31728E") // 0A1329
    static let DarkGray = UIColor(hexString: "#40434E")
    static let VeryDarkBlue = UIColor(hexString: "#0A1329")
    static let LightRed = UIColor(hexString: "#A6090E")
    static let LightOrange = UIColor(hexString: "#CD9958")
    static let LightYellow = UIColor(hexString: "#F9B82C")
    static let LightBlue = UIColor(hexString: "#9AD2CB") // 8FC0F2
    static let White = UIColor(hexString: "#FBFAF8")

}


enum FONTNAME {
    
    static let ThemeBold = "HelveticaNeue-Bold"
    static let ThemeRegular = "HelveticaNeue"
}


enum USERDEFAULTSKEY {
    
    static let Duration = "Duration"
    static let OldDuration = "OldDuration"
    static let StartViewController = "StartViewController"
}

let admobHeight: CGFloat = 65



// Localized strings

let LS_NEWGAME = NSLocalizedString("New Game", comment: "Overdue message")
let LS_GAMEPAUSED = NSLocalizedString("Game Paused", comment: "Message when game is pausing")
let LS_OVERTIME = NSLocalizedString("In Overtime", comment: "Time over message")
let LS_HALFTIME = NSLocalizedString("Half Time", comment: "Half time message")
let LS_READYFORH2 = NSLocalizedString("Ready for H2", comment: "H2 to begin message")
let LS_FULLTIME = NSLocalizedString("Full Time", comment: "Full time message")
let LS_FIRSTHALFLABEL = NSLocalizedString("H1", comment: "Half time indication label")
let LS_SECONDHALFLABEL = NSLocalizedString("H2", comment: "Half time indication label")
let LS_WARNINGRESETGAME = NSLocalizedString("RESET GAME", comment: "When reset button tapped")
let LS_WARNINGNEWGAME = NSLocalizedString("NEW GAME", comment: "When stopwatch is tapped for new game")

let LS_BUTTON_BACK = NSLocalizedString("BACK", comment: "Message on button to back out from document")
let LS_BUTTON_UNDOGOAL = NSLocalizedString("UNDO GOAL", comment: "Message for undoing goal")
let LS_BUTTON_ONBOARDDISMISS = NSLocalizedString("OK got it", comment: "Button for ending onboarding")

let LS_TITLE_GAMETIME = NSLocalizedString("Game Time", comment: "title for navigating")
let LS_TITLE_DOCUMENTS = NSLocalizedString("Rules", comment: "Title for navigating")
let LS_TITLE_SCORE = NSLocalizedString("Score", comment: "Title for navigating")
let LS_TITLE_STOPWATCH = NSLocalizedString("Stopwatch", comment: "Title for navigating")
let LS_TITLE_ONBOARDINGSLIDE1 = NSLocalizedString("Really easy to use", comment: "Onboarding screen")
let LS_TITLE_ONBOARDINGSLIDE2 = NSLocalizedString("Keep track of the score", comment: "Onboarding screen")
let LS_BODY_ONBOARDINGSLIDE1 = NSLocalizedString("Just tap stopwatch to play or pause", comment: "Onboarding screen")
let LS_BODY_ONBOARDINGSLIDE2 = NSLocalizedString("Drag the ball left or right", comment: "Onboarding screen")

let LS_DOCUMENTNAME_PICTOGRAMU7U8 = NSLocalizedString("VHL PICTOGRAM U7-U8", comment: "Name for document")
let LS_DOCUMENTNAME_PICTOGRAMU9 = NSLocalizedString("VHL PICTOGRAM U9", comment: "Name for document")
let LS_DOCUMENTNAME_PICTOGRAMU10U12 = NSLocalizedString("VHL PICTOGRAM U10-U12", comment: "Name for document")
let LS_DOCUMENTNAME_VHLSHOOTOUTS = NSLocalizedString("VHL SHOOT-OUTS U10", comment: "Name for document")
let LS_DOCUMENTNAME_VHLRULESU7U12 = NSLocalizedString("VHL RULES U7-U12", comment: "Name for document")
let LS_DOCUMENTNAME_VHLRULESU14U19 = NSLocalizedString("VHL RULES U14-U19", comment: "Name for document")
let LS_DOCUMENTNAME_KBHBRULES = NSLocalizedString("KBHB RULES", comment: "Name for document")






