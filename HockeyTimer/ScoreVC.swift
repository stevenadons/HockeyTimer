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
    fileprivate var editModeButton: NewGameButtonIconOnly!
    fileprivate var confirmationButton: ConfirmationButton!

    fileprivate var delegate: PitchDelegate?
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
        view.backgroundColor = COLOR.LightYellow
        view.clipsToBounds = true
        setupViews()
    }
    
    private func setupViews() {
        
        pitchContainer = ContainerView()
        view.addSubview(pitchContainer)
        pitch = Pitch(delegate: self)
        pitch.isUserInteractionEnabled = true
        pitchContainer.addSubview(pitch)
        
        editModeButton = NewGameButtonIconOnly()
        editModeButton.addTarget(self, action: #selector(editModeButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(editModeButton)
        
        confirmationButton = ConfirmationButton.redButton(shadow: true)
        confirmationButton.alpha = 0.0
        confirmationButton.setTitle(LS_BUTTON_BACK, for: .normal)
        confirmationButton.addTarget(self, action: #selector(confirmationButtonTapped(sender:forEvent:)), for: [.touchUpInside])
        view.addSubview(confirmationButton)
        
        panArrowUp.color = COLOR.White
        panArrowDown.color = COLOR.White
        panArrowUpLabel.text = LS_TITLE_STOPWATCH
        panArrowDownLabel.text = LS_TITLE_DOCUMENTS
        panArrowUpLabel.textColor = COLOR.DarkOrange
        panArrowDownLabel.textColor = COLOR.DarkOrange

        NSLayoutConstraint.activate([
            
            pitchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 10),
            pitchContainer.heightAnchor.constraint(equalToConstant: 220),
            pitchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pitchContainer.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            pitch.leadingAnchor.constraint(equalTo: pitchContainer.leadingAnchor),
            pitch.trailingAnchor.constraint(equalTo: pitchContainer.trailingAnchor),
            pitch.heightAnchor.constraint(equalTo: pitchContainer.heightAnchor),
            pitch.centerYAnchor.constraint(equalTo: pitchContainer.centerYAnchor),
            
            editModeButton.widthAnchor.constraint(equalToConstant: 44),
            editModeButton.heightAnchor.constraint(equalToConstant: 44),
            editModeButton.topAnchor.constraint(equalTo: pitch.bottomAnchor, constant: 20),
            editModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            confirmationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmationButton.widthAnchor.constraint(equalToConstant: ConfirmationButton.fixedWidth),
            confirmationButton.heightAnchor.constraint(equalToConstant: ConfirmationButton.fixedHeight),
            confirmationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160),
            
            ])
    }
    
    
    
    // MARK: - Drawing and laying out
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    
    // MARK: - Touch Methods
    
    @objc private func editModeButtonTapped(sender: NewGameButtonIconOnly, forEvent event: UIEvent) {
        
        inEditMode = !inEditMode
        pitch.toggleEditMode(on: inEditMode)
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

}


extension ScoreVC: TimerVCDelegate {
    
    func resetGame() {
        pitch.resetScores()
    }
}


extension ScoreVC: PitchDelegate {
    
    func scoreHome() {
        game?.homeScored()
    }
    
    func scoreAway() {
        game?.awayScored()
    }
    
    func scoreHomeMinusOne() {
        game?.homeScoreMinusOne()
    }
    
    func scoreAwayMinusOne() {
        game?.awayScoreMinusOne()
    }
    
    func scoreLabelChanged() {
        
        message = LS_BUTTON_UNDOGOAL
        if confirmationButton.alpha == 0 {
            showConfirmationButton()
        }
        if messageTimer != nil {
            messageTimer?.invalidate()
        }
        messageTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideConfirmationButton), userInfo: nil, repeats: false)
    }
}



