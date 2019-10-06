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
//
//  Remote data should be like:
/*
{
   "appName": "HockeyUpp",
   "messageTitle": {
      "en": "Message",
      "nl": "Mededeling"
   },
   "messageText": {
      "en": "We noticed in version 1.8 the stopwatch did not always count down when the phone was in standby. We apologise for any inconvenience this may have caused. As from version 1.9 the bug has been fixed.",
      "nl": "In versie 1.8 hebben we gemerkt dat de stopwatch niet altijd aftelde met de iPhone in standby. Excuses voor de tijdelijke hinder. Vanaf versie 1.9 is de bug gefixt."
   },
   "maxViews": 1
}
*/

import UIKit

class RemoteMessageManager {
    
    struct Message {
        
        var title: String?
        var text: String?
        
        var id: String {
            var result: String = ""
            if title != nil {
                result += title!
            }
            if text != nil {
                result += text!
            }
            return result
        }
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
            handler?()
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
        if text != nil {
            
            let message = Message(title: title, text: text)
            
            // Check if maxViews is exceeded
            if let maxViews = extractMaxViews(from: jsonObject) {
                var counter = UserDefaults.standard.integer(forKey: message.id)
                counter += 1
                UserDefaults.standard.set(counter, forKey: message.id)
                if counter > maxViews {
                    handler?(nil)
                    return
                }
            }
            
            // No maxViews or maxViews is not exceeded
            handler?(message)
            
        } else {
            
            // No message text
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
        
        if result == "" {
            result = nil
        }
        
        return result
    }
    
    private func extractMaxViews(from jsonObject: [String: AnyObject]) -> Int? {
        
        var result: Int?
        
        if let maxViews = jsonObject["maxViews"] as? Int {
            result = maxViews
        }
        
        return result
    }
}
