//
//  MinimumIOSVersionManager.swift
//  HockeyTimer
//
//  Created by Steven Adons on 11/09/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class MinimumIOSVersionManager {
    
    enum VersionError: Error {
        
        case invalidBundleInfo
        case invalidResponse
        case JSONSerializiationError
        case statusCodeNot200
    }
    
    // MARK: - Properties
    
    private weak var presentingViewController: UIViewController!
    
    static var minimumIOSVersion: String = ""
    static var currentIOSVersion: String = ""
    static var alreadyAskedSinceLaunch: Bool = false
    
    
    // MARK: - Init
    
    init(fromViewcontroller fromVC: UIViewController) {
        
        self.presentingViewController = fromVC
    }

    
    // MARK: - Public Methods
    
    func checkIOSVersion() {
        
        DispatchQueue.global().async {
            do {
                let ok = try self.currentIOSVersionAboveMinimum()
                DispatchQueue.main.async {
                    if !ok && !MinimumIOSVersionManager.alreadyAskedSinceLaunch {
                        self.popupUpdateDialogue()
                        MinimumIOSVersionManager.alreadyAskedSinceLaunch = true
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    private func currentIOSVersionAboveMinimum() throws -> Bool {
        
        guard let minimum = Bundle.main.object(forInfoDictionaryKey: "MinimumOSVersion") as? String else {
            throw VersionError.invalidBundleInfo
        }
        MinimumIOSVersionManager.minimumIOSVersion = minimum
        
        let current = UIDevice.current.systemVersion
        MinimumIOSVersionManager.currentIOSVersion = current
        
        let ok = current.compare(minimum, options: .numeric) != .orderedAscending
        
        return ok
    }
    
    
    private func popupUpdateDialogue() {
        
        var message = LS_IOS_VERSION_TOO_LOW_POPUP_TEXT_1
        message += MinimumIOSVersionManager.currentIOSVersion
        message += LS_IOS_VERSION_TOO_LOW_POPUP_TEXT_2
        message += MinimumIOSVersionManager.minimumIOSVersion
        message += LS_IOS_VERSION_TOO_LOW_POPUP_TEXT_3
        
        let alert = UIAlertController(title: LS_IOS_VERSION_TOO_LOW_POPUP_TITLE, message: message, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        presentingViewController.present(alert, animated: true, completion: nil)
    }
}
