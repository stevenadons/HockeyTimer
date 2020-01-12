//
//  ItemButton.swift
//  DotMenu
//
//  Created by Steven Adons on 14/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class ItemButton: UIButton {

    
    // MARK: - Properties
    
    var shapeColor: UIColor = UIColor.white {
        didSet {
            buttonLayer.shapeColor = shapeColor
            buttonLayer.setNeedsDisplay()
        }
    }
    var bgColor: UIColor = UIColor.black {
        didSet {
            buttonLayer.bgColor = bgColor
            buttonLayer.setNeedsDisplay()
        }
    }
    var path: UIBezierPath = UIBezierPath() {
        didSet {
            buttonLayer.path = path
            buttonLayer.setNeedsDisplay()
        }
    }
    private var buttonLayer: ItemButtonLayer!
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = true
        buttonLayer = ItemButtonLayer()
        layer.addSublayer(buttonLayer)
    }
    
    convenience init(shapeColor: UIColor, bgColor: UIColor, path: UIBezierPath) {
        
        self.init()
        convenienceSet(shapeColor: shapeColor, bgColor: bgColor, path: path)
    }
    
    private func convenienceSet(shapeColor: UIColor, bgColor: UIColor, path: UIBezierPath) {
        
        self.shapeColor = shapeColor
        self.bgColor = bgColor
        self.path = path
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        buttonLayer.frame = bounds
    }
    
    
    // MARK: - Public Methods
    
    func setColor(_ color: UIColor) {
        
        self.shapeColor = color
        buttonLayer.setColor(color)
    }


}
