//
//  PDFVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 29/06/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit
import PDFKit

class PDFVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var pdfContainer: UIView!
    private var pdfView: PDFView!
    private var data: Data!
    
    
    // MARK: - Init
    
    init(data: Data) {
        
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .coverVertical
        
        pdfContainer = UIView()
        pdfContainer.translatesAutoresizingMaskIntoConstraints = false
        pdfContainer.backgroundColor = .clear
        view.addSubview(pdfContainer)
        
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        pdfContainer.addSubview(pdfView)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            
            pdfContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            pdfContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
            pdfView.leadingAnchor.constraint(equalTo: pdfContainer.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: pdfContainer.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: pdfContainer.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: pdfContainer.bottomAnchor),
        ])
    }
    

}
