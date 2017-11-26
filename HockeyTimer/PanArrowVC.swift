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
    
    weak var pageVC: PageVC?

    
    // MARK: - Life Cycle Methods
    
    convenience init(pageVC: PageVC) {
        
        self.init()
        self.pageVC = pageVC
    }
    
    
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
            panArrowDown.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -admobHeight - 35),
            panArrowDown.heightAnchor.constraint(equalToConstant: 22),
            
            panArrowDownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panArrowDownLabel.widthAnchor.constraint(equalToConstant: 100),
            panArrowDownLabel.bottomAnchor.constraint(equalTo: panArrowDown.topAnchor, constant: -2),
            panArrowDownLabel.heightAnchor.constraint(equalToConstant: 16),
            
            ])
        
        panArrowUp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(upTapped(sender:))))
        panArrowUpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(upTapped(sender:))))
        
        panArrowDown.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(downTapped(sender:))))
        panArrowDownLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(downTapped(sender:))))
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func upTapped(sender: UITapGestureRecognizer) {
        
        guard let pageVC = pageVC, let upVC = pageVC.pageViewController(pageVC, viewControllerBefore: self) else { return }
        pageVC.pageViewController(pageVC, willTransitionTo: [upVC])
        pageVC.setViewControllers([upVC], direction: .reverse, animated: true, completion: nil)
    }
    
    @objc private func downTapped(sender: UITapGestureRecognizer) {

        guard let pageVC = pageVC, let downVC = pageVC.pageViewController(pageVC, viewControllerAfter: self) else { return }
        pageVC.pageViewController(pageVC, willTransitionTo: [downVC])
        pageVC.setViewControllers([downVC], direction: .forward, animated: true, completion: nil)
    }
}
