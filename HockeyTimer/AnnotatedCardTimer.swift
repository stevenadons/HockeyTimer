//
//  AnnotatedCardTimer.swift
//  HockeyTimer
//
//  Created by Steven Adons on 08/03/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


protocol AnnotatedCardTimerDelegate: AnyObject {
    
    func deleteCardTimer()
}


class AnnotatedCardTimer: UIView {
    
    
    // MARK: - Properties
    
    private var graphics: CAShapeLayer!
    private var bottomRibbon: UIView!
    private var timeLabel: UILabel!
    private var topRibbon: UIView!
    private var teamLabel: UILabel!
    private var playerLabel: UILabel!
    
    private var card: Card!
    private (set) var secondsToGo: Int!
    private var team: Player?
    private var player: Int?
    
    private weak var delegate: AnnotatedCardTimerDelegate?
    private var haptic: UINotificationFeedbackGenerator?

    var isDummyForAddCard: Bool!
    var shouldDelete: Bool = false
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    private var minutes: Int {
        return secondsToGo / 60
    }
    private var seconds: Int {
        return secondsToGo % 60
    }
    
    
    // MARK: - Init
    
    init(card: Card, minutes: Int, team: Player? = nil, player: Int? = nil, delegate: AnnotatedCardTimerDelegate?, isDummyForAddCard: Bool = false) {
        
        super.init(frame: .zero)
        
        self.card = card
        self.secondsToGo = minutes * 60
        self.team = team
        self.player = player
        self.delegate = delegate
        self.isDummyForAddCard = isDummyForAddCard
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        
        let interaction = UIContextMenuInteraction(delegate: self)
        addInteraction(interaction)

        graphics = CAShapeLayer()
        graphics.path = card.pathInSize(.zero).cgPath
        graphics.fillColor = card.color().cgColor
        graphics.lineCap = .round
        layer.addSublayer(graphics)
        
        bottomRibbon = UIView()
        bottomRibbon.translatesAutoresizingMaskIntoConstraints = false
        bottomRibbon.backgroundColor = UIColor(named: ColorName.DarkBlue)!
        addSubview(bottomRibbon)
        
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = .white
        timeLabel.text = updatedTimeString()
        timeLabel.textAlignment = .center
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.baselineAdjustment = .alignCenters
        timeLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        addSubview(timeLabel)
        
        topRibbon = UIView()
        topRibbon.translatesAutoresizingMaskIntoConstraints = false
        topRibbon.backgroundColor = .clear
        addSubview(topRibbon)
        
        var teamColor = UIColor(named: ColorName.DarkBlue)!
        if team == Player.Away {
            teamColor = UIColor(named: ColorName.DarkBlue)! // PantoneRed
        }
        
        teamLabel = UILabel()
        teamLabel.translatesAutoresizingMaskIntoConstraints = false
        teamLabel.textColor = UIColor(named: ColorName.DarkBlue)!
        teamLabel.text = ""
        teamLabel.textAlignment = .left
        teamLabel.adjustsFontSizeToFitWidth = true
        teamLabel.baselineAdjustment = .alignCenters
        teamLabel.font = UIFont(name: "Helvetica-Bold", size: 14)
        teamLabel.textColor = teamColor
        if let team = team {
            teamLabel.text = team.teamString() + " "
        }
        addSubview(teamLabel)
        
        playerLabel = UILabel()
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        playerLabel.textColor = .white
        playerLabel.text = ""
        playerLabel.textAlignment = .right
        playerLabel.adjustsFontSizeToFitWidth = true
        playerLabel.baselineAdjustment = .alignCenters
        playerLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        playerLabel.textColor = teamColor
        if let player = player {
            playerLabel.text = String(player)
        }
        addSubview(playerLabel)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let ribbonRatio: CGFloat = 0.275
        let ratio: CGFloat = card.type == .green ? 0.6 : 0.45
        let graphicsSide = min(bounds.width, bounds.height) * ratio
        let graphicsSize = CGSize(width: graphicsSide, height: graphicsSide)
        let path = card.pathInSize(graphicsSize)
        var cardYOffset = (team != nil) ? bounds.height * ribbonRatio : bounds.height * ribbonRatio * 0.7
        if card.type == .green {
            cardYOffset -= bounds.height * 0.05
        }
        let cardXOffset = (bounds.width - graphicsSide) / 2
        let translate = CGAffineTransform(translationX: cardXOffset, y: cardYOffset)
        path.apply(translate)
        graphics.path = path.cgPath
        let numberSize: CGFloat = bounds.width * 0.3
        
        NSLayoutConstraint.activate([
            
            bottomRibbon.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomRibbon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: ribbonRatio),
            bottomRibbon.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomRibbon.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            timeLabel.leadingAnchor.constraint(equalTo: bottomRibbon.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: bottomRibbon.trailingAnchor),
            timeLabel.topAnchor.constraint(equalTo: bottomRibbon.topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: bottomRibbon.bottomAnchor),
            
            topRibbon.topAnchor.constraint(equalTo: topAnchor),
            topRibbon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: ribbonRatio),
            topRibbon.leadingAnchor.constraint(equalTo: leadingAnchor),
            topRibbon.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            teamLabel.leadingAnchor.constraint(equalTo: topRibbon.leadingAnchor, constant: 6),
            teamLabel.trailingAnchor.constraint(equalTo: playerLabel.leadingAnchor),
            teamLabel.topAnchor.constraint(equalTo: topRibbon.topAnchor),
            teamLabel.bottomAnchor.constraint(equalTo: topRibbon.bottomAnchor),
            
            playerLabel.widthAnchor.constraint(equalToConstant: numberSize),
            playerLabel.trailingAnchor.constraint(equalTo: topRibbon.trailingAnchor, constant: -6),
            playerLabel.topAnchor.constraint(equalTo: topRibbon.topAnchor),
            playerLabel.bottomAnchor.constraint(equalTo: topRibbon.bottomAnchor),
        ])
    }
    
    
    // MARK: - Public Methods
   
    func minusOneSecond() {
        
        guard secondsToGo >= 1 else {
            return
        }
        secondsToGo -= 1
        updateUIWithNewSeconds(sound: true)
    }
    
    func setSecondsToGo(_ int: Int, sound: Bool) {
        
        secondsToGo = int
        updateUIWithNewSeconds(sound: sound)
    }
    
    
    // MARK: - Private Methods
    
    private func updatedTimeString() -> String {
        
        guard card.type != .red else {
            return ""
        }
       
        var timeString = ""
        
        switch minutes {
        case 0:
            timeString += "0:"
        case 1..<10:
            timeString += "\(minutes):"
        default: // 10 minutes or more
            timeString += "\(minutes):"
        }
        
        switch seconds {
        case ..<10:
            timeString += "0\(seconds)"
        default: // 10 to 59 seconds
            timeString += "\(seconds)"
        }
       
        return timeString
    }
    
    private func updateUIWithNewSeconds(sound: Bool) {
        
        timeLabel.text = updatedTimeString()
        if secondsToGo == 0 {
            fade()
            doHaptic()
            if sound {
                JukeBox.instance.playSound(Sound.Alarm)
            }
        } else if secondsToGo == 2 {
            prepareHaptic()
            JukeBox.instance.prepareSound(Sound.Alarm)
        }
    }
    
    private func fade() {
        
        bottomRibbon.backgroundColor = UIColor(named: ColorName.TimerZoneFade)!
        graphics.opacity = 0.5
        timeLabel.alpha = 0.7
        teamLabel.alpha = 0.7
        playerLabel.alpha = 0.7
    }
    
    
    // MARK: - Haptic
    
    private func prepareHaptic() {
        
        if haptic == nil {
            haptic = UINotificationFeedbackGenerator()
            haptic!.prepare()
        }
    }
    
    private func doHaptic() {
        
        haptic?.notificationOccurred(.success) // .success .warning .error
        haptic = nil
    }

}



extension AnnotatedCardTimer: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (elements) -> UIMenu? in
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                self.shouldDelete = true
                self.delegate?.deleteCardTimer()
            }
            
            let children: [UIMenuElement] = [delete]
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: children)
        }
        return configuration
    }
}
