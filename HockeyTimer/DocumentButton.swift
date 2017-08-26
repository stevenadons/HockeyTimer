//
//  DocumentButton.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 12/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DocumentButton: UIButton {

    
    // MARK: - Properties
    
    private(set) var document: Document! {
        didSet {
            setTitle(document.buttonTitle, for: .normal)
            setNeedsDisplay()
        }
    }
    
    static let fixedWidth: CGFloat = 200
    static let fixedHeight: CGFloat = 35
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(document: Document) {
        
        self.init()
        convenienceSet(document: document)
    }
    
    private func convenienceSet(document: Document) {
        
        self.document = document
    }
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 12)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}


extension DocumentButton {
    
    class func button(document: Document, color: UIColor, titleColor: UIColor) -> DocumentButton {
        let button = DocumentButton(document: document)
        button.backgroundColor = color
        button.setTitleColor(titleColor, for: .normal)
        return button
    }
}



extension DocumentButton {
    
    // MARK: - User Methods
    
}
