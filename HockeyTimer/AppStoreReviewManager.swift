//
//  AppStoreReviewManager.swift
//  HockeyTimer
//
//  Created by Steven Adons on 10/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//
//  Credits: https://www.raywenderlich.com/9009-requesting-app-ratings-and-reviews-tutorial-for-ios

import StoreKit


enum AppStoreReviewManager {
    
    
    // MARK: - Static Properties
    
    static let actionHurdleForReviewRequest = 6
    static let keyReviewRequest = "keyReviewRequest"
    static let keyAppVersionLastReviewRequest = "keyAppVersionLastReviewRequest"
    
    
    // MARK: - Static Methods
    
    static func requestReviewAtHurdle() {
        
        // 1. Check if hurdle is reached
        var actionCounter = UserDefaults.standard.integer(forKey: AppStoreReviewManager.keyReviewRequest)
        actionCounter += 1
        UserDefaults.standard.set(actionCounter, forKey: AppStoreReviewManager.keyReviewRequest)
        
        guard actionCounter >= actionHurdleForReviewRequest else { return }
        
        // 2. Check that this app version is not rated yet
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = UserDefaults.standard.string(forKey: AppStoreReviewManager.keyAppVersionLastReviewRequest)
        
        guard lastVersion == nil || lastVersion != currentVersion else { return }

        // 3. Perform request
        SKStoreReviewController.requestReview()
        
        // 4. Set User Defaults
        UserDefaults.standard.set(0, forKey: AppStoreReviewManager.keyReviewRequest)
        UserDefaults.standard.set(currentVersion, forKey: AppStoreReviewManager.keyAppVersionLastReviewRequest)
    }
}
