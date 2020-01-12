//
//  ChooseMinutesPanel.swift
//  ProbeerselUICollectionView
//
//  Created by Steven Adons on 05/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

protocol ChooseMinutesPanelDelegate: class {
    
    func didSelectMinutes()
}


class ChooseMinutesPanel: UIView {
    
    
    // MARK: - Properties
    
    private var one: MinutesView!
    private var two: MinutesView!
    private var five: MinutesView!
    private var ten: MinutesView!
    
    weak var delegate: ChooseMinutesPanelDelegate?
    private var minutesViews: [MinutesView] = []
    
    private (set) var selectedMinutesView: MinutesView?
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        one = MinutesView(minutes: 1)
        one.addTarget(self, action: #selector(minutesViewTapped(_:)), for: .touchUpInside)
        minutesViews.append(one)
        addSubview(one)
        
        two = MinutesView(minutes: 2)
        two.addTarget(self, action: #selector(minutesViewTapped(_:)), for: .touchUpInside)
        minutesViews.append(two)
        addSubview(two)
        
        five = MinutesView(minutes: 5)
        five.addTarget(self, action: #selector(minutesViewTapped(_:)), for: .touchUpInside)
        minutesViews.append(five)
        addSubview(five)
        
        ten = MinutesView(minutes: 10)
        ten.addTarget(self, action: #selector(minutesViewTapped(_:)), for: .touchUpInside)
        minutesViews.append(ten)
        addSubview(ten)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let horPadding: CGFloat = 30
        let vertPadding: CGFloat = 26
        let buttonHeight: CGFloat = min(75, (bounds.width - horPadding) / 2, (bounds.height - vertPadding) / 2)
        
        NSLayoutConstraint.activate([
            
            one.widthAnchor.constraint(equalToConstant: buttonHeight),
            one.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -horPadding / 2),
            one.topAnchor.constraint(equalTo: topAnchor),
            one.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            two.leadingAnchor.constraint(equalTo: centerXAnchor, constant: horPadding / 2),
            two.widthAnchor.constraint(equalToConstant: buttonHeight),
            two.topAnchor.constraint(equalTo: one.topAnchor),
            two.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            five.widthAnchor.constraint(equalToConstant: buttonHeight),
            five.trailingAnchor.constraint(equalTo: one.trailingAnchor),
            five.topAnchor.constraint(equalTo: one.bottomAnchor, constant: vertPadding),
            five.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            ten.leadingAnchor.constraint(equalTo: two.leadingAnchor),
            ten.widthAnchor.constraint(equalToConstant: buttonHeight),
            ten.topAnchor.constraint(equalTo: five.topAnchor),
            ten.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            ])
    }
    
    
    
    // MARK: - Touch
    
    @objc private func minutesViewTapped(_ minutesView: MinutesView) {
        
        highlight(minutesView.minutes)
    }
    
    
    // MARK: - Public Methods
    
    func dehighlightAll() {
        
        selectedMinutesView?.highlightBackground(false)
        selectedMinutesView = nil
    }
    
    func setHighlightColor(_ color: UIColor) {
        
        minutesViews.forEach{
            $0.setHighlightColor(color)
        }
    }
    
    func highlight(_ minutes: Int) {
        
        minutesViews.forEach{
            let highlight = ($0.minutes == minutes)
            $0.highlightBackground(highlight)
            if highlight {
                selectedMinutesView = $0
            }
        }
        delegate?.didSelectMinutes()
    }
}
