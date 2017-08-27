//
//  PanArrowVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 27/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class PanArrowVC: UIViewController {

    
    
    // MARK: - Properties

    var panArrowUp: PanArrow!
    var panArrowDown: PanArrow!
    var panArrowUpLabel: UILabel!
    var panArrowDownLabel: UILabel!
    
    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        panArrowUp = PanArrow()
        view.addSubview(panArrowUp)
        
        panArrowDown = PanArrow()
        panArrowDown.transform = CGAffineTransform(rotationAngle: .pi)
        view.addSubview(panArrowDown)
        
        panArrowUpLabel = PanArrowLabelFactory.standardLabel(text: "Foo", textColor: COLOR.White, fontStyle: .headline, textAlignment: .center, sizeToFit: false, adjustsFontSizeToFitWidth: true)
        view.addSubview(panArrowUpLabel)
        
        panArrowDownLabel = PanArrowLabelFactory.standardLabel(text: "Foo", textColor: COLOR.White, fontStyle: .headline, textAlignment: .center, sizeToFit: false, adjustsFontSizeToFitWidth: true)
        view.addSubview(panArrowDownLabel)
        
        NSLayoutConstraint.activate([
            
            panArrowUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panArrowUp.widthAnchor.constraint(equalToConstant: 44),
            panArrowUp.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            panArrowUp.heightAnchor.constraint(equalToConstant: 22),
            
            panArrowUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panArrowUpLabel.widthAnchor.constraint(equalToConstant: 100),
            panArrowUpLabel.topAnchor.constraint(equalTo: panArrowUp.bottomAnchor),
            panArrowUpLabel.heightAnchor.constraint(equalToConstant: 16),
            
            panArrowDown.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panArrowDown.widthAnchor.constraint(equalToConstant: 44),
            panArrowDown.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65 - 35),
            panArrowDown.heightAnchor.constraint(equalToConstant: 22),
            
            panArrowDownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panArrowDownLabel.widthAnchor.constraint(equalToConstant: 100),
            panArrowDownLabel.bottomAnchor.constraint(equalTo: panArrowDown.topAnchor),
            panArrowDownLabel.heightAnchor.constraint(equalToConstant: 16),
            
            ])
    }


}
