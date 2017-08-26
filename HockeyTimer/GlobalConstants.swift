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


enum NIBNAME {
    
    static let Logo = "Logo"
    static let DismissButton = "DismissButton"
    static let Hamburger = "Hamburger"
}


enum COLOR {
    
    // Standard colors
    static let Theme = UIColor.init(hexString: "#394560") // Dark Blue 1E2460         // Colours on Navigation Bar, Button Titles, Progress Indicator etc. "#ffcc00"
//    static let Border = UIColor.init(hexString: "#333333")                    // Hair line separators in between views.
//    static let Shadow = UIColor.init(hexString: "#ccccc")                     // Shadow colours for card like design.
//    
    static let DarkBackground = UIColor.init(hexString: "#989CB5") // Dark Grey // Dark background colour to group UI components with light colour. "#999966"
    static let LightBackground = UIColor.init(hexString: "#EAEBF0") // Light Grey // Light background colour to group UI components with dark colour.
//    static let IntermediateBackground = UIColor.init(hexString: "#cccc99")    // Used for grouping UI elements with some other colour scheme.
//
//    static let DarkText = UIColor.init(hexString: "#333333")
//    static let LightText = UIColor.init(hexString: "#cccccc")
//    static let IntermediateText = UIColor.init(hexString: "#999999")
//    
    static let Affirmation = UIColor.init(hexString: "#F7BD52") // F4AB23 // Colour to show success, something right for user. "#00ff66""
    static let Negation = UIColor.init(hexString: "#F0505A") // 980822             // Colour to show error, some danger zones for user. ff3300
    
    // Custom colors
    static let MenuCircleBigOutside = UIColor(hexString: "#4C54A6")
    static let MenuCircleBigInside = UIColor(hexString: "#6A74E6")
    static let MenuCircleMediumOutside = UIColor(hexString: "#2D347B")
    static let MenuCircleMediumInside = UIColor(hexString: "#4049AD")
    static let MenuCircleSmallOutside = UIColor(hexString: "#1E2460")
    static let MenuCircleSmallInside = UIColor(hexString: "#2E3694")
    
    static let White = UIColor(hexString: "#FFFFFF")
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
}


enum FONTNAME {
    
    static let ThemeBold = "HelveticaNeue-Bold"
    static let ThemeRegular = "HelveticaNeue"
}


enum USERDEFAULTSKEY {
    
    static let Duration = "Duration"
}



// Localized strings

let LS_NEWGAME = NSLocalizedString("New Game", comment: "Overdue message")
let LS_GAMEPAUSED = NSLocalizedString("Game Paused", comment: "Message when game is pausing")
let LS_OVERTIME = NSLocalizedString("Time Over", comment: "Time over message")
let LS_HALFTIME = NSLocalizedString("Half Time", comment: "Half time message")
let LS_READYFORH2 = NSLocalizedString("Ready for H2", comment: "H2 to begin message")
let LS_FULLTIME = NSLocalizedString("Full Time", comment: "Full time message")
let LS_FIRSTHALFLABEL = NSLocalizedString("H1", comment: "Half time indication label")
let LS_SECONDHALFLABEL = NSLocalizedString("H2", comment: "Half time indication label")
let LS_WARNINGRESETGAME = NSLocalizedString("RESET GAME", comment: "When reset button tapped")
let LS_WARNINGNEWGAME = NSLocalizedString("NEW GAME", comment: "When stopwatch is tapped for new game")

let LS_HOME = NSLocalizedString("HOME", comment: "Name for home team")
let LS_AWAY = NSLocalizedString("AWAY", comment: "Name for away team")
let LS_UNDOGOAL = NSLocalizedString("UNDO GOAL", comment: "Message for undoing goal")
let LS_MESSAGEEDITSCORES = NSLocalizedString("SWIPE SCORE UP OR DOWN", comment: "Message to explain way to edit scores")
let LS_BACKBUTTON = NSLocalizedString("BACK", comment: "Message on button to back out from document")

let LS_TITLE_EDITSCORE = NSLocalizedString("EDIT SCORE", comment: "title for edit score menu button")
let LS_TITLE_SETGAMETIME = NSLocalizedString("SET GAME TIME", comment: "title for duration VC and menu button")
let LS_TITLE_DOCUMENTS = NSLocalizedString("DOCUMENTS", comment: "Title for document list VC and menu button")


let LS_DOCUMENTNAME_PICTOGRAMU7U8 = NSLocalizedString("VHL PICTOGRAM U7-U8", comment: "Name for document")
let LS_DOCUMENTNAME_PICTOGRAMU9 = NSLocalizedString("VHL PICTOGRAM U9", comment: "Name for document")
let LS_DOCUMENTNAME_PICTOGRAMU10U12 = NSLocalizedString("VHL PICTOGRAM U10-U12", comment: "Name for document")
let LS_DOCUMENTNAME_VHLSHOOTOUTS = NSLocalizedString("VHL SHOOT-OUTS U10", comment: "Name for document")
let LS_DOCUMENTNAME_VHLRULESU7U12 = NSLocalizedString("VHL RULES U7-U12", comment: "Name for document")
let LS_DOCUMENTNAME_VHLRULESU14U19 = NSLocalizedString("VHL RULES U14-U19", comment: "Name for document")
let LS_DOCUMENTNAME_KBHBRULES = NSLocalizedString("KBHB RULES", comment: "Name for document")






