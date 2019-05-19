//
//  Products.swift
//  Discounter
//
//  Created by Steven Adons on 16/03/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import Foundation
import StoreKit

struct Products {
    
    private static let productIdentifier = "com.stevenadons.DimpleBall.inapp.premium"
    private static let productIdentifiers: Set<ProductIdentifier> = [Products.productIdentifier]
    
    static let store = Store(productIdentifiers: Products.productIdentifiers)
}

