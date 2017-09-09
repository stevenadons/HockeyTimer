//
//  DocumentMenuVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit


protocol DocumentListDelegate: class {
    
    func handleButtonTapped(sender: DocumentButton)
}


class DocumentMenuVC: PanArrowVC {

    
    // MARK: - Properties
    
    fileprivate var documentList: DocumentList!
    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        documentList.windUp()
    }
    
    private func setup() {
        
        view.backgroundColor = COLOR.White
        
        documentList = DocumentList(delegate: self)
        documentList.backgroundColor = UIColor.clear
        view.addSubview(documentList)
        view.sendSubview(toBack: documentList)
        
        panArrowUp.color = COLOR.LightYellow
        panArrowDown.alpha = 0.0
        panArrowUpLabel.text = LS_TITLE_SCORE
        panArrowDownLabel.alpha = 0.0
        panArrowUpLabel.textColor = COLOR.VeryDarkBlue
        
        NSLayoutConstraint.activate([
            
            documentList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            documentList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            documentList.topAnchor.constraint(equalTo: view.topAnchor),
            documentList.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            ])
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        documentList.animateFlyIn()
    }
    
    
    
    // MARK: - Private Methods
    
    
}


extension DocumentMenuVC: DocumentListDelegate {
    
    func handleButtonTapped(sender: DocumentButton) {
        
        let newVC = DocumentVC()
        newVC.urlString = sender.document.url
        newVC.modalTransitionStyle = .crossDissolve
        present(newVC, animated: true, completion: nil)
    }
    
}
