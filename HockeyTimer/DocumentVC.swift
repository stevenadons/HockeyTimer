//
//  DocumentVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit
import WebKit

class DocumentVC: UIViewController {
    

    // MARK: - Properties
    
    var urlString: String?
    
    fileprivate var button: ConfirmationButton!
    fileprivate var webContainerView: UIView!
    fileprivate var webView: WKWebView!
    fileprivate var maskWithActivityIndicator: MaskWithActivityIndicator!
    
    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        view.backgroundColor = COLOR.White
        
        webContainerView = UIView()
        webContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webContainerView)
        
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webContainerView.addSubview(webView)
        
        button = ConfirmationButton.redButton(shadow: true)
        button.alpha = 0.0
        button.setTitle(LS_BACKBUTTON, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            
            webContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            webContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            webContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            webView.topAnchor.constraint(equalTo: webContainerView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: webContainerView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: webContainerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: webContainerView.trailingAnchor),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: ConfirmationButton.fixedWidth),
            button.heightAnchor.constraint(equalToConstant: ConfirmationButton.fixedHeight),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75),
            
            ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        getWebPage()
        showBackButton(delay: 0.8)
    }
    
    private func getWebPage() {
        
        maskWithActivityIndicator = MaskWithActivityIndicator.init(inView: webView)
        guard urlString != nil else {
            print("No urlString")
            return
        }
        guard let url = URL(string: urlString!) else {
            print("String is no url")
            return
        }
        let request = URLRequest(url: url)
        DispatchQueue.global(qos: .background).async {
            guard self.webView.load(request) != nil else {
                DispatchQueue.main.async {
                    print("Error getting webpage")
                }
                return
            }
        }
    }
    
    
    
    // MARK: - Private Methods
    
    @objc private func backButtonTapped(sender: ConfirmationButton, forEvent event: UIEvent) {
        
        maskWithActivityIndicator.removeFromSuperview()
        dismissVC()
    }
    
    private func showBackButton(delay: Double) {
        
        UIView.animate(withDuration: 0.2, delay: delay, options: [], animations: {
            self.button.alpha = 1.0
        }, completion: nil)
    }
    
    fileprivate func dismissVC() {
        
        dismiss(animated: true, completion: nil)
    }

}


extension DocumentVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        maskWithActivityIndicator.removeFromSuperview()
    }
}
