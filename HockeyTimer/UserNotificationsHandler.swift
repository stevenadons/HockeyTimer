//
//  UserNotificationsHandler.swift
//  ProbeerselUNUserNotification
//
//  Created by Steven Adons on 28/11/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit
import UserNotifications

private let sharedInstance = UserNotificationHandler()

// To perform actions after notification:
// Add observer to ".AppWillEnterForeground"
// ------------------------------------------------------------------------
class UserNotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    
    // MARK: - Properties
    
    class var sharedHandler: UserNotificationHandler {
        return sharedInstance
    }
    
    let ACTION_OK_IDENTIFIER = "OK tapped"
    let ACTION_DEFER_IDENTIFIER = "Defer tapped"
    let CATEGORY_IDENTIFIER = "Timer running in overtime"
    
    
    // MARK: - Public Methods
    
    func initialSetup(then handler: (() -> Void)?) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (accepted, error) in
            if !accepted {
                print("Notification access denied")
            }
            handler?()
        }
        
        let actionOK = UNNotificationAction(identifier: ACTION_OK_IDENTIFIER, title: LS_NOTIFICATION_OK, options: [.foreground]) // "OK"
        let actionDefer = UNNotificationAction(identifier: ACTION_DEFER_IDENTIFIER, title: LS_NOTIFICATION_DEFER, options: []) // "+ 1 minute"
        let category = UNNotificationCategory(identifier: CATEGORY_IDENTIFIER, actions: [actionOK, actionDefer], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    
    func scheduleNotification(text: String, within timeInterval: TimeInterval, onNotificationDo: (() -> Void)? = nil) {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
                UserNotificationHandler.sharedHandler.initialSetup(then: nil)
                return
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = LS_NOTIFICATION_TITLE
        content.body = text
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = CATEGORY_IDENTIFIER
        let identifier = (text == LS_NOTIFICATION_RUNNING_IN_OVERTIME) ? LS_NOTIFICATION_RUNNING_IN_OVERTIME : UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        if text == LS_NOTIFICATION_RUNNING_IN_OVERTIME {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [text])
        }
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error occurred: \(error)")
            }
        }
    }
    
    
    func cancelAllNotificationRequests() {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
        if response.actionIdentifier == ACTION_DEFER_IDENTIFIER {
            let body = response.notification.request.content.body
            scheduleNotification(text: body, within: 60)
        } else if response.actionIdentifier == ACTION_OK_IDENTIFIER {
            // User tapped OK
        } else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            // User tapped message and returns to app
        }
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func ifAuthorizationIsDenied(then handler: @escaping (() -> Void), else secondHandler: (() -> Void)? = nil) {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .denied {
                handler()
            } else {
                secondHandler?()
            }
        }
    }
    
    func ifNotAuthorized(then handler: @escaping (() -> Void), else secondHandler: (() -> Void)? = nil) {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                handler()
            } else {
                secondHandler?()
            }
        }
    }
    
    
}
