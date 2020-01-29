//
//  GameTimePickers.swift
//  HockeyTimer
//
//  Created by Steven Adons on 08/12/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class GameTimePickers: UIView {

    
    // MARK: - Properties
    
    private var periodsPicker: UIPickerView!
    private var minutesPicker: UIPickerView!
    private var xButton: UIButton!
    private var decimalButton: UIButton!
    
    private var periodsPickerDataSource: PickerDataSource!
    private var minutesPickerDataSource: PickerDataSource!
    
    
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
        
        periodsPicker = UIPickerView()
        periodsPicker.translatesAutoresizingMaskIntoConstraints = false
        periodsPicker.tag = 0
        let periodsData: [Double] = [1, 2, 3, 4]
        periodsPickerDataSource = PickerDataSource(data: periodsData)
        periodsPicker.dataSource = periodsPickerDataSource
        periodsPicker.delegate = periodsPickerDataSource
        addSubview(periodsPicker)

        minutesPicker = UIPickerView()
        minutesPicker.translatesAutoresizingMaskIntoConstraints = false
        minutesPicker.tag = 1
        let minutesData = createMinutes()
        minutesPickerDataSource = PickerDataSource(data: minutesData)
        minutesPicker.dataSource = minutesPickerDataSource
        minutesPicker.delegate = minutesPickerDataSource
        addSubview(minutesPicker)
        
        xButton = UIButton.createTopButton(imageName: "xmark", tintColor: .secondaryLabel)
        xButton.isUserInteractionEnabled = false
        addSubview(xButton)
        
        decimalButton = UIButton()
        decimalButton.translatesAutoresizingMaskIntoConstraints = false
        decimalButton.titleLabel?.numberOfLines = 1
        decimalButton.titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 14)!
        decimalButton.setTitleColor(.secondaryLabel, for: .normal)
        decimalButton.addTarget(self, action: #selector(decimalButtonTapped), for: .touchUpInside)
        decimalButton.setTitle(LS_BUTTON_ADD_HALF_MINUTE, for: .normal)
        addSubview(decimalButton)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let vertRatio: CGFloat = 0.7
        let xButtonWidth: CGFloat = 20
        let pickerWidth: CGFloat = 120
        
        NSLayoutConstraint.activate([
        
            periodsPicker.widthAnchor.constraint(equalToConstant: pickerWidth),
            periodsPicker.trailingAnchor.constraint(equalTo: xButton.leadingAnchor),
            periodsPicker.centerYAnchor.constraint(equalTo: centerYAnchor),
            periodsPicker.heightAnchor.constraint(equalTo: heightAnchor, multiplier: vertRatio),
            
            xButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            xButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            xButton.widthAnchor.constraint(equalToConstant: xButtonWidth),
            xButton.heightAnchor.constraint(equalToConstant: xButtonWidth),

            minutesPicker.leadingAnchor.constraint(equalTo: xButton.trailingAnchor),
            minutesPicker.widthAnchor.constraint(equalToConstant: pickerWidth),
            minutesPicker.centerYAnchor.constraint(equalTo: centerYAnchor),
            minutesPicker.heightAnchor.constraint(equalTo: heightAnchor, multiplier: vertRatio),
            
            decimalButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            decimalButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9),
            
        ])
    }
    
    
    // MARK: - Public Methods
    
    func setPickersTo(_ first: Double, second: Double, animated: Bool) {
        
        if let indexForFirst = periodsPickerDataSource.indexForNumber(first) {
            periodsPicker.selectRow(indexForFirst, inComponent: 0, animated: animated)
        }
        if let indexForSecond = minutesPickerDataSource.indexForNumber(second) {
            minutesPicker.selectRow(indexForSecond, inComponent: 0, animated: animated)
        }
    }
    
    // MARK: - Touch Methods
    
    @objc func decimalButtonTapped() {
        
        let minutesData = createMinutesAndAHalf()
        minutesPickerDataSource = PickerDataSource(data: minutesData)
        minutesPicker.reloadAllComponents()
        
        if minutesPickerDataSource.numberAtIndex(0)!.isInteger {
            decimalButton.setTitle(LS_BUTTON_ADD_HALF_MINUTE, for: .normal)
        } else {
            decimalButton.setTitle(LS_BUTTON_DELETE_HALF_MINUTE, for: .normal)
        }
        
        // Pass info as selection occurred
        let currentPeriodsRow = periodsPicker.selectedRow(inComponent: 0)
        let currentMinutesRow = minutesPicker.selectedRow(inComponent: 0)
        var userInfo: [String : Any] = [:]
        userInfo[GameTimePickersUserInfoKey.Periods] = minutesPickerDataSource.numberAtIndex(currentPeriodsRow)
        userInfo[GameTimePickersUserInfoKey.Minutes] = minutesPickerDataSource.numberAtIndex(currentMinutesRow)
        print("did create userInfo: \(userInfo)")
        NotificationCenter.default.post(name: .CustomTimeSelectionOccurred, object: nil, userInfo: userInfo)
    }
    
    private func switchToIntNumbers() {
        
        let minutesData = createMinutes()
        minutesPickerDataSource = PickerDataSource(data: minutesData)
        minutesPicker.reloadAllComponents()
    }
    
    private func switchToHalfNumbers() {
        
        let minutesData = createMinutesAndAHalf()
        minutesPickerDataSource = PickerDataSource(data: minutesData)
        minutesPicker.reloadAllComponents()
    }
    
    
    // MARK: - Private Methods
    
    private func createLabel(text: String) -> UILabel {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 20)
        label.textAlignment = .center
        label.textColor = .label

        return label
    }
    
    private func createMinutes() -> [Double] {
        
        var result: [Double] = []
        for int in 0 ... 45 {
            result.append(Double(int))
        }
        return result
    }
    
    private func createMinutesAndAHalf() -> [Double] {
        
        var result: [Double] = []
        for int in 0 ... 45 {
            let doubleAndAHalf = Double(int) + 0.5
            result.append(doubleAndAHalf)
        }
        return result
    }
}
