//
//  AppDelegate.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit
import StoreKit
import GoogleMobileAds


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    // MARK: - Properties

    var window: UIWindow?

    
    // MARK: - Life Cycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        #warning("testing")
//        UserDefaults.standard.set(true, forKey: UserDefaultsKey.PremiumMode)
        
        firstTimeSetDarkModeSettings()
        
        AppDelegate.checkIfInPremiumMode(ifNot: {
            AppDelegate.downloadInAppProducts()
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        })
        
        CountryDataManager.shared.getData()
        
        // Customized: chooses which viewcontroller to show first
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .black
        var startViewController: UIViewController
        
        // For testing purposes to test onboarding
//        #warning("testing")
//        startViewController = OnboardingVC()
        
        // For testing purposes to avoid onboarding
//        #warning("testing")
//        startViewController = PageVC(transitionStyle: .scroll, navigationOrientation: .vertical)
        
        // Standard one time onboarding
        if (UserDefaults.standard.value(forKey: UserDefaultsKey.ShouldNotOnboard) as? String) == nil {
            startViewController = OnboardingVC()
        } else {
            startViewController = PageVC(transitionStyle: .scroll, navigationOrientation: .vertical)
        }
        
        self.window?.rootViewController = startViewController
        self.window?.makeKeyAndVisible()
        
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.TimerEndTimeWhenInBackground)
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.TimerStartTimeOverdue)
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.TimerStartTimeCountingUp)
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.CardEndTimesWhenInBackground)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print("applicationDidEnterBackground runningSecondsToGo is \(runningSecondsToGo)")

        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.TimerEndTimeWhenInBackground)
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.TimerStartTimeOverdue)
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.TimerStartTimeCountingUp)
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.CardEndTimesWhenInBackground)

        print("applicationDidEnterBackground runningSecondsOverdue is \(runningSecondsOverdue)")

        guard timerIsRunning else { return }
        
        if runningSecondsToGo > 0 {
            
            // Update memory of game time
            let endTime = NSDate().addingTimeInterval(Double(runningSecondsToGo))
            UserDefaults.standard.set(endTime, forKey: UserDefaultsKey.TimerEndTimeWhenInBackground)
            print("applicationDidEnterBackground did store endTime in \(runningSecondsToGo) seconds")
            UserNotificationHandler.sharedHandler.scheduleNotification(text: LS_NOTIFICATION_RUNNING_IN_OVERTIME, within: Double(runningSecondsToGo))
            
            // Update memory of pending cards
            guard !allCardsSecondsToGo.isEmpty else {
                return
            }
            var cardEndTimes: [NSDate] = []
            for cardSecondsToGo in allCardsSecondsToGo {
                let cardEndTime = NSDate().addingTimeInterval(Double(cardSecondsToGo))
                cardEndTimes.append(cardEndTime)
                if cardSecondsToGo > 0 {
                    print("Planning notification in \(cardSecondsToGo) seconds")
                    UserNotificationHandler.sharedHandler.scheduleNotification(text: LS_NOTIFICATION_CARD_HAS_ENDED, within: Double(cardSecondsToGo))
                }
            }
            UserDefaults.standard.set(cardEndTimes, forKey: UserDefaultsKey.CardEndTimesWhenInBackground)
            print("applicationDidEnterBackground did store card endTimes in \(cardEndTimes) seconds")

        } else if runningSecondsOverdue > 0 {
            let startTime = NSDate().addingTimeInterval(Double(-runningSecondsOverdue))
            UserDefaults.standard.set(startTime, forKey: UserDefaultsKey.TimerStartTimeOverdue)
            print("applicationDidEnterBackground did store startTime \(runningSecondsOverdue) ago - runningSecondsOverdue")

        } else if runningSecondsCountingUp > 0 {
            let startTime = NSDate().addingTimeInterval(Double(-runningSecondsCountingUp))
            UserDefaults.standard.set(startTime, forKey: UserDefaultsKey.TimerStartTimeCountingUp)
            print("applicationDidEnterBackground did store startTime \(runningSecondsCountingUp) ago - runningSecondsCountingUp")
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        UserNotificationHandler.sharedHandler.cancelAllNotificationRequests()

        runningSecondsToGo = 0
        runningSecondsOverdue = 0
        runningSecondsCountingUp = 0

        if let storedEndTime = UserDefaults.standard.value(forKey: UserDefaultsKey.TimerEndTimeWhenInBackground) as? NSDate {
            
            // Restoring from formerly running countdown
            if storedEndTime.timeIntervalSinceNow >= 0 {
                // Countdown should still be running
                shouldRestoreFromBackground = true
                runningSecondsToGo = Int(storedEndTime.timeIntervalSinceNow)
                print("applicationWillEnterForeground - case 1 - did set runningSecondsToGo to \(runningSecondsToGo)")

            } else {
                // Should set overdue time
                shouldRestoreFromBackground = true
                runningSecondsOverdue = Int(Date().timeIntervalSince(storedEndTime as Date))
                print("applicationWillEnterForeground - case 2 - did set runningSecondsOverdue to \(runningSecondsOverdue)")
            }
            
            // Restoring card end times
            if let cardEndTimes = UserDefaults.standard.object(forKey: UserDefaultsKey.CardEndTimesWhenInBackground) as? [NSDate] {
                var newAllCardsSecondsToGo: [Int] = []
                for cardEndTime in cardEndTimes {
                    let calculatedSecondsToGo = Int(cardEndTime.timeIntervalSinceNow)
                    let cardSecondsToGo = max(calculatedSecondsToGo, 0)
                    newAllCardsSecondsToGo.append(cardSecondsToGo)
                }
                allCardsSecondsToGo = newAllCardsSecondsToGo
                print("applicationWillEnterForeground - case 1 - did set allCardsSecondsToGo to \(allCardsSecondsToGo)")
            }

        } else if let storedStartTime = UserDefaults.standard.value(forKey: UserDefaultsKey.TimerStartTimeOverdue) as? NSDate {
            
            // Restoring from formerly overdue countup
            if storedStartTime.timeIntervalSinceNow < 0 {
                // Overdue countup should resume
                shouldRestoreFromBackground = true
                runningSecondsOverdue = Int(Date().timeIntervalSince(storedStartTime as Date))
                print("applicationWillEnterForeground - case 3 - did set runningSecondsOverdue to \(runningSecondsOverdue)")
            }

        } else if let storedStartTime = UserDefaults.standard.value(forKey: UserDefaultsKey.TimerStartTimeCountingUp) as? NSDate {
            
            // Restoring from formerly counting up
            if storedStartTime.timeIntervalSinceNow < 0 {
                // Countup should resume
                shouldRestoreFromBackground = true
                runningSecondsCountingUp = Int(Date().timeIntervalSince(storedStartTime as Date)) - 1
                print("applicationWillEnterForeground - case 4 - did set runningSecondsCountingUp to \(runningSecondsCountingUp)")
            }
        }

        NotificationCenter.default.post(name: .CurrentTimerPositionLoaded, object: nil)
        print("applicationWillEnterForeground - did post CurrentTimerPositionLoaded")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.TimerEndTimeWhenInBackground)
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.TimerStartTimeOverdue)
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.TimerStartTimeCountingUp)
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.CardEndTimesWhenInBackground)
        
        UserNotificationHandler.sharedHandler.cancelAllNotificationRequests()
    }
    
    
    // MARK: - In App Purchases
    
    class func checkIfInPremiumMode(ifNot completionHandler: () -> Void) {
        
        let inPremiumMode = UserDefaults.standard.bool(forKey: UserDefaultsKey.PremiumMode)
        if !inPremiumMode {
            completionHandler()
        }
        
    }
    
    class func downloadInAppProducts() {
        
        Products.store.requestProducts { (success, products) in
            
            // This is an escaping closure
            
            if success && products != nil {
                appStoreProducts = products!
                if products!.count > 0 {
                    
                    let productIdentifier = products![0].productIdentifier
                    let productPurchased = Products.store.isProductPurchased(productIdentifier)
                    if productPurchased {
                        UserDefaults.standard.set(true, forKey: UserDefaultsKey.PremiumMode)
                    } 
                }
            }
        }
    }
    
    
    // MARK: - Dark Mode
    
    private func firstTimeSetDarkModeSettings() {
        
        if !UserDefaults.standard.bool(forKey: UserDefaultsKey.PremiumMode) {
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.AlwaysDarkMode)
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.AlwaysLightMode)
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings)
        }
    }
}
