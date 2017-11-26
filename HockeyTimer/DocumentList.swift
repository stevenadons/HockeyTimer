//
//  DocumentList.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 12/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DocumentList: UIView {

    
    // MARK: - Properties
    
    fileprivate var buttons: [DocumentButton] = []
    fileprivate var delegate: DocumentListDelegate?
    
    fileprivate let topInset: CGFloat = 135
    fileprivate let bottomInset: CGFloat = 185
    fileprivate let smallPadding: CGFloat = 8
    var bigPadding: CGFloat {
        let totalButtonsHeight = 7 * DocumentButton.fixedHeight
        let totalsmallPadding = 3 * smallPadding
        let totalbigPadding = bounds.height - topInset - bottomInset - totalButtonsHeight - totalsmallPadding
        return max(totalbigPadding / 3, smallPadding * 2)
    }
    
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(delegate: DocumentListDelegate) {
        
        self.init()
        convenienceSet(delegate: delegate)
    }
    
    private func convenienceSet(delegate: DocumentListDelegate) {
        
        self.delegate = delegate
    }
    
    private func setup() {
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        for index in 0..<Document.allDocuments().count {
            let document = Document.allDocuments()[index]
            let button: DocumentButton
            if index < 3 {
                button = DocumentButton.button(document: document, color: COLOR.LightYellow, titleColor: COLOR.VeryDarkBlue)
            } else if index == 3 {
                button = DocumentButton.button(document: document, color: COLOR.LightBlue, titleColor: COLOR.VeryDarkBlue)
            } else if index == 4 || index == 5 {
                button = DocumentButton.button(document: document, color: COLOR.DarkBlue, titleColor: COLOR.White)
            } else  {
                button = DocumentButton.button(document: document, color: COLOR.VeryDarkBlue, titleColor: COLOR.White)
            }
            button.addTarget(self, action: #selector(handleButtonTapped(sender:forEvent:)), for: [.touchUpInside])
            button.heightAnchor.constraint(equalToConstant: DocumentButton.fixedHeight).isActive = true
            button.widthAnchor.constraint(equalToConstant: DocumentButton.fixedWidth).isActive = true
            addSubview(button)
            buttons.append(button)
        }
        windUp()
    }
    
    
    
    // MARK: - Layout And Draw Methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        let horInset = min((bounds.width - DocumentButton.fixedWidth) / 2 - 15, 55)
        NSLayoutConstraint.activate([
            
            buttons[0].leadingAnchor.constraint(equalTo: leadingAnchor, constant: horInset),
            buttons[0].topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            buttons[1].leadingAnchor.constraint(equalTo: leadingAnchor, constant: horInset),
            buttons[1].topAnchor.constraint(equalTo: buttons[0].bottomAnchor, constant: smallPadding),
            buttons[2].leadingAnchor.constraint(equalTo: leadingAnchor, constant: horInset),
            buttons[2].topAnchor.constraint(equalTo: buttons[1].bottomAnchor, constant: smallPadding),
            buttons[3].trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horInset),
            buttons[3].topAnchor.constraint(equalTo: buttons[2].bottomAnchor, constant: bigPadding),
            buttons[4].leadingAnchor.constraint(equalTo: leadingAnchor, constant: horInset),
            buttons[4].topAnchor.constraint(equalTo: buttons[3].bottomAnchor, constant: bigPadding),
            buttons[5].leadingAnchor.constraint(equalTo: leadingAnchor, constant: horInset),
            buttons[5].topAnchor.constraint(equalTo: buttons[4].bottomAnchor, constant: smallPadding),
            buttons[6].trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horInset),
            buttons[6].topAnchor.constraint(equalTo: buttons[5].bottomAnchor, constant: bigPadding),
            buttons[7].trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horInset),
            buttons[7].topAnchor.constraint(equalTo: buttons[6].bottomAnchor, constant: smallPadding),
            buttons[8].trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horInset),
            buttons[8].topAnchor.constraint(equalTo: buttons[7].bottomAnchor, constant: smallPadding),
            
            ])
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func handleButtonTapped(sender: DocumentButton, forEvent event: UIEvent) {
        
        delegate?.handleButtonTapped(sender: sender)
    }


    // MARK: - User Methods
    
    func windUp() {
        
        for index in 0..<buttons.count {
            if index == 3 || index >= 6 {
                buttons[index].transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            } else {
                buttons[index].transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
            }
        }
    }

    func animateFlyIn() {
        
        for index in 0..<buttons.count {
            var extraDelay: Double
            switch index {
            case 3:
                extraDelay = 0.1
            case 4...5:
                extraDelay = 0.2
            case 6...8:
                extraDelay = 0.3
            default:
                extraDelay = 0
            }
            if self.buttons[index].transform != .identity {
                UIView.animate(withDuration: 0.2, delay: 0.03 * Double(index) + extraDelay, options: [.allowUserInteraction, .curveEaseOut], animations: {
                    self.buttons[index].transform = .identity
                }, completion: nil)
            }
        }
    }
}


