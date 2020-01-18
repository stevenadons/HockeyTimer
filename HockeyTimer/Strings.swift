//
//  Strings.swift
//  HockeyTimer
//
//  Created by Steven Adons on 11/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import Foundation



let LS_NEWGAME = NSLocalizedString("New Game", comment: "Overdue message")
let LS_GAMEPAUSED = NSLocalizedString("Game Paused", comment: "Message when game is pausing")
let LS_OVERTIME = NSLocalizedString("In Overtime", comment: "Time over message")
let LS_HALFTIME = NSLocalizedString("Half Time", comment: "Half time message")
let LS_ENDOFFIRSTQUARTER = NSLocalizedString("Q1 Ended", comment: "Half time message")
let LS_ENDOFTHIRDQUARTER = NSLocalizedString("Q3 Ended", comment: "Half time message")
let LS_READYFORH2 = NSLocalizedString("Ready for H2", comment: "H2 to begin message")
let LS_READYFORQ2 = NSLocalizedString("Ready for Q2", comment: "Q2 to begin message")
let LS_READYFORQ3 = NSLocalizedString("Ready for Q3", comment: "Q2 to begin message")
let LS_READYFORQ4 = NSLocalizedString("Ready for Q4", comment: "H2 to begin message")
let LS_FULLTIME = NSLocalizedString("Full Time", comment: "Full time message")
let LS_FIRSTHALFLABEL = NSLocalizedString("H1", comment: "Half time indication label")
let LS_SECONDHALFLABEL = NSLocalizedString("H2", comment: "Half time indication label")
let LS_WARNINGRESETGAME = NSLocalizedString("New Game", comment: "When reset button tapped")
let LS_WARNINGNEWGAME_TITLE = NSLocalizedString("New Game", comment: "When stopwatch is tapped for new game")
let LS_WARNINGNEWGAME_TEXT = NSLocalizedString("Are you sure you want to start a new game?", comment: "When reset button is tapped")
let LS_WARNINGGAMERUNNING = NSLocalizedString("Changing this setting is only possible for new games. Do you want to start a new game?", comment: "When pause at quarters is tapped")
let LS_NOTIFICATION_OK = NSLocalizedString("OK", comment: "OK action in notification when app in background")
let LS_NOTIFICATION_DEFER = NSLocalizedString("Remind me in 1 minute", comment: "To defer app to foreground in notification")
let LS_NOTIFICATION_TITLE = NSLocalizedString("Hockey Game", comment: "Title for notification when app in background")
let LS_NOTIFICATION_CONTENT = NSLocalizedString("Running in Overtime", comment: "Content for notification when app in background")
let LS_GAME_IN_QUARTERS = NSLocalizedString("Game in quarters", comment: "Title for switch")

let LS_BUTTON_CANCEL = NSLocalizedString("Cancel", comment: "Cancel message")
let LS_BUTTON_BACK = NSLocalizedString("Back", comment: "Message on button to back out from document")
let LS_BUTTON_UNDOGOAL = NSLocalizedString("Undo Goal", comment: "Message for undoing goal")
let LS_BUTTON_ONBOARDDISMISS = NSLocalizedString("OK got it", comment: "Button for ending onboarding")

let LS_HALVES = NSLocalizedString("2 x Half", comment: "Title in segmented control")
let LS_QUARTERS = NSLocalizedString("4 x Quarter", comment: "Title in segmented control")

let LS_TITLE_GAMETIME = NSLocalizedString("Change Time", comment: "title for navigating")
let LS_TITLE_DOCUMENTS = NSLocalizedString("Rules", comment: "Title for navigating")
let LS_TITLE_SCORE = NSLocalizedString("Score", comment: "Title for navigating")
let LS_TITLE_STOPWATCH = NSLocalizedString("Stopwatch", comment: "Title for navigating")
let LS_TITLE_ONBOARDINGSLIDE1 = NSLocalizedString("Easy to use", comment: "Onboarding screen")
let LS_TITLE_ONBOARDINGSLIDE2 = NSLocalizedString("Keep track of the score", comment: "Onboarding screen")
let LS_TITLE_ONBOARDINGSLIDE3 = NSLocalizedString("Notifications", comment: "Onboarding screen")
let LS_BODY_ONBOARDINGSLIDE1 = NSLocalizedString("Tap the stopwatch to play or pause", comment: "Onboarding screen")
let LS_BODY_ONBOARDINGSLIDE2 = NSLocalizedString("Drag the ball left or right", comment: "Onboarding screen")
let LS_BODY_ONBOARDINGSLIDE3 = NSLocalizedString("Get notified when timer ends.", comment: "Onboarding screen")

let LS_BUYPREMIUM_TITLE_CHANGE_GAME_TIME = NSLocalizedString("Set New Time", comment: "Title of buy premium VC")
let LS_BUYPREMIUM_TITLE_NEW_GAME = NSLocalizedString("New Game", comment: "Title of buy premium VC")
let LS_BUYPREMIUM_TEXT_CHANGE_GAME_TIME = NSLocalizedString("Watch one ad to continue.\n\nTo change the game times without watching ads, upgrade to Premium Mode with a one time payment.\n\nIn addition, Premium Mode will hold track of your last game time.", comment: "Text of buy premium VC")
let LS_BUYPREMIUM_TEXT_NEW_GAME = NSLocalizedString("Watch one ad to continue with new game.\n\nTo start new games without watching ads, upgrade to Premium Mode with a one time payment.", comment: "Text of buy premium VC")

let LS_BUYPREMIUM_BUYBUTTON = NSLocalizedString("Buy Premium", comment: "Buy button in buypremium VC")
let LS_BUYPREMIUM_WATCHADBUTTON = NSLocalizedString("Watch One Ad", comment: "Watch ad button in buypremium VC")
let LS_BUYPREMIUM_CANCELBUTTON = NSLocalizedString("Cancel", comment: "Cancel button in buypremium VC")
let LS_BUYPREMIUM_RESTORELABEL = NSLocalizedString("Already paid for premium? Restore Purchase.", comment: "textbutton to restore in buypremium VC")
let LS_BUYPREMIUM_NOINTERNET_TITLE = NSLocalizedString("No Internet Connection", comment: "Error message title when no internet connection in buypremium VC")
let LS_BUYPREMIUM_CHECKCONNECTION_TITLE = NSLocalizedString("Please check your internet connection.", comment: "Error message text when no internet connection in buypremium VC")
let LS_BUYPREMIUM_OK = NSLocalizedString("OK", comment: "OK button when responding to error message when no internet connection in buypremium VC")

let LS_ALLOW_NOTIFICATIONS_TITLE = NSLocalizedString("Allow Notifications", comment: "Title of modal VC")
let LS_ALLOW_NOTIFICATIONS_GO_TO_SETTINGS = NSLocalizedString("HockeyUpp sends notification at the exact time the game ends. Open Settings and enable Notifications to get this warning.", comment: "Text in modal VC to allow notifications")
let LS_ALLOW_NOTIFICATIONS_ALLOW_NOTIFICATIONS = NSLocalizedString("HockeyUpp will send you a notification at the exact time the game ends. Enable Notifications to get this warning.", comment: "Text in modal VC to allow notifications")
let LS_ALLOW_NOTIFICATIONS_OK_LET_ME_ALLOW = NSLocalizedString("OK, let me allow", comment: "Confirmation button when enabling notifications.")
let LS_ALLOW_NOTIFICATIONS_NOT_NOW = NSLocalizedString("Not now", comment: "Cancel button when enabling notifications.")

let LS_NEW_APP_VERSION_POPUP_TITLE = NSLocalizedString("New Version Available", comment: "Title in popup")
let LS_NEW_APP_VERSION_POPUP_TEXT = NSLocalizedString("A new version of HockeyUpp is available. Please update to have the latest user experience.", comment: "text in popup")
let LS_NEW_APP_VERSION_POPUP_TEXT_RELEASENOTES_INTRO = NSLocalizedString("Changes include:", comment: "text in popup")
let LS_NEW_APP_VERSION_POPUP_UPDATE_BUTTON = NSLocalizedString("Update", comment: "Button in popup")
let LS_NEW_APP_VERSION_POPUP_SKIP_BUTTON = NSLocalizedString("Skip new version", comment: "Button in popup")

let LS_IOS_VERSION_TOO_LOW_POPUP_TITLE = NSLocalizedString("Unsupported iOS version", comment: "Title in popup")
let LS_IOS_VERSION_TOO_LOW_POPUP_TEXT_1 = NSLocalizedString("You are currently running iOS version ", comment: "text in popup")
let LS_IOS_VERSION_TOO_LOW_POPUP_TEXT_2 = NSLocalizedString(" which is no longer supported. Please update your iOS device to be minimum ", comment: "text in popup")
let LS_IOS_VERSION_TOO_LOW_POPUP_TEXT_3 = NSLocalizedString(".", comment: "text in popup")

let LS_COUNTRY_AUSTRALIA = NSLocalizedString("Australia", comment: "Country name in picker")
let LS_COUNTRY_BELGIUM = NSLocalizedString("Belgium", comment: "Country name in picker")
let LS_COUNTRY_NETHERLANDS = NSLocalizedString("Netherlands", comment: "Country name in picker")
let LS_COUNTRY_GERMANY = NSLocalizedString("Germany", comment: "Country name in picker")
let LS_COUNTRY_ENGLAND = NSLocalizedString("England", comment: "Country name in picker")
let LS_COUNTRY_SPAIN = NSLocalizedString("Spain", comment: "Country name in picker")

let LS_COUNTRY_TEAMS_OF_3 = NSLocalizedString("Teams of 3 & H", comment: "Durationcard description")
let LS_COUNTRY_TEAMS_OF_6 = NSLocalizedString("Teams of 6", comment: "Durationcard description")
let LS_COUNTRY_TEAMS_OF_8 = NSLocalizedString("Teams of 8", comment: "Durationcard description")
let LS_COUNTRY_GENERAL = NSLocalizedString("General", comment: "Durationcard description")
let LS_COUNTRY_INDOOR_AND_H = NSLocalizedString("Indoor & H", comment: "Durationcard description")
let LS_COUNTRY_YOUTH = NSLocalizedString("Youth", comment: "Durationcard description")
let LS_COUNTRY_INDOOR = NSLocalizedString("Indoor", comment: "Durationcard description")
let LS_COUNTRY_OUTDOOR = NSLocalizedString("Outdoor", comment: "Durationcard description")
let LS_COUNTRY_INTERNATIONAL = NSLocalizedString("International", comment: "Durationcard description")
let LS_COUNTRY_IN2HOCKEY = NSLocalizedString("In2Hockey", comment: "Durationcard description")
let LS_COUNTRY_MASTERS_MAMIS_PAPIS = NSLocalizedString("Master & M/P", comment: "Durationcard description")

#warning("to delete")
let LS_SETTINGS_WRITE_A_REVIEW = NSLocalizedString("Write a review", comment: "Setting")
let LS_SETTINGS_SHARE = NSLocalizedString("Share the app", comment: "Setting")
let LS_SETTINGS_CONTACT = NSLocalizedString("Contact us", comment: "Setting")

let LS_MENU_SHARE = NSLocalizedString("Share", comment: "Menu")
let LS_MENU_SHARE_THE_APP = NSLocalizedString("Share the app", comment: "Menu")
let LS_MENU_CONTACT_US = NSLocalizedString("Contact us", comment: "Menu")
let LS_MENU_WRITE_AN_EMAIL = NSLocalizedString("Send us an email", comment: "Menu")
let LS_MENU_REVIEW = NSLocalizedString("Review", comment: "Menu")
let LS_MENU_WRITE_A_REVIEW = NSLocalizedString("Write a review in the App Store", comment: "Menu")
let LS_MENU_DARK_MODE = NSLocalizedString("Dark mode", comment: "Menu")
let LS_MENU_DISPLAY_DARK_MODE = NSLocalizedString("Display the app in dark mode", comment: "Menu")
let LS_MENU_LIGHT_MODE = NSLocalizedString("Light mode", comment: "Menu")
let LS_MENU_DISPLAY_LIGHT_MODE = NSLocalizedString("Display the app in light mode", comment: "Menu")
let LS_MENU_PRIVACY_POLICY = NSLocalizedString("Privacy policy", comment: "Menu")
let LS_MENU_LINK_TO_WEBSITE = NSLocalizedString("Link to website", comment: "Menu")

let LS_REPORT_ERROR = NSLocalizedString("Report a broken link", comment: "Setting")

let LS_EMAIL_SUBJECT = NSLocalizedString("HockeyUpp - Remark", comment: "Subject in feedback email")
let LS_EMAIL_SENTENCE = NSLocalizedString("We welcome your remark or suggestion, which could improve HockeyUpp for you and for all users.", comment: "First sentence in feedback email")
let LS_EMAIL_VERSION = NSLocalizedString("Version ", comment: "Feedback email")
let LS_EMAIL_BUILD = NSLocalizedString("Build ", comment: "Feedback email")
let LS_EMAIL_IOS = NSLocalizedString("iOS ", comment: "Feedback email")
let LS_EMAIL_EMAILERROR_TITLE = NSLocalizedString("Email Error", comment: "Alert when error in email")
let LS_EMAIL_EMAILERROR_TEXT = NSLocalizedString("An error occurred. Unable to open your email client.", comment: "Alert when error in email")







