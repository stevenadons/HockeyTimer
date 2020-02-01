//
//  ScoreVC.swift
//  HockeyTimer
//
//  Created by Steven Adons on 26/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

protocol TimerVCDelegate: class {
    
    func resetGame()
}

protocol PitchDelegate: class {
    
    func scoreHome()
    func scoreAway()
    func scoreLabelChanged()
    func scoreHomeMinusOne()
    func scoreAwayMinusOne()
}



class ScoreVC: PanArrowVC {
    
    
    // MARK: - Properties
    
    var game: HockeyGame?

    private var pitchContainer: ContainerView!
    private var pitch: Pitch!
    private var editButton: UIButton!
    private var confirmationButton: ConfirmationButton!


    private var inEditMode: Bool = false
    private var messageTimer: Timer?
    
    var message: String = "HELLO" {
        didSet {
            confirmationButton.setTitle(message, for: .normal)
        }
    }

    
    // MARK: - Life Cycle
    
    convenience init(game: HockeyGame, pageVC: PageVC, iconsAtTop: Bool) {
        
        self.init()
        self.game = game
        self.pageVC = pageVC
        self.iconsAtTop = iconsAtTop
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        setupViews()
        addObservers()
    }
    
    private func setupViews() {
        
        gameTimeButton.alpha = 0.0

        pitchContainer = ContainerView()
        view.addSubview(pitchContainer)
        pitch = Pitch(delegate: self)
        pitch.isUserInteractionEnabled = true
        pitchContainer.addSubview(pitch)
        
        editButton = UIButton()
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.titleLabel?.numberOfLines = 1
        editButton.titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 14)!
        editButton.setTitleColor(.secondaryLabel, for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped(sender:forEvent:)), for: .touchUpInside)
        let editTitle = inEditMode ? LS_BUTTON_DONT_EDIT_SCORE : LS_BUTTON_EDIT_SCORE
        editButton.setTitle(editTitle, for: .normal)
        view.addSubview(editButton)
        
        confirmationButton = ConfirmationButton.blueButton()
        confirmationButton.alpha = 0.0
        confirmationButton.setTitle(LS_BUTTON_BACK, for: .normal)
        confirmationButton.addTarget(self, action: #selector(confirmationButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(confirmationButton)
        
        panArrowUp.color = UIColor(named: ColorName.LightYellow)!
        panArrowUpLabel.text = LS_TITLE_STOPWATCH
        panArrowUpLabel.textColor = UIColor(named: ColorName.VeryDarkBlue_White)!
        panArrowDown.alpha = 0.0
        panArrowDownLabel.alpha = 0.0
        
        let confirmationButtonConstant = UIDevice.whenDeviceIs(small: 90, normal: 120, big: 120)
        let pitchContainerOffset = UIDevice.whenDeviceIs(small: 25, normal: 25, big: 55)
        let editButtonOffset = UIDevice.whenDeviceIs(small: 12, normal: 16, big: 24)
        let buttonHorInset = UIDevice.whenDeviceIs(small: 20, normal: 35, big: 35)
        let buttonHeight = UIDevice.whenDeviceIs(small: 44, normal: 50, big: 54)

        NSLayoutConstraint.activate([
            
            pitchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -70),
            pitchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pitchContainer.heightAnchor.constraint(equalTo: pitchContainer.widthAnchor, multiplier: 0.6),
            pitchContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -pitchContainerOffset),

            pitch.leadingAnchor.constraint(equalTo: pitchContainer.leadingAnchor),
            pitch.trailingAnchor.constraint(equalTo: pitchContainer.trailingAnchor),
            pitch.heightAnchor.constraint(equalTo: pitchContainer.heightAnchor),
            pitch.centerYAnchor.constraint(equalTo: pitchContainer.centerYAnchor),
            
            editButton.topAnchor.constraint(equalTo: pitch.bottomAnchor, constant: editButtonOffset),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            confirmationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonHorInset),
            confirmationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonHorInset),
            confirmationButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            confirmationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -confirmationButtonConstant),
            
            ])
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNewGame),
                                               name: .NewGame,
                                               object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        inEditMode = false
        pitch.toggleEditMode(on: false)
    }
    
    
    
    // MARK: - Drawing and laying out
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func editButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        
        inEditMode = !inEditMode
        pitch.toggleEditMode(on: inEditMode)
        if confirmationButton.alpha > 0 {
            hideConfirmationButton()
        }
        let editTitle = inEditMode ? LS_BUTTON_DONT_EDIT_SCORE : LS_BUTTON_EDIT_SCORE
        editButton.setTitle(editTitle, for: .normal)
    }
    
    @objc private func confirmationButtonTapped(sender: UIButton, forEvent event: UIEvent) {
        
        hideConfirmationButton()
        if message == LS_BUTTON_UNDOGOAL {
            if messageTimer != nil {
                messageTimer?.invalidate()
                messageTimer = nil
            }
            guard game?.lastScored != nil else { return }
            switch (game?.lastScored)! {
            case .Home:
                pitch.homeMinusOne()
            case .Away:
                pitch.awayMinusOne()
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func showConfirmationButton() {
        
        confirmationButton.grow()
    }

    @objc fileprivate func hideConfirmationButton() {
        
        if messageTimer != nil {
            messageTimer!.invalidate()
            messageTimer = nil
        }
        confirmationButton.shrink()
    }
    
    @objc fileprivate func handleNewGame() {
        
        game = pageVC?.game
        pitch.resetScores()
    }
}


extension ScoreVC: TimerVCDelegate {
    
    func resetGame() {
        pitch.resetScores()
    }
}


extension ScoreVC: PitchDelegate {
    
    func scoreHome() {
        
        game?.homeScored()
        pageVC?.scoreDidChange()
    }
    
    func scoreAway() {
        
        game?.awayScored()
        pageVC?.scoreDidChange()
    }
    
    func scoreHomeMinusOne() {
        
        game?.homeScoreMinusOne()
        pageVC?.scoreDidChange()
    }
    
    func scoreAwayMinusOne() {
        
        game?.awayScoreMinusOne()
        pageVC?.scoreDidChange()
    }
    
    func scoreLabelChanged() {
        
        message = LS_BUTTON_UNDOGOAL
        if confirmationButton.alpha == 0 && !inEditMode {
            showConfirmationButton()
        }
        if messageTimer != nil {
            messageTimer?.invalidate()
        }
        messageTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideConfirmationButton), userInfo: nil, repeats: false)
    }
}



