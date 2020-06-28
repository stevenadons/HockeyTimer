//
//  ChooseTeamPanel.swift
//  HockeyTimer
//
//  Created by Steven Adons on 08/03/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

protocol ChooseTeamPanelDelegate: AnyObject {
    
    func didSelectTeam()
}


class ChooseTeamPanel: UIView {
    
    
    // MARK: - Properties
    
    private var homeButton: UIButton!
    private var awayButton: UIButton!
    
    weak var delegate: ChooseTeamPanelDelegate?
    private (set) var selectedTeam: Team?
    
    
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
        
        homeButton = UIButton()
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.backgroundColor = .secondarySystemBackground
        homeButton.layer.cornerRadius = 8
        homeButton.layer.borderColor = UIColor(named: ColorName.DarkBlue)!.cgColor
        homeButton.setTitleColor(UIColor(named: ColorName.DarkBlueText)!, for: .normal)
        homeButton.setTitle(LS_HOME_TEAM, for: .normal)
        homeButton.titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 18)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        addSubview(homeButton)
        
        awayButton = UIButton()
        awayButton.translatesAutoresizingMaskIntoConstraints = false
        awayButton.backgroundColor = .secondarySystemBackground
        awayButton.layer.cornerRadius = 8
        awayButton.layer.borderColor = UIColor(named: ColorName.DarkBlue)!.cgColor
        awayButton.setTitleColor(UIColor(named: ColorName.DarkBlueText)!, for: .normal)
        awayButton.setTitle(LS_AWAY_TEAM, for: .normal)
        awayButton.titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 18)
        awayButton.addTarget(self, action: #selector(awayButtonTapped), for: .touchUpInside)
        addSubview(awayButton)
    }
    
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let padding: CGFloat = 18

        NSLayoutConstraint.activate([
            
            homeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            homeButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -padding / 2),
            homeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            homeButton.topAnchor.constraint(equalTo: topAnchor),
            
            awayButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: padding / 2),
            awayButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            awayButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            awayButton.topAnchor.constraint(equalTo: topAnchor),
            
            ])
    }
    
    
    
    // MARK: - Touch
    
    @objc private func homeButtonTapped() {
        
        guard selectedTeam != Team.Home else { return }
        
        homeButton.layer.borderWidth = 3
        awayButton.layer.borderWidth = 0
        
        selectedTeam = Team.Home
        delegate?.didSelectTeam()
    }
    
    @objc private func awayButtonTapped() {
        
        guard selectedTeam != Team.Away else { return }
        
        homeButton.layer.borderWidth = 0
        awayButton.layer.borderWidth = 3
        
        selectedTeam = Team.Away
        delegate?.didSelectTeam()
    }
    
    
}
