//
//  NotificationNameX.swift
//  HockeyTimer
//
//  Created by Steven Adons on 19/05/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let NewGame = Notification.Name("NewGame")
    static let AppWillEnterForeground = Notification.Name("AppWillEnterForeground")
    static let CurrentTimerPositionLoaded = Notification.Name("CurrentTimerPositionLoaded")
    static let PurchaseNotification = Notification.Name("PurchaseNotification")
    static let TransactionEndedNotification = Notification.Name("TransactionEndedNotification")
    static let AwakeFromNotification = Notification.Name("AwakeFromNotification")
    static let DarkModeSettingsChanged = Notification.Name("DarkModeSettingsChanged")
    static let CustomTimeSelectionOccurred = Notification.Name("CustomTimeSelectionOccurred")
    static let CircularFABWillOpen = Notification.Name("CircularFABWillOpen")
    static let CircularFABDidClose = Notification.Name("CircularFABDidClose")

//    static let AccessToPremiumNotification = Notification.Name("AccessToPremiumNotification")

}
