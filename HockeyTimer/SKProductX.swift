//
//  SKProductX.swift
//  Discounter
//
//  Created by Steven Adons on 16/03/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import Foundation
import StoreKit


private var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.formatterBehavior = .behavior10_4
    return formatter
}()


extension SKProduct {
    
    func formattedPrice() -> String {
        
        return formatter.string(from: price) ?? "\(price)"
    }
}
