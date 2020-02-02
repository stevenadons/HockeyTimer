//
//  CountryVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 19/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


class CountryVC: UIViewController {
    
    
    // MARK: - Properties
    
    private var titleLabel: UILabel!
    private var tableView: UITableView!
    private var doneButton: UIButton!

    private var titleText: String?
    private let countries: [Country] = CountryDataManager.shared.countries
    
    private var onDismiss: (() -> Void)?

   
    
    // MARK: - Life Cycle
    
    init(titleText: String? = nil, onDismiss: (() -> Void)? = nil) {
        
        self.titleText = titleText
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        checkDarkMode()
        addObservers()
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .coverVertical
        
        setupUI()
        addConstraints()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = titleText ?? ""
        titleLabel.font = UIFont(name: FONTNAME.ThemeBlack, size: 28)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none // .singleLine
        tableView.separatorInset = .zero
        tableView.separatorColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        // Make the viewcontroller dismissable by swiping down
        // Setting isScrollEnabled to false will not work for this
        tableView.panGestureRecognizer.isEnabled = false
        view.addSubview(tableView)
        
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle(LS_BUTTON_DONE, for: .normal)
        doneButton.addTarget(self, action: #selector(doneTapped), for: [.touchUpInside])
        doneButton.setTitleColor(UIColor(named: ColorName.DarkBlueText)!, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 16)
        view.addSubview(doneButton)
    }
    
    private func addConstraints() {
        
        let tableViewHorInset: CGFloat = 9
        let padding: CGFloat = UIDevice.whenDeviceIs(small: 15, normal: 30, big: 30)
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tableViewHorInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tableViewHorInset),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        checkDarkMode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        onDismiss?()
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDarkMode), name: .DarkModeSettingsChanged, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func doneTapped() {
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Actions

    
    
    
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
}


extension CountryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = CountryCell()
        cell.configureWith(country: countries[indexPath.row], textColor: .label, ovalColor: UIColor(named: ColorName.DarkBlueText)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // A short delay to avoid long delays (didSelectRow can be a slow method)
        // https://stackoverflow.com/questions/27203324/unpredictable-delay-before-uipopovercontroller-appears-under-ios-8-1/27227446#27227446
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [unowned self] in
            SELECTED_COUNTRY = CountryDataManager.shared.countries[indexPath.row]
            self.dismiss(animated: true, completion: nil)
        }
    }
}


