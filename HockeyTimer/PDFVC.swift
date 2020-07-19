//
//  PDFVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 29/06/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit
import PDFKit
import LinkPresentation


class PDFVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var pdfContainer: UIView!
    private var pdfView: PDFView!
    private var game: HockeyGame!
    private var data: Data!
    private var shareButton: UIButton!
    private var doneButton: UIButton!
    
    
    // MARK: - Init
    
    init(game: HockeyGame) {
        
        super.init(nibName: nil, bundle: nil)
        self.game = game
        let pdfCreator = PDFCreator(game: game)
        self.data = pdfCreator.createReport(overrideUserInterfaceStyle)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        checkDarkMode()
        
        view.backgroundColor = .secondarySystemBackground
        
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
        
        shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration)?.withTintColor(UIColor(named: ColorName.DarkBlueText)!, renderingMode: .alwaysOriginal)
        shareButton.setImage(image, for: .normal)
        shareButton.addTarget(self, action: #selector(shareTapped), for: [.touchUpInside])
        view.addSubview(shareButton)
        
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle(LS_BUTTON_DONE, for: .normal)
        doneButton.addTarget(self, action: #selector(doneTapped), for: [.touchUpInside])
        doneButton.setTitleColor(UIColor(named: ColorName.DarkBlueText)!, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 16)
        view.addSubview(doneButton)
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
            
            shareButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        checkDarkMode()
        
        let pdfCreator = PDFCreator(game: game)
        self.data = pdfCreator.createReport(overrideUserInterfaceStyle)
        pdfView?.document = PDFDocument(data: data)
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDarkMode), name: .DarkModeSettingsChanged, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Private Methods
    
    @objc private func checkDarkMode() {
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.DarkModeFollowsPhoneSettings) {
            overrideUserInterfaceStyle = .unspecified
        } else if UserDefaults.standard.bool(forKey: UserDefaultsKey.AlwaysDarkMode) {
            overrideUserInterfaceStyle = .dark
        } else if UserDefaults.standard.bool(forKey: UserDefaultsKey.AlwaysLightMode) {
            overrideUserInterfaceStyle = .light
        }
        view.setNeedsLayout()
    }

    
    // MARK: - Touch Methods
    
    @objc private func doneTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func shareTapped() {
        
        // Conform to UIActivityItemSource for custom activityItems
        let activityViewController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - UIActivityItemSource

extension PDFVC: UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        
        return data as Any
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        return data
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        
        return "HockeyUpp Game Report"
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        
        let metadata = LPLinkMetadata()
        metadata.title = "Share Game Report"
        metadata.imageProvider = NSItemProvider.init(contentsOf: Bundle.main.url(forResource: "AppIconAlt4@2x", withExtension: "png"))
        return metadata
    }
}
