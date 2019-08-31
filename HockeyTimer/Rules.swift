//
//  Rules.swift
//  HockeyTimer
//
//  Created by Steven Adons on 04/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import Foundation


struct Rules {
    
    
    // MARK: - Properties
    
    private (set) var name: String!
    private (set) var url: URL?
    private (set) var specificLocaleUrls: [String: URL?]?
    
    
    // MARK: - Init

    // specificLocaleUrls is [Locale.languageCode: URLstring]
    init(name: String, url: String, specificLocaleUrls: [String: String]? = nil) {
        
        self.name = name
        let customAllowedSet = NSCharacterSet(charactersIn: "\"#<>@\\^`{|}").inverted
        if let encodedUrlString = url.addingPercentEncoding(withAllowedCharacters: customAllowedSet) {
            self.url = URL(string: encodedUrlString)
        }
        self.specificLocaleUrls = [:]
        if specificLocaleUrls != nil {
            for key in specificLocaleUrls!.keys {
                if let urlString = specificLocaleUrls![key] {
                    if let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: customAllowedSet) {
                        self.specificLocaleUrls![key] = URL(string: encodedUrlString)
                        print("** didset specificLocaleUrls for key \(key) for button \(name)")
                    }
                }
            }
        }
    }
}
