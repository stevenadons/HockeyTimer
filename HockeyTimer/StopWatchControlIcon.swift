//
//  StopWatchControlIcon.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 22/07/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import UIKit

class StopWatchControlIcon: UIView {

    
    // MARK: - Helper Classes
    
    enum Icon {
        
        case PlayIcon
        case PauseIcon
        case StopIcon
        case NoIcon
    }
    
    
    // MARK: - Properties
    
    var icon: Icon = .PlayIcon
        {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var color: UIColor = UIColor.white {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var container: CALayer!
    private var shape: CAShapeLayer!
    private var path: UIBezierPath!
    private var timer: Timer?
    private var isBeating: Bool = false

    
    // MARK: - Initializers
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    
    convenience init(icon: Icon) {
        
        self.init()
        self.icon = icon
    }
    
    
    
    // MARK: - Public methods
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layoutOrAnimateSublayers()
        
        shape.fillColor = color.cgColor
    }
    
    
    func layoutOrAnimateSublayers() {
        
        CATransaction.begin()
        
        // Check whether animation is going on (bounds.size, bounds.origin or position)
        if let animation = layer.animation(forKey: "bounds.size") {
            // Self is animating
            CATransaction.setAnimationDuration(animation.duration)
            CATransaction.setAnimationTimingFunction(animation.timingFunction)
        } else {
            // Self is not animating
            CATransaction.disableActions()
        }
        
        if container.superlayer == layer {
            // Properties to change when layout occurs - will animate or not
            container.frame = bounds
        }
        
        if shape.superlayer == container {
            // Properties to change when layout occurs - will animate or not
            shape.frame = bounds
            
            //  Custom = add animations to include in CATransaction + set animated properties
            let pathAnimation = CABasicAnimation(keyPath: "path")
            shape.add(pathAnimation, forKey: "path")
            shape.path = path(for: icon).cgPath
        }
        
        CATransaction.commit()
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        shape.path = path(for: icon).cgPath
        shape.setNeedsDisplay()
    }
    
    func change(to newIcon: StopWatchControlIcon.Icon) {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn], animations: {
            self.alpha = 0.0
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (finished) in
            self.icon = newIcon
            UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseOut], animations: {
                self.alpha = 1.0
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    
    
    // MARK: - UI methods
    
    private func setup() {
        
        // Configure self
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        
        // Add containerView
        container = CALayer()
        container.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(container)
        
        // Add shape
        shape = CAShapeLayer()
        shape.strokeColor = UIColor.clear.cgColor
        shape.fillColor = color.cgColor
        shape.contentsScale = UIScreen.main.scale
        shape.path = path(for: icon).cgPath
        container.addSublayer(shape)
    }
    
    private func path(for icon: Icon) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        switch icon {
        case .PlayIcon:
            path.move(to: CGPoint(x: bounds.width * 0.24, y: 0))
            path.addLine(to: CGPoint(x: bounds.width * 0.96, y: bounds.height / 2))
            path.addLine(to: CGPoint(x: bounds.width * 0.24, y: bounds.height))
            path.close()
        case .PauseIcon:
            path.move(to: CGPoint(x: bounds.width * 0.14, y: 0))
            path.addLine(to: CGPoint(x: bounds.width * 0.46, y: 0))
            path.addLine(to: CGPoint(x: bounds.width * 0.46, y: bounds.height))
            path.addLine(to: CGPoint(x: bounds.width * 0.14, y: bounds.height))
            path.close()
            path.move(to: CGPoint(x: bounds.width * 0.54, y: 0))
            path.addLine(to: CGPoint(x: bounds.width * 0.86, y: 0))
            path.addLine(to: CGPoint(x: bounds.width * 0.86, y: bounds.height))
            path.addLine(to: CGPoint(x: bounds.width * 0.54, y: bounds.height))
            path.close()
        case .StopIcon:
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            path.addLine(to: CGPoint(x: 0, y: bounds.height))
            path.close()
        case .NoIcon:
            print("No Icon")
        }
        
        return path
    }
    
    
    
    // MARK: - Animation methods
    
    func startPulsing() {
        
        guard !isBeating else { return }
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
                self.pulse()
            }
        }
        isBeating = true
    }
    
    func stopPulsing() {
        
        guard isBeating else { return }
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        isBeating = false
    }
    
    private func pulse() {
        
        let duration = 0.2
        let scale: CGFloat = 0.90
        
        UIView.animate(withDuration: duration, delay: 0.0, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        })  { (finished) in
            UIView.animate(withDuration: duration, delay: 0.0, animations: {
                self.transform = .identity
            })
        }
    }
     
    
    
    // MARK: - Math methods
    
    

}
