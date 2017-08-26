//
//  DismissButtonIconOnly.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 29/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

//import UIKit
//
//class DismissButtonIconOnly: UIButton {
//
//    
//    // MARK: - Properties
//    
//    private var shapeLayer: DismissButtonLayer!
//    
//    
//    
//    // MARK: - Initializing
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//    
//    private func setup() {
//        
//        // Configuring self
//        backgroundColor = UIColor.clear
//        translatesAutoresizingMaskIntoConstraints = false
//        
//        // Add (passive) shapes
//        shapeLayer = DismissButtonLayer()
//        shapeLayer.backgroundColor = UIColor.clear.cgColor
//        layer.addSublayer(shapeLayer)
//    }
//    
//    
//    // MARK: - Layout and draw methods
//    
//    override func layoutSubviews() {
//        
//        super.layoutSubviews()
//        
//        // Adjusting sublayers dimensions to change in UIView dimensions
//        shapeLayer.frame = bounds
//        
//    }
//    
//
//}
