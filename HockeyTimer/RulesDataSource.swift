//
//  RulesDataSource.swift
//  HockeyTimer
//
//  Created by Steven Adons on 25/01/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit

class RulesDataSource: UITableViewDiffableDataSource<Int, Rules> {
    
    
    // MARK: - Properties
    
    private var country: Country!
    private var rules: [[Rules]] = [[]]
    
    
    
    // MARK: - Private Methods
    
    
    
    // MARK: - Public Methods
    
    func configure(_ country: Country) {
        
        self.country = country
        
        for index in 0 ..< country.groupsOfRules.count {
            if let groupOfRulesArray = country.groupsOfRules[index].rulesArray {
                rules.append(groupOfRulesArray)
            }
        }
    }
    
    func configureToZero() {
        
        rules = [[]]
    }
    
    func takeSnapShot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Rules>()
        for section in 0 ..< rules.count {
            snapshot.appendSections([section])
            snapshot.appendItems(rules[section], toSection: section)
        }
        apply(snapshot)
    }
    
    func textColorAt(_ indexPath: IndexPath) -> UIColor {
        
        switch indexPath.section % 5 {
        case 0:
            return .white
        case 1:
            return .white
        case 2:
            return UIColor(named: ColorName.VeryDarkBlue)!
        case 3:
            return UIColor(named: ColorName.VeryDarkBlue)!
        case 4:
            return .white
        case 5:
            return .white
        default:
            fatalError("Trying to get text color for rules button")
        }
    }
    
    func bgColorAt(_ indexPath: IndexPath) -> UIColor {
        
        switch indexPath.section % 6 {
        case 0:
            return UIColor(named: ColorName.Olive)!
        case 1:
            return UIColor(named: ColorName.VeryDarkBlue_Red)!
        case 2:
            return UIColor(named: ColorName.LightYellow)!
        case 3:
            return UIColor(named: ColorName.LightBlue)!
        case 4:
            return UIColor(named: ColorName.DarkBlue)!
        case 5:
            return UIColor(named: ColorName.PantoneRed)!
        default:
            fatalError("Trying to get bg color for rules button")
        }
    }
    
    func alignmentAt(_  indexPath: IndexPath) -> NSTextAlignment {
        
        return .center // (indexPath.section % 2) == 0 ? .left : .right
    }
    
}
