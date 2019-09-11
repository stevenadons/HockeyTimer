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
    
    fileprivate var miniStopWatch: MiniStopWatch!
    fileprivate var ageLabel: UILabel!
    fileprivate var ageString: String = "" {
        didSet {
            ageLabel.text = ageString
            ageLabel.setNeedsDisplay()
        }
    }
    var duration: Duration = .TwentyFive {
        didSet {
            switch duration {
            case .Nine:
                backgroundColor = UIColor(named: "Olive")
                miniStopWatch.color = UIColor(named: "VeryDarkBlue")!
            case .Ten:
                backgroundColor = UIColor(named: "DarkBlue")
                miniStopWatch.color = UIColor(named: "VeryDarkBlue")!
            case .Twelve:
                backgroundColor = UIColor(named: "VeryDarkBlue")!
                miniStopWatch.color = UIColor(named: "DarkGray")!
            case .Fifteen:
                backgroundColor = UIColor(named: "LightYellow")!
                miniStopWatch.color = UIColor(named: "VeryDarkBlue")!
            case .Twenty:
                backgroundColor = UIColor(named: "LightBlue")!
                miniStopWatch.color = UIColor(named: "VeryDarkBlue")!
            case .TwentyFive:
                backgroundColor = UIColor(named: "Olive")
                miniStopWatch.color = UIColor(named: "VeryDarkBlue")!
            case .Thirty:
                backgroundColor = UIColor(named: "DarkBlue")
                miniStopWatch.color = UIColor(named: "VeryDarkBlue")!
            case .ThirtyFive:
                backgroundColor = UIColor(named: "VeryDarkBlue")!
                miniStopWatch.color = UIColor(named: "DarkGray")!
            }
            ageString = SELECTED_COUNTRY.durationStringFor(duration) ?? "error"
            miniStopWatch.duration = duration
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
    
    convenience init(duration: Duration) {
        
        self.init()
        convenienceSet(duration: duration)
    }
    
    private func convenienceSet(duration: Duration) {
        
        self.duration = duration
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        miniStopWatch.setNeedsLayout()
    }
    private func setup() {
        
        backgroundColor = UIColor.cyan
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderColor = COLOR.Theme.cgColor
        layer.borderWidth = 0
        layer.shadowColor = UIColor(named: "DarkGray")!.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = shadowed ? 0.8 : 0.0
        layer.shadowRadius = 3
        
        miniStopWatch = MiniStopWatch()
        miniStopWatch.duration = duration
        addSubview(miniStopWatch)
        
        ageLabel = createAgeLabel(title: ageString)
        if duration == .Twenty {
            ageLabel.textColor = UIColor(named: "DarkBlue")
        }
        addSubview(ageLabel)
        
        windUp()
    }
    
    private func createAgeLabel(title: String) -> UILabel {
        
        let label = UILabel()
        
        label.text = title
        label.font = UIFont(name: FONTNAME.ThemeBlack, size: 15)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = (backgroundColor == UIColor(named: "LightBlue")!) ? UIColor(named: "VeryDarkBlue")! : UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    
    
    // MARK: - Layout and draw methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerRadius = 8 * max(bounds.height, bounds.width) / 140
        
        NSLayoutConstraint.activate([
            
            miniStopWatch.centerXAnchor.constraint(equalTo: centerXAnchor),
            miniStopWatch.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80 / 140),
            miniStopWatch.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12 * bounds.height / 140),
            miniStopWatch.heightAnchor.constraint(equalTo: miniStopWatch.widthAnchor),
            
            ageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 120 / 140),
            ageLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 38 * bounds.height / 140),
            ageLabel.heightAnchor.constraint(equalToConstant: 25 * bounds.height / 140),
            
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
    
    func setDuration(_ duration: Duration, durationString: String, animated: Bool, delay: Double) {
        
        if animated {
            windUp()
        }
        
        self.duration = duration
        miniStopWatch.setDuration(duration)
        ageString = durationString
        
        if animated {
            popup(delay: delay)
        }
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func animateMiniStopWatch(duration: Double) {
        
        miniStopWatch.animateProgress(duration: duration)
    }
    
}









