//
//  RemoteMessageManager.swift
//  HockeyTimer
//
//  Created by Steven Adons on 05/10/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//
//  --------------------------------------------------------------------------------
//  How to use
//
//  private var messageManager: RemoteMessageManager!
//  messageManager = RemoteMessageManager(fromViewcontroller: self, messageURL: "https://raw.githubusercontent.com/stevenadons/RemoteJSON/master/hockeyUppMessage")
//  messageManager.showMessage(then: { ... })
//
//  --------------------------------------------------------------------------------
//

import UIKit

class RemoteMessageManager {
    
    struct Message {
        
        var title: String?
        var text: String?
    }
    
    // MARK: - Properties
    
    private weak var presentingViewController: UIViewController!
    private var messageURL: String!
    
    static var alreadyPresentedSinceLaunch: Bool = false
    
    
    // MARK: - Init
    
    init(fromViewcontroller fromVC: UIViewController, messageURL: String) {
        
        self.presentingViewController = fromVC
        self.messageURL = messageURL
    }

    
    // MARK: - Public Methods
    
    func showMessage(then handler: (() -> Void)?) {
        
        DataService.instance.getJSON(urlString: messageURL) { [weak self] (result) in
            
            guard let self = self else {
                DispatchQueue.main.async {
                    handler?()
                }
                return
            }
            
            switch result {
            case .success(let jsonObject):
                self.handleJSON(jsonObject) { [weak self] (message) in
                    guard let self = self, !(RemoteMessageManager.alreadyPresentedSinceLaunch) else {
                        return
                    }
                    self.popup(message, then: handler)
                    RemoteMessageManager.alreadyPresentedSinceLaunch = true
                }
            case .failure( _):
                DispatchQueue.main.async {
                    handler?()
                }
            }
        }
    }
    
    private func popup(_ message: Message?, then handler: (() -> Void)?) {
        
        guard let message = message else {
            return
        }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message.title, message: message.text, preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                handler?()
            }
            alert.addAction(ok)
            self.presentingViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func handleJSON(_ jsonObject: [String: AnyObject], then handler: ((Message?) -> Void)?) {
        
        guard let appName = jsonObject["appName"] as? String, appName == "HockeyUpp" else {
            handler?(nil)
            return
        }
        
        guard let titleDict = jsonObject["messageTitle"] as? [String: String], let messageDict = jsonObject["messageText"] as? [String: String] else {
            handler?(nil)
            return
        }
        
        let title = extractContent(from: titleDict)
        let text = extractContent(from: messageDict)
        if title != nil && text != nil {
            let message = Message(title: title, text: text)
            handler?(message)
        } else {
            handler?(nil)
        }
    }
    
    private func extractContent(from dict: [String: String]) -> String? {
        
        var result: String?
        
        if let appLanguage = Bundle.main.preferredLocalizations.first, let appPreferredContent = dict[appLanguage], appPreferredContent != "" {
            result = appPreferredContent
        } else if let language = Locale.current.languageCode, let preferredContent = dict[language], preferredContent != "" {
            result = preferredContent
        } else if let englishContent = dict["en"] {
            result = englishContent
        } else if !(dict.isEmpty), let first = dict.first?.value {
            result = first
        }
        
        return result
    }
}
