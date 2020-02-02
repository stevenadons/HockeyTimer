//
//  CircularFABButton.swift
//  CircularFAB
//
//  Created by Steven Adons on 01/02/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class CircularFABButton: UIButton {

    
    // MARK: - Properties
    
    var contentColor: UIColor = .systemBackground {
        didSet {
            if let image = UIImage(systemName: imageName, withConfiguration: configuration)?.withTintColor(contentColor, renderingMode: .alwaysOriginal) {
                setImage(image, for: .normal)
            }
        }
    }
    var bgColor: UIColor = .systemBlue {
        didSet {
            backgroundColor = bgColor
        }
    }
    var imageName: String = "line.horizontal.3" {
        didSet {
            if let image = UIImage(systemName: imageName, withConfiguration: configuration)?.withTintColor(contentColor, renderingMode: .alwaysOriginal) {
                setImage(image, for: .normal)
            }
        }
    }
    var closeImageName: String = "xmark"
    var isShowingHideImage: Bool = false
    
    private let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .large)

    
    
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
        
        backgroundColor = bgColor
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    convenience init(shapeColor: UIColor, bgColor: UIColor) {
        
        self.init()
        convenienceSet(shapeColor: shapeColor, bgColor: bgColor)
    }
    
    private func convenienceSet(shapeColor: UIColor, bgColor: UIColor) {
        
        self.contentColor = shapeColor
        self.bgColor = bgColor
    }
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    
    // MARK: - User Methods
    
    func showCloseImage() {
        
        if let image = UIImage(systemName: closeImageName, withConfiguration: configuration)?.withTintColor(contentColor, renderingMode: .alwaysOriginal) {
            setImage(image, for: .normal)
        }
        isShowingHideImage = true
    }
    
    func hideCloseImage() {
        
        if let image = UIImage(systemName: imageName, withConfiguration: configuration)?.withTintColor(contentColor, renderingMode: .alwaysOriginal) {
            setImage(image, for: .normal)
        }
        isShowingHideImage = false
    }
    
    
    // MARK: - Class Methods
    
    class func createStandardButton(imageName: String) -> CircularFABButton {
        
        let button = CircularFABButton(frame: .zero)
        button.imageName = imageName
        return button
    }


}