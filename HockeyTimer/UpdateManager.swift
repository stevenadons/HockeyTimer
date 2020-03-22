//
//  UpdateManager.swift
//  HockeyTimer
//
//  Created by Steven Adons on 18/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//
//  --------------------------------------------------------------------------------
//  How to use
//
//  On first screen show up:
//
//  private var updateManager: UpdateManager!
//  updateManager = UpdateManager(fromViewcontroller: self, appURL: "https://itunes.apple.com/app/apple-store/id1461703535?mt=8")
//  updateManager.showUpdate(then: {...})
//
//  --------------------------------------------------------------------------------

import UIKit

class UpdateManager {
    
    enum VersionError: Error {
        
        case invalidBundleInfo
        case invalidResponse
        case JSONSerializiationError
        case statusCodeNot200
    }
    
    // MARK: - Properties
    
    private weak var presentingViewController: UIViewController!
    private var appURL: String!
    
    static var alreadyAskedSinceLaunch: Bool = false
    
    
    // MARK: - Init
    
    // AppURL is in format "https://itunes.apple.com/app/apple-store/id1436430225?mt=8"
    // Note: Used to use apps.apple.com but:
    // When Apple reviewed this feature in Gift Linker (1.4 build 1) they stated that:
    // "Update button or alert does not link directly to the app’s page on the App Store"
    init(fromViewcontroller fromVC: UIViewController, appURL: String) {
        
        self.presentingViewController = fromVC
        self.appURL = appURL
    }

    
    // MARK: - Public Methods
    
    func showUpdate(style: UIAlertController.Style, then handler: (() -> Void)?) {
        
        DispatchQueue.global().async {
            do {
                let update = try self.isUpdateAvailable().0
                DispatchQueue.main.async {
                    if update && !UpdateManager.alreadyAskedSinceLaunch {
                        self.popupUpdateDialogue(style: style, then: handler)
                        UpdateManager.alreadyAskedSinceLaunch = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    handler?()
                }
                print(error)
            }
        }
    }
    
    private func isUpdateAvailable() throws -> (Bool, String?) {
        
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let appStoreVersion = result["version"] as? String {
            
            var shouldPromptForUpdate = false
            let isVersionDifferent = (appStoreVersion != currentVersion)
            if isVersionDifferent {
                let isCurrentVersionBelowAppStoreVersion = (currentVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending)
                if isCurrentVersionBelowAppStoreVersion {
                    shouldPromptForUpdate = true
                }
            }
            
            if let releaseNotes = result["releaseNotes"] as? String, releaseNotes.count > 5 {
                return (shouldPromptForUpdate, releaseNotes)
            } else {
                return (shouldPromptForUpdate, nil)
            }
            
        }
        throw VersionError.invalidResponse
    }
    
    
    private func popupUpdateDialogue(style: UIAlertController.Style, then handler: (() -> Void)?) {
        
        do {
            let releaseNotes = try self.isUpdateAvailable().1
            DispatchQueue.main.async {
                var message = LS_NEW_APP_VERSION_POPUP_TEXT
                if releaseNotes != nil {
                    message += "\n\n"
                    message += LS_NEW_APP_VERSION_POPUP_TEXT_RELEASENOTES_INTRO
                    message += "\n"
                    message += releaseNotes!
                }
                let alert = UIAlertController(title: LS_NEW_APP_VERSION_POPUP_TITLE, message: message, preferredStyle: style)
                let ok = UIAlertAction(title: LS_NEW_APP_VERSION_POPUP_UPDATE_BUTTON, style: .default) { (action) in
                    guard let productURL = URL(string: self.appURL) else { return }
                    UIApplication.shared.open(productURL)
                    handler?()
                }
                let cancel = UIAlertAction(title: LS_NEW_APP_VERSION_POPUP_SKIP_BUTTON, style: .cancel) { (action) in
                    handler?()
                }
                alert.addAction(ok)
                alert.addAction(cancel)
                self.presentingViewController.present(alert, animated: true, completion: nil)
            }
        } catch {
            print(error)
            DispatchQueue.main.async {
                handler?()
            }
        }
    }
}
