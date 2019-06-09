//
//  UIDevice.swift
//  HockeyTimer
//
//  Created by Steven Adons on 09/06/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit


enum DeviceSize {
    
    case small
    // 5s, 5c, 5, SE    =   320 x 568 / 4"
    // 3G, 3GS, 4s, 4   =   320 x 480 / 3.5"
    
    case normal
    // 6, 6s, 7, 8      =   375 x 667 / 4.7"
    // 6+, 6s+, 7+, 8+  =   414 x 736 / 5.5"
    
    case big
    // X, XS            =   375 x 812 / 5.8"
    // XR               =   414 x 896 / 6.1"
    // XSmax            =   414 x 896 / 6.5"
}


extension UIDevice {
    
    static var deviceSize: DeviceSize {
        
        switch UIScreen.main.bounds.height {
        case 0...600:
            return .small
        case 800...:
            return .big
        default:
            return .normal
        }
    }
    
    static func whenDeviceIs(small: CGFloat, normal: CGFloat, big: CGFloat) -> CGFloat {
        
        switch UIDevice.deviceSize {
        case .small:
            return small
        case .big:
            return big
        default:
            return normal
        }
    }
}
