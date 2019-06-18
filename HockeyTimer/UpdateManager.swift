//
//  UpdateManager.swift
//  HockeyTimer
//
//  Created by Steven Adons on 18/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

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
    
    
    // MARK: - Init
    
    init(fromViewcontroller fromVC: UIViewController, appURL: String) {
        
        self.presentingViewController = fromVC
        self.appURL = appURL
    }

    
    // MARK: - Public Methods
    
    func checkForUpdates() {
        
        DispatchQueue.global().async {
            do {
                let update = try self.isUpdateAvailable()
                print("update",update)
                DispatchQueue.main.async {
                    if update {
                        self.popupUpdateDialogue()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    private func isUpdateAvailable() throws -> Bool {
        
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
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            #warning("testing")
            return true
            return version != currentVersion
        }
        throw VersionError.invalidResponse
    }
    
    
    private func popupUpdateDialogue() {
        
        let alert = UIAlertController(title: LS_NEW_APP_VERSION_POPUP_TITLE, message: LS_NEW_APP_VERSION_POPUP_TEXT, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: LS_NEW_APP_VERSION_POPUP_UPDATE_BUTTON, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            guard let productURL = URL(string: self.appURL) else { return } // "https://apps.apple.com/app/id1464432452"
            UIApplication.shared.open(productURL)
        })
        let noBtn = UIAlertAction(title: LS_NEW_APP_VERSION_POPUP_SKIP_BUTTON, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(okBtn)
        alert.addAction(noBtn)
        presentingViewController.present(alert, animated: true, completion: nil)
    }
}
