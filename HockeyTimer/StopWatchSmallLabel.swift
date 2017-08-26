//
//  StopWatchSmallLabel.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 23/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class StopWatchSmallLabel: UILabel {

    
    // MARK: - Helper Classes
    
    
    
    // MARK: - Properties

    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    
    
    // MARK: - Public methods
    
    
    
    // MARK: - UI methods
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        backgroundColor = UIColor.clear
        textColor = COLOR.Theme
        text = ""
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        font = UIFont(name: FONTNAME.ThemeRegular, size: 12)
    }

    
    // MARK: - Math methods
    
    

}
