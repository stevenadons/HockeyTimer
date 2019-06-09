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

    fileprivate var pitchContainer: ContainerView!
    fileprivate var pitch: Pitch!
    fileprivate var editModeButton: EditScoreButton!
    fileprivate var confirmationButton: ConfirmationButton!

    fileprivate var inEditMode: Bool = false
    fileprivate var messageTimer: Timer?
    
    var message: String = "HELLO" {
        didSet {
            confirmationButton.setTitle(message, for: .normal)
        }
    }

    
    // MARK: - Life Cycle
    
    convenience init(game: HockeyGame) {
        
        self.init()
        self.game = game
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = COLOR.White
        view.clipsToBounds = true
        setupViews()
        addObservers()
    }
    
    private func setupViews() {
        
        pitchContainer = ContainerView()
        view.addSubview(pitchContainer)
        pitch = Pitch(delegate: self)
        pitch.isUserInteractionEnabled = true
        pitchContainer.addSubview(pitch)
        
        editModeButton = EditScoreButton()
        editModeButton.addTarget(self, action: #selector(editModeButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(editModeButton)
        
        confirmationButton = ConfirmationButton.blueButton(shadow: true)
        confirmationButton.alpha = 0.0
        confirmationButton.setTitle(LS_BUTTON_BACK, for: .normal)
        confirmationButton.addTarget(self, action: #selector(confirmationButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(confirmationButton)
        
        panArrowUp.color = COLOR.LightYellow
        panArrowDown.color = COLOR.LightYellow
        panArrowUpLabel.text = LS_TITLE_STOPWATCH
        panArrowDownLabel.text = LS_TITLE_DOCUMENTS
        panArrowUpLabel.textColor = COLOR.VeryDarkBlue
        panArrowDownLabel.textColor = COLOR.VeryDarkBlue
        
        let confirmationButtonConstant: CGFloat = UIScreen.main.bounds.height >= 600 ? 120 : 90
        var pitchContainerOffset: CGFloat = UIScreen.main.bounds.height >= 600 ? 0 : 20
        if UIScreen.main.bounds.height >= 800 {
            pitchContainerOffset = -50
        }
        let editModeOffset: CGFloat = UIScreen.main.bounds.height >= 800 ? 30 : 18

        NSLayoutConstraint.activate([
            
            pitchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60),
            pitchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pitchContainer.heightAnchor.constraint(equalTo: pitchContainer.widthAnchor, multiplier: 0.6),
            pitchContainer.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: pitchContainerOffset),
            
            pitch.leadingAnchor.constraint(equalTo: pitchContainer.leadingAnchor),
            pitch.trailingAnchor.constraint(equalTo: pitchContainer.trailingAnchor),
            pitch.heightAnchor.constraint(equalTo: pitchContainer.heightAnchor),
            pitch.centerYAnchor.constraint(equalTo: pitchContainer.centerYAnchor),
            
            editModeButton.widthAnchor.constraint(equalToConstant: 44),
            editModeButton.heightAnchor.constraint(equalToConstant: 44),
            editModeButton.topAnchor.constraint(equalTo: pitch.bottomAnchor, constant: editModeOffset),
            editModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            confirmationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmationButton.widthAnchor.constraint(equalToConstant: ConfirmationButton.fixedWidth),
            confirmationButton.heightAnchor.constraint(equalToConstant: ConfirmationButton.fixedHeight),
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
    
    @objc private func editModeButtonTapped(sender: NewGameButtonIconOnly, forEvent event: UIEvent) {
        
        inEditMode = !inEditMode
        pitch.toggleEditMode(on: inEditMode)
        if confirmationButton.alpha > 0 {
            hideConfirmationButton()
        }
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



