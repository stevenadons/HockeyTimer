//
//  AppDelegate.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Customized: chooses which viewcontroller to show first
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        var startViewController: UIViewController
        
        // For testing purposes to test onboarding
//        startViewController = OnboardingVC()
        
        // For testing purposes to avoid onboarding
//        startViewController = PageVC(transitionStyle: .scroll, navigationOrientation: .vertical)
        
        // Standard
        if (UserDefaults.standard.value(forKey: USERDEFAULTSKEY.StartViewController) as? String) == nil {
            startViewController = OnboardingVC()
        } else {
            startViewController = PageVC(transitionStyle: .scroll, navigationOrientation: .vertical)
        }
        
        self.window?.rootViewController = startViewController
        self.window?.makeKeyAndVisible()
        
        guard UserDefaults.standard.value(forKey: USERDEFAULTSKEY.PermissionGrantedNotifications) == nil else { return true }
        let alert = UserNotificationHandler.sharedHandler.prePermissionAlert(title: "Notification permission", message: "You will need to give permission to be alerted when timer ends", confirmation: "OK", dismissal: "No thanks", handlerWhenConfirmed: {
            print("CONFIRMED")
            UserDefaults.standard.set(USERDEFAULTSKEY.PermissionGrantedNotifications, forKey: USERDEFAULTSKEY.PermissionGrantedNotifications)
        })
        startViewController.present(alert, animated: true, completion: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        UserDefaults.standard.set(nil, forKey: USERDEFAULTSKEY.TimerEndTimeWhenInBackground)
        UserDefaults.standard.set(nil, forKey: USERDEFAULTSKEY.TimerStartTimeOverdue)
        UserDefaults.standard.set(nil, forKey: USERDEFAULTSKEY.TimerStartTimeCountingUp)
        
        if runningSecondsToGo > 0 {
            let endTime = NSDate().addingTimeInterval(Double(runningSecondsToGo))
            UserDefaults.standard.set(endTime, forKey: USERDEFAULTSKEY.TimerEndTimeWhenInBackground)
            UserNotificationHandler.sharedHandler.scheduleNotification(within: Double(runningSecondsToGo))
        } else if runningSecondsOverdue > 0 {
            let startTime = NSDate().addingTimeInterval(Double(-runningSecondsOverdue))
            UserDefaults.standard.set(startTime, forKey: USERDEFAULTSKEY.TimerStartTimeOverdue)
        } else if runningSecondsCountingUp > 0 {
            let startTime = NSDate().addingTimeInterval(Double(-runningSecondsCountingUp))
            UserDefaults.standard.set(startTime, forKey: USERDEFAULTSKEY.TimerStartTimeCountingUp)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        UserNotificationHandler.sharedHandler.cancelAllNotificationRequests()
        
        runningSecondsToGo = 0
        runningSecondsOverdue = 0
        runningSecondsCountingUp = 0

        if let storedEndTime = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.TimerEndTimeWhenInBackground) as? NSDate {
            // Restoring from formerly running countdown
            if storedEndTime.timeIntervalSinceNow >= 0 && storedEndTime.timeIntervalSinceNow < Double(runningDuration.rawValue * 60) {
                // Countdown should still be running
                shouldRestoreFromBackground = true
                runningSecondsToGo = Int(storedEndTime.timeIntervalSinceNow)
            } else if storedEndTime.timeIntervalSinceNow < 0 {
                // Should set overdue time
                shouldRestoreFromBackground = true
                runningSecondsOverdue = Int(Date().timeIntervalSince(storedEndTime as Date))
            }
        } else if let storedStartTime = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.TimerStartTimeOverdue) as? NSDate {
            // Restoring from formerly overdue countup
            if storedStartTime.timeIntervalSinceNow < 0 {
                // Overdue countup should resume
                shouldRestoreFromBackground = true
                runningSecondsOverdue = Int(Date().timeIntervalSince(storedStartTime as Date))
            }
        } else if let storedStartTime = UserDefaults.standard.value(forKey: USERDEFAULTSKEY.TimerStartTimeCountingUp) as? NSDate {
            // Restoring from formerly counting up
            if storedStartTime.timeIntervalSinceNow < 0 {
                // Countup should resume
                shouldRestoreFromBackground = true
                runningSecondsCountingUp = Int(Date().timeIntervalSince(storedStartTime as Date))
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATIONNAME.AppWillEnterForeground), object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        UserDefaults.standard.set(nil, forKey: USERDEFAULTSKEY.TimerEndTimeWhenInBackground)
        runningSecondsToGo = 0
    }


}

