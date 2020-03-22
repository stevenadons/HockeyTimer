//
//  CardTimer.swift
//  ProbeerselUICollectionView
//
//  Created by Steven Adons on 04/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit


protocol CardTimerDelegate: AnyObject {
    
    func deleteCardTimer()
}


class CardTimer: UIView {
    
    
    // MARK: - Properties
    
    private var graphics: CAShapeLayer!
    private var timerZone: UIView!
    private var timeLabel: UILabel!
    
    private var card: Card!
    private (set) var secondsToGo: Int!
    private weak var delegate: CardTimerDelegate?
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
    
    init(card: Card, minutes: Int, delegate: CardTimerDelegate?, isDummyForAddCard: Bool = false) {
        
        super.init(frame: .zero)
        
        self.card = card
        self.secondsToGo = minutes * 60
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
        
        timerZone = UIView()
        timerZone.translatesAutoresizingMaskIntoConstraints = false
        timerZone.backgroundColor = UIColor(named: ColorName.DarkBlue)!
        addSubview(timerZone)
        
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = .white
        timeLabel.text = updatedTimeString()
        timeLabel.textAlignment = .center
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.baselineAdjustment = .alignCenters
        timeLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        addSubview(timeLabel)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let ratio: CGFloat = card.type == .green ? 0.6 : 0.45
        let graphicsSide = min(bounds.width, bounds.height) * ratio
        let graphicsSize = CGSize(width: graphicsSide, height: graphicsSide)
        let path = card.pathInSize(graphicsSize)
        let cardYOffset = card.type == .green ? bounds.height * 0.1 : bounds.height * 0.15 // 0.2
        let cardXOffset = (bounds.width - graphicsSide) / 2
        let translate = CGAffineTransform(translationX: cardXOffset, y: cardYOffset)
        path.apply(translate)
        graphics.path = path.cgPath
        
        NSLayoutConstraint.activate([
            
            timerZone.bottomAnchor.constraint(equalTo: bottomAnchor),
            timerZone.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            timerZone.leadingAnchor.constraint(equalTo: leadingAnchor),
            timerZone.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            timeLabel.leadingAnchor.constraint(equalTo: timerZone.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: timerZone.trailingAnchor),
            timeLabel.topAnchor.constraint(equalTo: timerZone.topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: timerZone.bottomAnchor),
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
        
        timerZone.backgroundColor = UIColor(named: ColorName.TimerZoneFade)!
        graphics.opacity = 0.5
        timeLabel.alpha = 0.6
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



extension CardTimer: UIContextMenuInteractionDelegate {
    
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
