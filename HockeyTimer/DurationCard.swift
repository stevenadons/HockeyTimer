//
//  DurationCard.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 6/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class DurationCard: UIButton {

    
    // MARK: - Properties
    
    private var miniStopWatch: MiniStopWatch!
    private var ageLabel: UILabel!
    private (set) var ageString: String = "" {
        didSet {
            ageLabel.text = ageString
            ageLabel.setNeedsDisplay()
        }
    }
    var minutes: Int = HockeyGame.standardMinutes {
        didSet {
            updateColorsWith(minutes: minutes)
            ageString = SELECTED_COUNTRY.minutesStringFor(minutes) ?? ""
            miniStopWatch.minutes = minutes
            miniStopWatch.setNeedsDisplay()
        }
    }
    

    // MARK: - Initializing
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(minutes: Int) {
        
        self.init()
        convenienceSet(minutes: minutes)
    }
    
    private func convenienceSet(minutes: Int) {
        
        self.minutes = minutes
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        miniStopWatch.setNeedsLayout()
    }
    
    private func setup() {
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        miniStopWatch = MiniStopWatch()
        miniStopWatch.minutes = minutes
        addSubview(miniStopWatch)
        
        ageLabel = createAgeLabel(title: ageString)
        if backgroundColor == UIColor(named: ColorName.LightBlue)! {
            ageLabel.textColor = UIColor(named: ColorName.VeryDarkBlue)!
        }
        addSubview(ageLabel)
    }
    
    private func createAgeLabel(title: String) -> UILabel {
        
        let label = UILabel()
        
        label.text = title
        label.font = UIFont(name: FONTNAME.ThemeBlack, size: 14)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = (backgroundColor == UIColor(named: ColorName.LightBlue)!) ? UIColor(named: ColorName.VeryDarkBlue)! : UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        guard bounds.width != 0 && bounds.height != 0 else {
            return
        }
        
        layer.cornerRadius = 8 * max(bounds.height, bounds.width) / 140
        
        NSLayoutConstraint.activate([
            
            miniStopWatch.centerXAnchor.constraint(equalTo: centerXAnchor),
            miniStopWatch.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80 / 140),
            miniStopWatch.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12 * bounds.height / 140),
            miniStopWatch.heightAnchor.constraint(equalTo: miniStopWatch.widthAnchor),
            
            ageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8 * bounds.height / 140),
            ageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            
            ])
        
        miniStopWatch.setNeedsLayout()
        ageLabel.setNeedsLayout()
    }
    
    
    // MARK: - User Methods
    
    func windUp() {
        
        transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        alpha = 0.0
        miniStopWatch.setProgressToZero()
    }

    func popup(delay: Double) {
        
        guard transform != .identity else { return }
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(delay * 1000))
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.alpha = 1.0
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.allowUserInteraction], animations: {
                self.transform = .identity
            }) { (finished) in
                self.animateMiniStopWatch(duration: 0.3)
            }
        }
    }
    
    func setMinutes(_ minutes: Int, minutesString: String, animated: Bool, delay: Double) {
        
        if animated {
            windUp()
        }
        
        self.minutes = minutes
        miniStopWatch.setMinutes(minutes)
        ageString = minutesString
        if animated {
            popup(delay: delay)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func animateMiniStopWatch(duration: Double) {
        
        miniStopWatch.animateProgress(duration: duration)
    }
    
    private func updateColorsWith(minutes: Int) {
        
        switch minutes {
        case 0 ..< 10:
            backgroundColor = UIColor(named: ColorName.Olive)!
            miniStopWatch.color = UIColor(named: ColorName.VeryDarkBlue)!
        case 10 ..< 12:
            backgroundColor = UIColor(named: ColorName.DarkBlue)!
            miniStopWatch.color = UIColor(named: ColorName.VeryDarkBlue)!
        case 12 ..< 15:
            backgroundColor = UIColor(named: ColorName.VeryDarkBlue_Red)!
            miniStopWatch.color = UIColor(named: ColorName.DarkGray_VeryDarkBlue)!
        case 15 ..< 20:
            backgroundColor = UIColor(named: ColorName.LightYellow)!
            miniStopWatch.color = UIColor(named: ColorName.VeryDarkBlue)!
        case 20 ..< 25:
            backgroundColor = UIColor(named: ColorName.LightBlue)!
            miniStopWatch.color = UIColor(named: ColorName.VeryDarkBlue)!
            ageLabel.textColor = UIColor(named: ColorName.VeryDarkBlue)!
        case 25 ..< 30:
            backgroundColor = UIColor(named: ColorName.Olive)!
            miniStopWatch.color = UIColor(named: ColorName.VeryDarkBlue)!
        case 30 ..< 35:
            backgroundColor = UIColor(named: ColorName.DarkBlue)!
            miniStopWatch.color = UIColor(named: ColorName.VeryDarkBlue)!
        case 35 ... 99999:
            backgroundColor = UIColor(named: ColorName.PantoneRed)!
            miniStopWatch.color = UIColor(named: ColorName.VeryDarkBlue)!
        default:
            backgroundColor = UIColor(named: ColorName.Olive)!
            miniStopWatch.color = UIColor(named: ColorName.VeryDarkBlue)!
        }
    }
}









